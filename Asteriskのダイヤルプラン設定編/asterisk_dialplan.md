---
marp: true
theme: default
paginate: true
---

# Asteriskのダイヤルプラン
## 初心者向け解説

### Asterisk 23対応

---

## 本スライドの対象者

このスライドは以下のような方を対象としています：

- Asteriskの基本的な説明やインストール方法を学んでいる
- ダイヤルプランという言葉は聞いたことがあるが、詳しく知らない
- 実際の設定例を見ながら学びたい

このセッションでは、**ダイヤルプランの「なぜ」と「どうやって」**を理解することを目指します。

---


# ダイヤルプランとは？

---


## ダイヤルプランの役割

Asteriskは複数の外線や内線を管理するPBX（電話交換機）です。

**ダイヤルプラン** = 電話がかかってきた時に「どう処理するか」を記述したルール集

### 日常の例え

固定電話の自動応答機を思い出してください：

```
ガイダンス: 営業は1番、サポートは2番を押してください
→ ここで「ルール」に基づいて振り分けが発生
```

---

Asteriskのダイヤルプランも同じ考え方です。電話がかかってきた時に、その電話に対して：

- 誰に繋ぐか
- 何の処理をするか
- 音声を再生するか
- 録音するか

...などを決めているのがダイヤルプランです。


---


## ダイヤルプランの重要性

| 機能 | 説明 |
|------|------|
| **ルーティング** | 電話をどこに繋ぐかを決める |
| **IVR** | 自動応答システムの実現 |
| **通話制御** | 通話の許可/拒否や時間制限 |
| **ログ記録** | 通話情報の記録と処理 |
| **セキュリティ** | 不正な通話を防止 |

ダイヤルプランなしでは、Asteriskは電話がかかってきても何もできません。



---



# ダイヤルプランの基本概念



---



## 3つの基本要素

Asteriskのダイヤルプランは以下の3つから構成されます：

### 1. **コンテキスト (Context)**
電話がどこから来たかを示す「グループ分け」

### 2. **拡張子 (Extension)**
受け取った番号パターン。この番号にマッチした時に処理を実行

### 3. **アプリケーション (Application)**
実際に実行する処理。音声再生、通話接続など



---



## コンテキストの役割

```
[内線ユーザー用]      [外線接続用]     [IVR用]
    ↓                   ↓              ↓
context: users   context: external  context: ivr
```

同じ拡張子番号でも、コンテキストが違えば別の処理ができます。

### 実例

```ini
[users]
exten => 200,1,Dial(SIP/200)

[external]
exten => 200,1,Voicemail(200@mailbox)
```

同じ200番でも、どのコンテキストから来たかで処理が変わります。



---



## 拡張子 (Extension) の概念

**拡張子** = マッチさせたい番号のパターン

### パターンマッチングの例

| パターン | マッチする番号 | マッチしない番号 |
|---------|---------------|-----------------|
| `201` | 201 | 202, 2010 |
| `20X` | 201～209 | 200, 211 |
| `2XX` | 200～299 | 199, 300 |
| `_2.` | 21, 29など（任意1文字） | 2, 211 |
| `_[1-5]XX` | 100～599 | 099, 600 |

Asteriskはこれらのパターンを上から順番に照合します。



---



## 優先度 (Priority) の概念

アプリケーション実行時の「順序番号」

```ini
[context]
exten => 200,1,Answer()          ; 優先度1：応答
exten => 200,2,Playback(hello)   ; 優先度2：音声再生
exten => 200,3,Hangup()          ; 優先度3：切断
```

各行は必ず連続した番号を持つ必要があります。

### n をを使った書き方

```ini
exten => 200,1,Answer()
exten => 200,n,Playback(hello)   ; n = 次の番号（2）
exten => 200,n,Hangup()          ; n = 次の番号（3）
```

実務では`n`を使う方が便利です。



---



# ダイヤルプランで使用する変数



---



## チャネル変数の基本

Asteriskでは様々な情報を変数として使用できます。

### よく使う標準変数

| 変数 | 説明 | 例 |
|------|------|-----|
| `${EXTEN}` | マッチした拡張子番号 | 200 |
| `${CONTEXT}` | 現在のコンテキスト | users |
| `${CALLERID(num)}` | 発信者番号 | 0312341234 |
| `${CALLERID(name)}` | 発信者名 | Yamada Taro |
| `${CHANNEL}` | 現在のチャネル | SIP/200-00000001 |



