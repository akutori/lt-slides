<#
.SYNOPSIS
  Cloudflare Quick Tunnel を起動して、ローカルのサーバーを一時公開する。

.EXAMPLE
  .\start-tunnel.ps1                 # Slidev (3030) を公開
  .\start-tunnel.ps1 -Target neko    # n.eko (8080) を公開
  .\start-tunnel.ps1 -Port 8000      # 任意のポートを公開

.NOTES
  - URLを知っていれば誰でもアクセスできる。n.eko はパスワードを必ず設定すること。
  - Ctrl+C で停止する。再起動するとURLは変わる。
  - URLは大きく表示してクリップボードにコピーする。cloudflared の生ログは -Verbose で表示。
#>
[CmdletBinding()]
param(
    [ValidateSet('slidev', 'neko')]
    [string]$Target = 'neko',

    # 指定した場合は -Target より優先
    [int]$Port,

    [ValidateSet('auto', '4', '6')]
    [string]$EdgeIpVersion = 'auto'
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command cloudflared -ErrorAction SilentlyContinue)) {
    Write-Error 'cloudflared が見つかりません。 winget install Cloudflare.cloudflared でインストールしてください。'
}

if (-not $Port) {
    $Port = switch ($Target) {
        'slidev' { 3030 }
        'neko'   { 8080 }
    }
}

$listening = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
if (-not $listening) {
    Write-Warning "localhost:$Port で待ち受けているサーバーがありません。先に起動してください。"
    if ($Port -eq 3030) { Write-Warning '  Slidev: cd 13_n.eko\slidev; npm run dev' }
    if ($Port -eq 8080) { Write-Warning '  n.eko : cd 13_n.eko; docker compose up -d' }
    $answer = Read-Host 'それでもトンネルを起動しますか? (y/N)'
    if ($answer -notin @('y', 'Y')) { exit 1 }
}

$cfArgs = @('tunnel', '--url', "http://localhost:$Port")
if ($EdgeIpVersion -ne 'auto') { $cfArgs += @('--edge-ip-version', $EdgeIpVersion) }

Write-Host "トンネルを起動します: http://localhost:$Port  (Ctrl+C で停止)" -ForegroundColor Cyan

# cloudflared のログは stderr に出る。URLだけ目立たせ、他のログは -Verbose のときだけ表示する。
$ErrorActionPreference = 'Continue'
$urlPattern = 'https://[a-z0-9-]+\.trycloudflare\.com'
$urlShown = $false

& cloudflared @cfArgs 2>&1 | ForEach-Object {
    $line = "$_"

    if (-not $urlShown -and $line -match $urlPattern) {
        $url = $Matches[0]
        $urlShown = $true
        try { Set-Clipboard -Value $url; $copied = '(クリップボードにコピー済み)' } catch { $copied = '' }
        Write-Host ''
        Write-Host '  公開URL' -ForegroundColor Green -NoNewline
        Write-Host " $copied" -ForegroundColor DarkGray
        Write-Host "  $url" -ForegroundColor Black -BackgroundColor Green
        Write-Host ''
        Write-Host '  ※ 接続が確立するまで数秒かかることがある' -ForegroundColor DarkGray
        Write-Host ''
    }
    elseif ($line -match 'Registered tunnel connection') {
        Write-Host '  トンネル接続OK。上のURLにアクセスできます。' -ForegroundColor Cyan
    }
    elseif ($line -match '\bERR\b' -and $line -notmatch 'Failed to initialize DNS local resolver') {
        # 既知の無害な警告(DNS local resolver)は除外
        Write-Host $line -ForegroundColor Red
    }
    elseif ($VerbosePreference -eq 'Continue') {
        Write-Host $line -ForegroundColor DarkGray
    }
}
