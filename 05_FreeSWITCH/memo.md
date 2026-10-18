# memo: FreeSWITCH

## 前提(想定時間・枚数・ツール・作成日)

- 想定時間: 10分(AkarengaLT 第50回)
- 枚数: 10枚(タイトル1、見出し3、本文5、まとめ1)
- ツール: Marp(marp-cli 4.5.1、統括提供のラッパー経由)。フロントマターで Noto Sans CJK JP を明示。図は Mermaid を lt-mmdc で PNG 化(画像/構成.png、元は mermaid/構成.mmd)
- 作成日・出典の確認日: 2026-10-10(BRIEF の確認日 2026-10-09 から、今日の日付に更新)
- セリフ: 各スライドの HTML コメント(1行1コメント)。合計 2372字(空白除く。差し込みの指示行2行 70字を含む。除くと 2302字)。1分300字なら約8分で、息継ぎと言い直しの余裕を足して10分に収める想定。スライド6は動作結果の説明があり、他より長い(約420字)
- 画像: 構成図のみ。FreeSWITCH のロゴ・マスコット・公式画像は使っていない
- 版情報: 最新のリリースは v1.11.3(タグのコミット日 2026-08-28、GitHub で Latest 表示)。スライドは「2026年8月公開、2026年10月時点」
- 話の軸: シードの5部構成(FreeSWITCHとは / できること / 入れ方 / ハマりどころ / まとめ)を、10枚に収めるため3組に整理した。「入れ方」と「ハマりどころ」は1組(スライド7〜9)にまとめた
- 他の LT を前提にしていない。Kamailio は「SIP の振り分け役」として、スライド3の1行とセリフ3行だけ

## 構成メモ(スライド番号 / 種別 / 要旨)

| 番号 | 種別 | 要旨 |
|---|---|---|
| 1 | タイトル | 「FreeSWITCH」のみ。電話をつなぐだけでなく通話の中身(音声・FAX)も扱うソフトと紹介。流れは3つ(位置づけ、できること、入れ方)。出力は検証環境で取った結果と予告 |
| 2 | 見出し | FreeSWITCHとは |
| 3 | 本文 | 定義(公式の説明は「ソフトウェアのスイッチング基盤」。音声・映像・テキスト)、設定は XML、標準設定は SIP PBX、MPL 1.1、最新リリース v1.11.3、読み方は公式に記載なし、Kamailio は SIP サーバーで規模拡大に使える(Kamailio 公式) |
| 4 | 見出し | 通話の中身を扱う機能 |
| 5 | 本文(図) | 位置づけの概念図(電話機など→FreeSWITCH→ダイヤルプラン→モジュール、外部プログラムは Event Socket)。IVR(ivr アプリケーション)、FAX(mod_spandsp)、録音(record_session)、会議(mod_conference)、外部制御(mod_event_socket) |
| 6 | 本文(出力) | Event Socket に送った2つの命令と、疑似の通話で得た実際の出力(成功と失敗)。切断理由が同じ NORMAL_CLEARING でも、fax_success とページ数が違う。確認の順は発表者の設計案(運用実績なし)。差し込み欄あり |
| 7 | 見出し | 入れ方とつまずきやすい点 |
| 8 | 本文 | 入れ方2通り。パッケージは SignalWire の Personal Access Token が必要、ソースビルドは不要(公式)。パッケージが最短、パッケージにないモジュールはソースから(公式)。発表者の経験(Docker、Ubuntu 22.04、モジュールの有無の差) |
| 9 | 本文 | 依存ライブラリの版(v1.11.3 の configure.ac)。spandsp 3.1.1 以上、sofia-sip 1.13.18 以上、既定のモジュール一覧では libks2 2.0.11 以上と signalwire-c 2.0.0 以上も。v1.10.12 の spandsp は 3.0 以上。Ubuntu 22.04 の標準パッケージは 0.0.6。Debian 11 は対象外(v1.11.3 のリリースノート)。差し込み欄あり |
| 10 | まとめ | 5項目(定義、モジュールとダイヤルプラン、Event Socket と FAX の成否、入れ方、依存ライブラリの版) |

構成上の判断