---



## 変数の設定と使用

### 変数の設定

```ini
exten => 200,n,Set(MYVAR=hello)        ; 変数設定
exten => 200,n,Set(COUNT=${COUNT}+1)   ; 計算
exten => 200,n,Set(NAME=Yamada)        ; 文字列
```

### 変数の参照

```ini
exten => 200,n,SayNumber(${EXTEN})          ; 番号を音声化
exten => 200,n,Playback(${GREETING})        ; 変数の内容を再生
exten => 200,n,Log(NOTICE,Caller=${CALLERID(num)}) ; ログ出力
```

変数は `${}` で囲んで参照します。



---



## グローバル変数

すべてのコンテキストで使用可能な変数は `extensions.conf` の冒頭で定義：

```ini
[globals]
COMPANY_NAME=Yamada Corp
MAINLINE=0312341234
GREETING=welcome-jp
```

その後、どのコンテキストからでも参照可能：

```ini
[users]
exten => 100,n,Playback(${GREETING})

[external]
exten => 100,n,Log(NOTICE,Company=${COMPANY_NAME})
```



---



# ダイヤルプラン設定ファイルの構造



---

## extensions.conf の全体像

```ini
[globals]
COMPANY_NAME=Example Corp
MAINLINE=0312341234

[users]
exten => 200,1,Answer()
exten => 200,n,Playback(hello)
exten => 200,n,Hangup()

[external]
exten => 100,1,Dial(SIP/200)
exten => 100,2,Voicemail(200@mailbox)

[ivr]
exten => _1.,1,Answer()
exten => _1.,n,Playback(welcome-jp)
exten => _1.,n,Hangup()
```

基本的には **[コンテキスト名]** で囲まれたセクション内に設定を記述します。



---



## コメントと構文の約束

```ini
; これはコメント。セミコロンで始まる行は無視される

; ダイヤルプランの構文
[context_name]
exten => <パターン>,<優先度>,<アプリケーション>(<引数>)

; 改行の場合は \ でつなげる
exten => 200,n,Playback(${GREETING}),\
              Hangup()
```

構文エラーがあるとAsteriskは起動時に警告を出します。



---



# 実践的なダイヤルプラン例



---



## 例1：シンプルな内線ダイヤル

```ini
[users]
; 内線200への通話
exten => 200,1,Answer()
exten => 200,n,Log(NOTICE,Call from ${CALLERID(num)})
exten => 200,n,Dial(SIP/200,20)
exten => 200,n,Voicemail(200@mailbox)
exten => 200,n,Hangup()
```

**動作の流れ**

1. 200番にかかってきた
2. ログに記録
3. SIP 200端末に20秒間呼出
4. 出なければボイスメール
5. 切断



---



## 例2：番号による振り分け IVR

```ini
[ivr_main]
exten => 100,1,Answer()
exten => 100,n,Playback(welcome-jp)         ; ガイダンス再生
exten => 100,n,WaitExten(5)                 ; 5秒待機

exten => 1,1,Playback(routing-to-sales)
exten => 1,n,Dial(SIP/sales-group)

exten => 2,1,Playback(routing-to-support)
exten => 2,n,Dial(SIP/support-group)

exten => 0,1,Playback(routing-to-receptionist)
exten => 0,n,Dial(SIP/receptionist)

exten => i,1,Playback(invalid-input)        ; i = 無効入力
exten => i,n,Goto(ivr_main,100,1)          ; メニューに戻る
```



---



## 例3：外線ダイヤル

```ini
[outgoing]
; 外線への発信を制御

exten => _0X.,1,Log(NOTICE,Outbound call to ${EXTEN})
exten => _0X.,n,Dial(SIP/provider/${EXTEN:1},30)
exten => _0X.,n,Congestion()

exten => _9X.,1,Log(NOTICE,International call to ${EXTEN})
exten => _9X.,n,Dial(SIP/intl-provider/${EXTEN:1},45)
exten => _9X.,n,Congestion()
```

**パターンの説明**

- `_0X.` = 0で始まる国内番号（0から始まる任意の番号）
- `${EXTEN:1}` = 先頭の1文字を削除（0を除いて送信）
- 30秒または45秒で応答待機



---



## 例4：条件分岐の使用

