<#
.SYNOPSIS
  Cloudflare Realtime TURN の短期認証情報を生成し、.env の NEKO_ICE_SERVERS に書き込む。

.EXAMPLE
  .\update-turn.ps1                # 有効期限 24時間
  .\update-turn.ps1 -TtlHours 6

.NOTES
  事前に .env へ CF_TURN_KEY_ID / CF_TURN_API_TOKEN を設定しておく (.env.example 参照)。
  実行後に反映するには: docker compose up -d
  認証情報は期限が切れると新規接続できなくなるので、発表の直前に実行する。
#>
[CmdletBinding()]
param(
    [ValidateRange(1, 168)]
    [int]$TtlHours = 24
)

$ErrorActionPreference = 'Stop'
$envPath = Join-Path $PSScriptRoot '.env'

if (-not (Test-Path $envPath)) {
    Write-Error ".env がありません。.env.example をコピーして CF_TURN_KEY_ID / CF_TURN_API_TOKEN を設定してください。"
}

$lines = [System.Collections.Generic.List[string]](Get-Content $envPath -Encoding utf8)

function Get-EnvValue([string]$Name) {
    $m = $lines | Where-Object { $_ -match "^\s*$Name\s*=" } | Select-Object -First 1
    if ($m) { return ($m -replace "^\s*$Name\s*=\s*", '').Trim().Trim("'`"") }
}

$keyId = Get-EnvValue 'CF_TURN_KEY_ID'
$token = Get-EnvValue 'CF_TURN_API_TOKEN'
if (-not $keyId -or -not $token) {
    Write-Error '.env の CF_TURN_KEY_ID / CF_TURN_API_TOKEN が空です。'
}

$uri = "https://rtc.live.cloudflare.com/v1/turn/keys/$keyId/credentials/generate-ice-servers"
$body = @{ ttl = $TtlHours * 3600 } | ConvertTo-Json -Compress

$res = Invoke-RestMethod -Method Post -Uri $uri `
    -Headers @{ Authorization = "Bearer $token" } `
    -ContentType 'application/json' -Body $body

if (-not $res.iceServers) {
    Write-Error 'iceServers が取得できませんでした。キーID/トークンを確認してください。'
}

$json = $res.iceServers | ConvertTo-Json -Depth 5 -Compress
# 配列が1要素のときも配列として扱う
if (-not $json.StartsWith('[')) { $json = "[$json]" }

$newLine = "NEKO_ICE_SERVERS='$json'"
$idx = $lines.FindIndex({ param($l) $l -match '^\s*NEKO_ICE_SERVERS\s*=' })
if ($idx -ge 0) { $lines[$idx] = $newLine } else { $lines.Add($newLine) }

Set-Content -Path $envPath -Value $lines -Encoding utf8
$expires = (Get-Date).AddHours($TtlHours).ToString('yyyy-MM-dd HH:mm')
Write-Host "NEKO_ICE_SERVERS を更新しました (有効期限: $expires)" -ForegroundColor Green
Write-Host '反映: docker compose up -d' -ForegroundColor Cyan