- シードの「ソフトスイッチ」という語は使っていない。公式ドキュメント(docs リポジトリ全体)に出てこないため。公式の表現「ソフトウェアのスイッチング基盤」を使った
- ライブデモに頼らない。コマンド2行と実際の出力をスライド6に載せた
- スライド5の図は、高さ指定ではなく `![bg right:36% fit]` で右側に配置した(はみ出しを避けるため。目視で収まりを確認済み)
- スライド6の確認の順は、シードの「SIPの hangup_cause → T.30 の fax_success → ページ数」を、スライドでは「切断理由、FAX の成否(T.30)、ページ数」と書いた。出力は SIP ではなく loopback の通話なので、「SIP の」は付けていない
- 英語の変数名(fax_success など)はセリフで読み上げず、画面を指す

## 出典一覧(URL | 確認日 | 何の裏付けか)

公開ページは 2026-10-10 に WebFetch で取得して確認した。文言の細部は、公式ドキュメントのリポジトリ signalwire/freeswitch-docs(shallow clone、コミット 0b1d23e、2026-10-08)のソースと、FreeSWITCH 本体のリポジトリ(タグ v1.11.3、コミット ef32e20)で照合した。

スライドの footer に載せたもの(16件)

| URL | 確認日 | 何の裏付けか |
|---|---|---|
| https://developer.signalwire.com/freeswitch/foundations/introduction | 2026-10-10 | 公式マニュアル第1章。冒頭の説明(音声・映像・テキスト通信のソフトウェアのスイッチング基盤)、オープンソースで無料で使える旨、商用サポート版 Enterprise の存在。「設定は XML」「標準の設定は SIP PBX として動作」は docs リポジトリのソース(foundations/introduction.mdx)で確認 |
| https://github.com/signalwire/freeswitch/blob/v1.11.3/LICENSE | 2026-10-10 | ライセンス。1行目付近に「License: MPL-1.1」(Files: * の既定)。全文は Mozilla Public License 1.1。pocketsphinx は BSD-2-clause、debian/* は MPL-1.1 または GPL-2+ と別記 |
| https://github.com/signalwire/freeswitch/releases/tag/v1.11.3 | 2026-10-10 | リリース v1.11.3。「Latest」表示、公開日の表示は「28 Aug」(年なし)。ノートに「Debian 11 Bullseye has been dropped」。「[GHA] Drop bullseye from CI」の項目あり |
| https://www.kamailio.org/w/ | 2026-10-10 | Kamailio は Open Source SIP Server(GPLv2+)。welcome 文に、SIP-to-PSTN ゲートウェイ・PBX・メディアサーバー(Asterisk、FreeSWITCH、SEMS を例示)の規模拡大に使える旨の記載 |
| https://www.rfc-editor.org/rfc/rfc3261 | 2026-10-10 | SIP の説明(セッションを作成・変更・終了する応用層の制御プロトコル)。セリフの言い換え「通話を始めたり終えたりする取り決め」の根拠 |
| https://developer.signalwire.com/freeswitch/applications/ivr-menus | 2026-10-10 | IVR は、XML で定義するメニューを ivr アプリケーションで呼ぶ(mod_dptools) |
| https://developer.signalwire.com/freeswitch/applications/fax | 2026-10-10 | mod_spandsp が rxfax・txfax を提供、結果変数(fax_success、fax_result_code は T.30 の完了コード、fax_document_transferred_pages など)、T.38 対応 |
| https://developer.signalwire.com/freeswitch/applications/conferencing | 2026-10-10 | 会議は mod_conference が提供 |
| https://developer.signalwire.com/freeswitch/dialplan/dptools | 2026-10-10 | ダイヤルプランのアプリケーション一覧。record_session は通話(両方向)のバックグラウンド録音。ivr、conference も掲載 |
| https://developer.signalwire.com/freeswitch/integration/event-socket | 2026-10-10 | mod_event_socket(Event Socket)。TCP でコマンド送信とイベント受信。inbound と outbound。fs_cli は inbound を使う。既定のポートは 8021 |
| https://www.itu.int/rec/T-REC-T.30/en | 2026-10-10 | ITU-T T.30 の題名「Procedures for document facsimile transmission in the general switched telephone network」。セリフの言い換え「FAXの通信手順を定めた規格」の根拠 |
| https://developer.signalwire.com/freeswitch/foundations/getting-started | 2026-10-10 | パッケージは SignalWire Personal Access Token が必要、ソースビルドは不要。Debian・Ubuntu ではパッケージが最短(原文は「the fastest path」)。パッケージにないモジュールが要るときは Git からビルド。ソースビルドは C ツールチェーンとビルド依存が必要 |
| https://github.com/signalwire/freeswitch/blob/v1.11.3/configure.ac | 2026-10-10 | v1.11.3 の依存: spandsp 3.1.1 以上、sofia-sip-ua 1.13.18 以上(公開ページで確認)。libks2 2.0.11 以上(または libks 1.8.2 以上)、signalwire_client2 2.0.0 以上(または signalwire_client 1.0.0 以上)は、ページの表示が1000行までのため、タグ v1.11.3 の clone で確認(1565行目と1581行目)。mod_verto・mod_signalwire が有効なときに必須 |
| https://github.com/signalwire/freeswitch/blob/v1.10.12/configure.ac | 2026-10-10 | v1.10.12 の spandsp は 3.0 以上(公開ページで確認) |
| https://github.com/signalwire/freeswitch/blob/v1.11.3/build/modules.conf.in | 2026-10-10 | 既定のモジュール一覧(v1.11.3)で mod_verto、mod_signalwire、mod_spandsp、mod_sofia、mod_conference、mod_event_socket、mod_dptools が有効。タグ v1.11.3 の clone で確認(公開ページは WebFetch していない) |
| https://packages.ubuntu.com/jammy/libspandsp-dev | 2026-10-10 | Ubuntu 22.04(jammy)の libspandsp-dev は 0.0.6+dfsg-2(universe) |