```ini
[conditional]
exten => 300,1,Answer()
exten => 300,n,Set(HOUR=${STRFTIME(${EPOCH},%H)})

; 営業時間（9時～18時）の判定
exten => 300,n,GotoIf($[${HOUR} >= 9 & ${HOUR} < 18]?business:closed)

exten => 300,n(business),Log(NOTICE,Business hours)
exten => 300,n,Dial(SIP/200,20)
exten => 300,n,Voicemail(300@mailbox)
exten => 300,n,Hangup()

exten => 300,n(closed),Log(NOTICE,After business hours)
exten => 300,n,Playback(closed-message-jp)
exten => 300,n,Hangup()
```

**GotoIf の使い方**

```
GotoIf($[条件]?yes:no)
条件が真 → yes ラベルへ
条件が偽 → no ラベルへ
```



---



## 例5：複雑なコールフロー

```ini
[main_context]
; キューを使用した負荷分散

exten => 200,1,Answer()
exten => 200,n,Playback(welcome-jp)
exten => 200,n,Queue(sales-queue)
exten => 200,n,Voicemail(200@mailbox)
exten => 200,n,Hangup()

; 他のコンテキストで agents を定義
exten => 1000,1,AddQueueMember(sales-queue,SIP/200)
exten => 1001,1,RemoveQueueMember(sales-queue,SIP/200)
```

**Queue の特徴**

- 複数のエージェントで通話を分配
- 待機中に音楽を再生
- 統計情報を記録



---



# よく使う主要アプリケーション



---



## 基本的なアプリケーション

| アプリケーション | 説明 |
|-------------|------|
| `Answer()` | 電話に応答する |
| `Hangup()` | 通話を切断する |
| `Playback(filename)` | 音声ファイルを再生 |
| `SayNumber(number)` | 数字を音声化して読み上げ |
| `Dial(target,timeout)` | 別の端末や電話番号に繋ぐ |
| `Voicemail(mailbox)` | ボイスメールに接続 |
| `Goto(context,exten,priority)` | 別のステップへジャンプ |
| `GotoIf(condition?yes:no)` | 条件分岐 |
| `WaitExten(seconds)` | 入力待機 |
| `Set(var=value)` | 変数を設定 |
| `Log(level,message)` | ログを出力 |



---



## 通話制御アプリケーション

| アプリケーション | 説明 |
|-------------|------|
| `Queue(queue_name)` | コールキューに入れる |
| `Transfer(exten)` | 通話を転送 |
| `ConfBridge(conference_name)` | 会議室に接続（モダン方式） |
| `Record(filename)` | 通話を録音 |
| `Busy()` | ビジー信号を返す |
| `Congestion()` | 輻輳信号を返す |



---



## ConfBridge：モダンな会議室機能

Asterisk 23 では **MeetMe は非推奨**です。かわりに **ConfBridge** を使用してください。

### MeetMe の問題点

- DAHDI モジュール（ハードウェア音声カード）への依存
- 古いアーキテクチャで今後のメンテナンスが不確実
- 最新の SIP プロトコルとの相性が低い

### ConfBridge の利点

- ✓ **DAHDI 不要**：ソフトウェアベースで動作
- ✓ **モダン設計**：Asterisk 12以降で標準機能
- ✓ **豊富な機能**：参加者管理、録音、待機音楽
- ✓ **細かいカスタマイズ**：confbridge.conf で設定可能



---



## ConfBridge 設定例

まず confbridge.conf で会議プロファイルを定義：

```ini
[general]
; グローバル設定

[default_bridge]
type=bridge
video_source_talking_priority=yes
record_conference=yes

[default_user]
type=user
```

次に extensions.conf でダイヤルプランに統合：

```ini
[conference]
; 会議番号：600
exten => 600,1,Answer()
exten => 600,n,ConfBridge(600,default_bridge,default_user)
exten => 600,n,Hangup()

; 別の会議番号：601（管理者用）
exten => 601,1,Answer()
exten => 601,n,ConfBridge(601,default_bridge,default_user)
exten => 601,n,Hangup()
```

これで複雑な設定なしに会議室が実現できます。



---



## ステップバイステップ

```
1. 要件整理
   ↓
2. extensions.conf に設定を記述
   ↓
3. dialplan reload で設定をリロード
   ↓
4. dialplan show コマンドで確認
   ↓
5. テスト通話で動作確認
   ↓
6. ログを確認して問題解決
```



---



## 実装時の確認コマンド

### 設定ファイルの構文確認

```bash
asterisk -C /etc/asterisk/asterisk.conf -n
```

### Asterisk CLIでの確認

```
asterisk> dialplan show                    ; 全ダイヤルプラン表示
asterisk> dialplan show context_name       ; 特定コンテキスト表示
asterisk> core set debug 1                 ; デバッグON
asterisk> core set debug 0                 ; デバッグOFF
asterisk> log tail                         ; ログ表示
```

### 設定のリロード

```
asterisk> dialplan reload                  ; ダイヤルプラン再読み込み
```



---



# Extensions.conf の管理ベストプラクティス



---



## ファイル分割戦略

extensions.conf が大きくなると保守が難しくなります。**機能ごとにファイルを分割して管理する**ことが重要です。

### ディレクトリ構成の例

```
/etc/asterisk/
├── extensions.conf          ; メインファイル（インクルード指定のみ）
├── extensions/
│   ├── globals.conf         ; グローバル変数定義
│   ├── users.conf           ; 内線ユーザー関連
│   ├── external.conf        ; 外線関連
│   ├── ivr.conf             ; IVR（自動応答）
│   ├── conference.conf      ; 会議室
│   ├── voicemail.conf       ; ボイスメール
│   └── emergency.conf       ; 緊急通話
```

### Extensions.conf の中身（マスターファイル）

```ini
; メインのextensions.conf はインクルード指定のみ
#include "extensions/globals.conf"
#include "extensions/users.conf"
#include "extensions/external.conf"
#include "extensions/ivr.conf"
#include "extensions/conference.conf"
#include "extensions/voicemail.conf"
#include "extensions/emergency.conf"
```

このアプローチにより、各機能が独立していて編集や追加が容易になります。



---



## Extensions ファイルの具体例

### globals.conf：グローバル変数

```ini
[globals]
; 会社情報
COMPANY_NAME=Yamada Corp
COMPANY_PHONE=0312341234

; デフォルトタイムアウト
DIAL_TIMEOUT=20
VOICEMAIL_TIMEOUT=10

; 営業時間設定
BUSINESS_START=09
BUSINESS_END=18

; 音声ファイルのデフォルト言語
DEFAULT_LANG=jp
```

### users.conf：内線関連

```ini
[users]
; 内線200～250 の処理
exten => 200,1,Answer()
exten => 200,n,Dial(SIP/200,${DIAL_TIMEOUT})
exten => 200,n,Voicemail(200@mailbox)

exten => 201,1,Answer()
exten => 201,n,Dial(SIP/201,${DIAL_TIMEOUT})
exten => 201,n,Voicemail(201@mailbox)

; パターンマッチで 200～250 をまとめて定義することも可能
exten => _2[0-4][0-9],1,Answer()
exten => _2[0-4][0-9],n,Dial(SIP/${EXTEN},${DIAL_TIMEOUT})
exten => _2[0-4][0-9],n,Voicemail(${EXTEN}@mailbox)
```

### external.conf：外線関連

```ini
[external]
; 外線接続の定義
exten => _0X.,1,Log(NOTICE,Outbound call to ${EXTEN})
exten => _0X.,n,Set(OUTGOING_CHANNEL=SIP/provider)
exten => _0X.,n,Dial(${OUTGOING_CHANNEL}/${EXTEN:1},${DIAL_TIMEOUT})
exten => _0X.,n,Congestion()
```

ファイルを分割することで、特定の機能を修正する際に他の設定への影響を最小化できます。



---



## バージョン管理とバックアップ

重要な設定ファイルは**必ずバージョン管理** and **バックアップ**を行ってください。

### バックアップの方法

```bash
; 日次バックアップスクリプト例
#!/bin/bash

BACKUP_DIR="/var/backups/asterisk"
DATE=$(date +%Y%m%d_%H%M%S)

# extensions.conf 全体をバックアップ
cp -r /etc/asterisk/extensions* "${BACKUP_DIR}/extensions_${DATE}.tar.gz"

; 古いバックアップは7日後に削除
find "${BACKUP_DIR}" -type f -name "extensions_*.tar.gz" -mtime +7 -delete
```

### Git で管理する場合

```bash
cd /etc/asterisk

; .gitignore に以下を追加
cat > .gitignore << 'EOF'
*.bak
*.swp
*~
.DS_Store
EOF

; リポジトリ初期化
git init
git add .
git commit -m "Initial asterisk configuration"

; 変更時のワークフロー
git add extensions/*
git commit -m "Add new IVR context for conference"
git tag v1.2.3
```