スライドには載せず、確認や質問対応に使ったもの

| URL | 確認日 | 何の裏付けか |
|---|---|---|
| https://github.com/signalwire/freeswitch | 2026-10-10 | リポジトリの About は「Software Defined Telecom Stack」。README に読み方の記載なし。ライセンス名の表示は取得結果になし |
| https://github.com/signalwire/freeswitch/releases | 2026-10-10 | 取得結果は v1.11.2(09 Aug)が Latest と表示。v1.11.3 のタグ頁と食い違う(下の⚠️を参照) |
| git ls-remote(github.com/signalwire/freeswitch の v1.11* タグ) | 2026-10-10 | v1.11.0、v1.11.1、v1.11.2、v1.11.3 が存在。v1.11.3 は ef32e20、コミット日 2026-08-28 |
| FreeSWITCH 本体の README.md(タグ v1.11.3) | 2026-10-10 | 「Software Defined Telecom Stack」。パッケージ版のインストール手順や SignalWire との関係 |
| freeswitch-docs の docs/applications/ivr-menus.mdx、docs/integration/event-socket.mdx など | 2026-10-10 | IVR のメニューは入れ子にできる、Event Socket の既定値(ポート 8021、listen-ip の既定、ACL)、fs_cli の接続方法 |

## ⚠️ 出典なし・未確認の情報

- 読み方「フリースイッチ」: 公式に記載なし(マニュアル第1章、GitHub の README で確認、記載なし)。慣用。スライド3とセリフで「公式に記載なし」と断ったうえで、この発表の呼び方を宣言している
- 「ソフトスイッチ」: シードにある語だが、公式ドキュメントに出てこないためスライド・セリフに使っていない
- 最新のリリース v1.11.3 の扱い: GitHub の releases 一覧を WebFetch した結果は v1.11.2 が Latest だった(取得結果が古い可能性)。v1.11.3 のリリース頁は「Latest」表示で、git ls-remote でもタグ v1.11.3(2026-08-28)が確認できたため、v1.11.3 を採用した。GitHub API は 403 で取得できなかった。発表の直前に releases の表示を確認してほしい
- リリース日: リリース頁の表示は「28 Aug」で年の表示がない。タグのコミット日 2026-08-28 で補い、スライドは「2026年8月公開」とした
- 「Debian 11 は対象外(dropped)」: v1.11.3 のリリースノートの1文のみ。何の対象外か(CI、パッケージなど)は明記がない。同じノートに「Drop bullseye from CI」の項目がある。スライドは「対象外」とだけ書いた。シードの「EOL になった OS を使う場合の影響」は、公式の記載から確認できた範囲(Debian 11 の除外)にとどめた
- 構成図(スライド5): 公式マニュアル第1章の説明と、各章の記載にもとづく概念図。実機の通信を観測したものではない
- Kamailio の説明: 「SIP の振り分け役」はシードの表現。公式の表現は「Open Source SIP Server」。スライドは公式の表現にした。セリフでは「SIPの振り分け役」と言う
- 発表者の経験(スライド8): 「Docker(Ubuntu 22.04)でソースからビルドした」「パッケージとはモジュールの有無に差があった」は、シードの記載のみ。裏取りしていない。モジュールの有無の具体的な差は不明(スライドにもセリフにも書いていない)
- 「確認の順(設計案)」: 切断理由、FAX の成否、ページ数の順は、シードにある発表者の設計。公式ドキュメントにこの順の推奨はない(各変数の定義のみ公式)。運用実績はない。スライドは「設計案」、セリフは「設計の検討で、運用した話ではありません」と断っている
- スライド6の出力は疑似の通話(loopback)の結果。実際の電話回線、FAX機、T.38、SIP 経由の通話では確認していない。成否の判断がそれらでも同じとは限らない
- Ubuntu 22.04 の libspandsp-dev 0.0.6: packages.ubuntu.com の表示。発表者の Docker 環境で実際に入った版は未確認
- 動作確認は Ubuntu 24.04 で行い、発表者の環境(Docker、Ubuntu 22.04)とは異なる
- 公式ドキュメントの公開ページは、docs リポジトリのソースと一致している範囲で確認した。公開ページが常にソースと同期しているかは未確認