バージョン管理により、問題が発生した際に以前の設定に戻すことが容易になります。



---



## ドキュメンテーション

各ファイルの先頭に目的と構成を記述してください。

### 良いドキュメンテーション例

```ini
; ==================================================
; users.conf - 内線ユーザー定義
; ==================================================
; 目的：
;   内線 200～250 のユーザーに関連した
;   ダイヤルプラン処理を定義
;
; 主な機能：
;   - SIP/200 から SIP/250 へのダイヤル処理
;   - 自動ボイスメール接続
;   - 営業時間外の転送
;
; 最終更新：2024年3月3日
; 更新者：Admin
; 変更内容：IVR統合による転送ロジック改善
;
; 依存ファイル：
;   - globals.conf (DIAL_TIMEOUT, BUSINESS_* を使用)
;   - voicemail.conf (ボイスメールコンテキスト)
;
; テスト方法：
;   1. dialplan reload で設定をリロード
;   2. 内線 200 に外部から電話をかける
;   3. 通話が正常に接続されることを確認
; ==================================================

[users]
; 以下の拡張子を定義
; 200～250：内線ユーザー
```

ドキュメントにより、後から維持管理する際に素早く理解できます。



---



## テスト環境の構築

本番環境に直接的な影響を与えないようにテスト環境を用意することが重要です。

### テスト用の別コンテキスト

```ini
; extensions.conf で、テスト用のコンテキストを用意
[test_ivr]
; 開発中のIVRをテスト
exten => 100,1,Answer()
exten => 100,n,Playback(test-greeting)
exten => 100,n,WaitExten(5)
exten => 1,1,Dial(SIP/200)
exten => 2,1,Dial(SIP/201)

; テスト用の内線
[test_users]
exten => 999,1,Answer()
exten => 999,n,Playback(test-environment)
exten => 999,n,Hangup()
```

本番環境にどのコンテキストが有効か明確にしておくことで、ミスを防げます。

### リロード時の安全確認

```bash
; リロード前に構文チェック
asterisk -C /etc/asterisk/asterisk.conf -n

; リロードを実行
asterisk -rx "dialplan reload"

; 結果を確認
asterisk -rx "dialplan show" | head -20
```





---



## 設定時の注意点

### 1. コンテキスト名は分かりやすく

```ini
; ✗ 悪い例
[ctx1]
[ctx2]

; ✓ 良い例
[users]
[external]
[ivr_main]
```

### 2. コメントを充実させる

```ini
; 営業時間のIVR (9:00-18:00)
[ivr_business_hours]
exten => 100,1,Answer()
; 現在時刻を取得して判定
exten => 100,n,Set(HOUR=${STRFTIME(${EPOCH},%H)})
```

### 3. 段階的にテストする

1. シンプルな例から始める
2. 動作確認後に機能を追加
3. 複雑なロジックは小分けにする



---



## よくあるミスと対策

| ミス | 原因 | 対策 |
|------|------|------|
| 優先度の番号がずれている | 手動入力ミス | `n` を使う |
| パターンマッチの順序が逆 | 先に詳しいパターンが必要 | より具体的なパターンを上に |
| 変数が空になる | スコープ違い | グローバル変数を使う |
| 無限ループ | Goto の目的地が誤り | ラベル名を確認 |



---



# まとめ



---



## ダイヤルプランの本質

ダイヤルプランは、**電話がかかってきた時の「処理の流れ」を定義するもの**です。

### 3つの基本要素の関係

```
コンテキスト（どこから来たか）
    ↓
拡張子（どの番号にマッチしたか）
    ↓
アプリケーション（何をするか）
```

### 次のステップ

1. シンプルな内線接続から始める
2. IVRや振り分けロジックを追加
3. キューやボイスメールを統合
4. 複雑な通話フローを実装

**実際に設定してみることが、最も効果的な学習方法です！**



---



## 参考リソース

- Asterisk公式ドキュメント
  https://docs.asterisk.org/

- Dialplan Applications リファレンス
  https://docs.asterisk.org/Asterisk_23/Application_Reference

- コミュニティフォーラム
  https://forums.asterisk.org/

- この設定ファイルの場所
  `/etc/asterisk/extensions.conf`



---



# ご質問はありますか？