発表者に確認したい点

- 読みを「フリースイッチ」で進めてよいか(スライド3とセリフで統一している)
- 差し込み欄2か所(下記)を話すか、削るか。削る場合は、スライドの行とセリフの行を削除してよい(前後の事実だけで話は通る)
- スライド8の「発表者の経験」2行が、事実と合っているか(Docker、Ubuntu 22.04、パッケージとのモジュールの差)。差の具体例があれば、差し込み欄として追加できる
- 「確認の順(設計案)」を、発表者自身の設計として話してよいか
- 「公式: Debian・Ubuntu ではパッケージが最短」は公式の原文の言い換え。評価語としてそのまま使ってよいか
- 発表までに、実際の FAX 機や回線で試すか(試した場合は、スライド6の「実回線は未使用」とセリフ「試していません」を書き換える)

## 差し込み欄(スライド番号 | 何を入れるか)

| スライド | 何を入れるか |
|---|---|
| 6 | スライド: 【差し込み: 実際に FAX を送受信できたか、使ってみた感想】。セリフ: (※ここで実体験を話す: 実際にFAXを送受信できたか、使ってみた感想について)。シードに実績の記載がないため、差し込み欄にした。話さない場合は、スライドの行とセリフの行を削除する。セリフは「実際の電話回線やFAX機では、試していません」と述べており、削除しても矛盾しない |
| 9 | スライド: 【差し込み: ビルドで詰まった点】。セリフ: (※ここで実体験を話す: ビルドで実際に詰まった点について)。シードにビルドで詰まった具体的な点の記載がないため、差し込み欄にした。話さない場合は、両方の行を削除する |

## 動作確認(実行したもの / 未実行とその理由 / バージョン / 環境)

実行したもの(2026-10-10)

- FreeSWITCH の起動: `freeswitch -nc -nf -nonat -temp <作業用の tmp>`。前回の担当が 2026-10-09 にビルド・インストールした成果物を再利用した(再ビルドはしていない)。モジュールは mod_console、mod_logfile、mod_event_socket、mod_loopback、mod_commands、mod_conference、mod_dptools、mod_dialplan_xml、mod_tone_stream、mod_spandsp のみロード。mod_sofia はビルド済みだがロードしていない。Event Socket は 127.0.0.1:18021(既定の 8021 ではない。共有環境のため)。システムへのインストールや、作業用ディレクトリ外のファイル変更はしていない
- fs_cli で接続: `fs_cli -H 127.0.0.1 -P 18021 -x "status"` は「FreeSWITCH (Version 1.11.3-release git ef32e20 2026-08-28 20:49:48Z 64bit) is ready」を返した。`version` は 1.11.3-release、`module_exists mod_spandsp`・`mod_event_socket`・`mod_conference`・`mod_dptools` は true、`mod_sofia` は false(未ロードのため)
- Event Socket(inbound)で FAX を実行: Python 標準ライブラリだけの最小クライアント(scripts/esl_min.py)で、`event plain CHANNEL_HANGUP_COMPLETE` を購読し、`bgapi originate loopback/9178/default 9179 XML default` を発信。標準(vanilla)のダイヤルプランの fax_receive(9178、rxfax)と fax_transmit(9179、txfax)を使った。テスト文書は1ページの TIFF(1728x2287、CCITT G4、内容は「FAX TEST PAGE」の図形。scripts/make_fax_tiff.py で生成)
  - 成功した例(logs/fax-run3.out): 両レグで Hangup-Cause: NORMAL_CLEARING、fax_success: 1、fax_result_code: 0、fax_result_text: OK、fax_document_total_pages: 1、fax_document_transferred_pages: 1、fax_transfer_rate: 14400、fax_ecm_used: on、fax_t38_status: off。受信側の TIFF(12296 bytes)が書かれた
  - 失敗した例(logs/fax-fail-run.out): 送信用の TIFF を一時的に退避して同じ命令を実行。受信レグで Hangup-Cause: NORMAL_CLEARING、fax_success: 0、fax_result_code: 49、fax_result_text: The call dropped prematurely、ページ数 0。送信側のログに「Cannot send non-existant fax file」。退避したファイルは元に戻した
  - スライド6の出力は、上の2つの実際の出力から、読み上げ対象の変数だけを抜粋して並べたもの(値は変更していない)。「(成功)」「(失敗)」の見出しは付け足し
- 起動の失敗(1回目): 最初に `-temp` なしで起動したところ、$${temp_dir} が /tmp になり、txfax が送信ファイルを見つけられず失敗した(logs/run2-wrongtemp-freeswitch.log)。-temp で作業用 tmp に変更して再起動した。ダイヤルプランの $${temp_dir} は、起動時の設定で変わる点に注意(スライドには載せていない)
- スライドの確認: lt-marp-png で10枚を PNG 化して全枚を目視(はみ出し、日本語フォント、図の収まり)。はみ出し(スライド3、5、6、8)を、行の分割と短縮で直して再確認。図は lt-mmdc で PNG 化し、ノード内の折り返しを直して再確認。自作の確認スクリプト(scripts/lint_speech.py)と統括の check_decks.py で、セリフ字数、1行の長さ、読点の数、行末の「。」、見出しのクリアなどを確認

未実行(公式ドキュメントの記載のみ)

- IVR(ivr アプリケーション、DTMF の入力)、録音(record_session)、会議(mod_conference): 動作確認の時間枠(15分)の都合と、サウンドファイルが未インストール(share/freeswitch/sounds が空)のため。スライドは公式ドキュメントの記載にもとづく
- SIP 経由の通話(mod_sofia)、実際の電話回線、FAX機、T.38: 未実行。通話は loopback のみ
- パッケージ(apt)でのインストールと SignalWire の Personal Access Token: 未実行(トークンなし)。公式ドキュメントの記載のみ
- Docker(Ubuntu 22.04)でのビルド: 発表者の経験。今回は再現していない
- Ubuntu 22.04 の標準パッケージの版: packages.ubuntu.com の表示のみ

バージョン

- FreeSWITCH 1.11.3-release(git ef32e20、2026-08-28)
- 依存(ビルドした版): libks2 2.0.11(libks リポジトリの master、ce6d911)、signalwire_client2 2.0.5、sofia-sip-ua 1.13.18、spandsp 3.1.1。mod_spandsp のログは「using spandsp library version [20260731 183046]」
- すべて v1.11.3 の configure.ac の最低要件(spandsp 3.1.1、sofia-sip 1.13.18、libks2 2.0.11、signalwire_client2 2.0.0)を満たす

環境

- Ubuntu 24.04.5 LTS、Linux 6.18.44 x86_64(サンドボックスの VM、root)、gcc 13.3.0
- marp-cli 4.5.1(統括提供のラッパー経由)
- 作業ディレクトリ: SCR/work/05_FreeSWITCH/(ソース、ビルド成果物、scripts、logs)。作業の最後に FreeSWITCH のプロセスは停止した

## 読み方メモ(語 | 採用する読み | 根拠)

| 語 | 採用する読み | 根拠 |
|---|---|---|
| FreeSWITCH | フリースイッチ | 公式に記載なし(マニュアル第1章、README で確認)。慣用として |
| SIP | シップ | 公式に記載なし。慣用として(エスアイピーと読む人もいる。この発表ではシップに統一) |
| PBX | セリフでは読まない(「会社の電話交換機」と言い換え) | 慣用ではピービーエックス |
| IVR | アイブイアール | 公式に記載なし。慣用として。セリフ内で「自動音声応答」と言い換え済み |
| FAX | ファックス | 慣用として |
| MPL | エムピーエル | 慣用として(Mozilla Public License) |
| XML / TCP | エックスエムエル / ティーシーピー | 慣用として |
| T.30 | ティーサーティー | 公式に記載なし。慣用として(ITU-T 勧告番号) |
| Kamailio | カマイリオ | 公式に記載の有無は未確認。慣用として |
| SignalWire | シグナルワイヤー | 公式に記載なし。慣用として |
| Event Socket | イベントソケット | 公式に記載なし。慣用として。セリフでは初出で「外から操作する窓口」と言い換える |
| Docker / Ubuntu / Debian | ドッカー / ウブントゥ / デビアン | 公式に記載なし。慣用として |
| NORMAL_CLEARING、fax_success などの変数名、v1.11.3 などの版番号 | 読み上げない(「画面のとおり」と指す) | BRIEF §5-f |
| loopback | セリフでは「疑似の通話」と言い換え | 読みは慣用でループバック |

## 言い換え表(言いにくい語 | 言い換え候補)

| 言いにくい語 | 言い換え候補 |
|---|---|
| FreeSWITCH | 「このソフト」 / 「通話の中身を扱うソフト」 |
| Event Socket | 「外から操作する窓口」(セリフ内で定義済み) / 「外のプログラムとつなぐ窓口」 |
| ダイヤルプラン | 「着信後の手順を書いた設定」(セリフ内で定義済み) |
| IVR | 「自動音声応答」(セリフ内で定義済み) |
| トークン | 「認証用の合言葉」(セリフ内で定義済み) |
| SignalWire | 「開発元の会社」 / 「開発元」 |
| Kamailio | 「SIPの振り分け役」 |
| loopback | 「疑似の通話」 |
| T.30 | 「FAXの通信手順を定めた規格」(セリフ内で定義済み) |
| mod_spandsp、mod_conference など | 「FAXのモジュール」 / 「会議のモジュール」(セリフでは読まない) |
| Hangup-Cause | 「切断理由」 / 「通話が終わった理由」 |
| 依存ライブラリ | 「部品」(セリフ内で統一) |
| ソースビルド | 「ソースからビルド」 / 「ソースから作る」 |

## 質問されそうな点(3〜5個、答えと出典つき)

1. パッケージとソースビルドは、どちらがよいか
   - 答え: 公式は、Debian と Ubuntu ではパッケージが最短とする。ただしパッケージには SignalWire の Personal Access Token が必要。パッケージにないモジュールや、特定のビルド構成が要るときは、Git からのソースビルド(トークンは不要)。ソースビルドには C のツールチェーンと依存ライブラリが要る
   - 出典: https://developer.signalwire.com/freeswitch/foundations/getting-started

2. FAX の T.38 は使えるか
   - 答え: mod_spandsp が T.38(UDPTL)に対応している。fax_enable_t38 で有効にでき、結果は fax_t38_status(negotiated、requested、refused、off)で見られる。今回の確認は音声(G.711 相当)の疑似の通話で、fax_t38_status は off だった。実際の回線や相手機での T.38 は確認していない
   - 出典: https://developer.signalwire.com/freeswitch/applications/fax

3. Event Socket のポートと認証は
   - 答え: 既定のポートは 8021、既定のパスワードは公式ドキュメントに載っている値(実在の認証情報ではない)。inbound の既定の ACL は loopback.auto(ローカルのみ)。標準設定の listen-ip は「::」で全インターフェース。公開する場合は ACL で接続元を絞る。今回の検証は 127.0.0.1:18021 で行った
   - 出典: https://developer.signalwire.com/freeswitch/integration/event-socket

4. spandsp の版が足りないと、どうなるか
   - 答え: v1.11.3 の configure は、spandsp 3.1.1 未満だと「no usable spandsp」のエラーで止まる(sofia-sip も同様)。Ubuntu 22.04 の標準パッケージは 0.0.6 なので、spandsp はソースから作る必要がある(発表者の Docker の事例と一致)
   - 出典: https://github.com/signalwire/freeswitch/blob/v1.11.3/configure.ac 、https://packages.ubuntu.com/jammy/libspandsp-dev

5. Kamailio とは、どう組み合わせるのか
   - 答え: Kamailio の公式サイトは、メディアサーバー(FreeSWITCH を例示)の規模拡大に使えると書いている。具体的な構成の設計は、この資料の範囲外(発表者の実績も、シードの範囲では書かれていない)
   - 出典: https://www.kamailio.org/w/
