# memo: SensitiveMasker

## 前提(想定時間・枚数・ツール・作成日)

- イベント: AkarengaLT 第50回(2026年10月後半の日曜、福岡 Engineer Cafe)
- 持ち時間: 10分。セリフは約300字/分で、2200〜3000字に収める方針
- 枚数: 10枚(タイトル1 / 見出し3 / 本文5 / まとめ1)
- ツール: Marp。セリフはスライドMarkdown内のHTMLコメント
- スライドの作成日: 2026-10-09。この memo.md は、独立点検の担当が 2026-10-10 に作成した(作成時点で memo.md が無かったため)。出典の確認日も 2026-10-10
- セリフ字数: 2364字(差し込み行を除く)。差し込み行を含めると2404字。差し込みの実体験を話す分は、この外に加算される(2364字は約7.9分)
- 言い詰まり配慮: 1文は最長でも60字以内(40字を超える文はない)、文頭は「さて/で、/実は/これは/つまり/そして/まず/次に」など言い出しやすい語、各スライドの最後は短い「です/ます」文、短い息継ぎの行を本文スライドに1〜2行
- 画像: Mermaid(mermaid/mcp-flow.mmd)から作成した 画像/mcp-flow.png のみ。キャラクター・ロゴ類は使っていない
- 値はすべて架空: 電話番号は 0 を多用、IPは文書用の予約アドレス 203.0.113.10(RFC 5737)、認証情報は dummy-secret など
- 「2026年10月時点」と明記した情報: スライド8の「公開リポジトリの v0.0.6 の構成」。発表前に、最新のリリースを確認して、違えば直す

## 構成メモ(スライド番号 / 種別 / 要旨)

| # | 種別 | 要旨 |
| --- | --- | --- |
| 1 | タイトル | 「SensitiveMasker」のみ。話は三つ(困りごと / Windows版 / 次期版の構成)と、最後に限界。デモはせず、値は全部架空 |
| 2 | 見出し | AIに貼る前に隠したい |
| 3 | 本文 | 困りごと: 外部のAIに貼る前に、電話番号・SIPの認証情報・IPアドレスを隠したい(表は架空の値)。マスクの定義。OWASP LLM02:2025 の対策の1つ(機密情報の入力を避ける指針を利用者に示す) |
| 4 | 見出し | 作ったもの(Windows版) |
| 5 | 本文 | Windows版: 個人用、Python と tkinter、GitHubで公開、画面とCLIは同じマスク処理、処理はローカル、テンプレートは汎用とSIP。READMEのCLI例と、前後の例(汎用テンプレートの実行結果) |
| 6 | 本文 | いまの課題と限界: JSONは暗号化せず保存、ルールは固定文字列か正規表現、取りこぼし(ハイフンなしの電話番号 / IPv6)、過剰マスク(1.2.3.4 形式のバージョン番号)、ストリーミングでは行をまたぐルールが効かない場合。差し込み1 |
| 7 | 見出し | 次期版(Tauri版) |
| 8 | 本文 | 次期版の構成: 共有コア masking-core と3つの殻(gui=Tauri / cli=clap / mcp=rmcp)。SQLiteで管理、常駐(トレイ)、`masker init` が必須。「公開リポジトリの v0.0.6 の構成(2026年10月時点)」 |
| 9 | 本文 | MCPの流れの図(Claude がツールを呼ぶ → mcp がコマンドを実行し masker CLI でマスク → マスク済みの出力だけを返す)。ツールは `run_masked_command` の1つ(引数は command / timeout_seconds / profile / encoding)。対象は標準出力(標準エラー出力は対象外)。設定は暗号化し鍵は別ファイル。別PCへの移行はパスフレーズで再暗号化(`age -p` 相当) |
| 10 | まとめ | Windows版は公開済み(JSONは暗号化なし)。次期版(Tauri版)は v0.0.6 まで公開済みで、共有コアと3つの殻。MCP経由でマスク済みの標準出力だけを渡せる。マスクは完全でなく、貼る前に人が確認する |

## 出典一覧(URL | 確認日 | 何の裏付けか)

スライドのfooterに載せたURLは、第3欄に「スライド」の番号を書いた。それ以外は、memo・質疑・読みの確認用。

| URL | 確認日 | 何の裏付けか |
| --- | --- | --- |
| https://genai.owasp.org/llmrisk/llm022025-sensitive-information-disclosure/ | 2026-10-10 | スライド3。「LLM02:2025 Sensitive Information Disclosure」。利用者が意図せず機密データを入力するリスクを理解する必要がある。対策の項目 User Education and Transparency に、機密情報の入力を避ける指針の提示と、LLMを安全に使うための研修が挙がっている |
| https://genai.owasp.org/llm-top-10/ | 2026-10-10 | スライド3。OWASP Top 10 for LLM Applications 2025 の10項目。LLM02:2025 が Sensitive Information Disclosure |
| https://www.rfc-editor.org/rfc/rfc5737 | 2026-10-10 | スライド3。RFC 5737「IPv4 Address Blocks Reserved for Documentation」(2010年1月)。192.0.2.0/24(TEST-NET-1)、198.51.100.0/24(TEST-NET-2)、203.0.113.0/24(TEST-NET-3)が文書用に予約されている |
| https://github.com/akutori/SensitiveMaskerWin | 2026-10-10 | スライド5。公開リポジトリ(Public)。説明文は「AIにログを貼り付けるときに、見せたくないデータを瞬時に安全な文字列に変更するツール」。READMEはWindowsデスクトップツール、GUI(tkinter)とCLI、ローカルでマスキング。確認したコミットは 0ce8188(2026-08-01、バージョン 1.3.0) |
| https://github.com/akutori/SensitiveMaskerWin/blob/main/README.md | 2026-10-10 | スライド5・6。CLI実行例(`uv run python -m cli.main --profile my_profile.json --input in.log --output out.log`)、`--stream`、「行をまたぐ正規表現ルールは1行ずつの処理のため正しく機能しない場合があります」、外部LLMに貼る前にローカルで自動マスキング |
| https://github.com/akutori/SensitiveMaskerWin/blob/main/src/gui/settings.py | 2026-10-10 | スライド5・6。`PROFILE_TEMPLATES` に「汎用 (general)」と「SIP」の2種類のテンプレート(READMEにはこの2種類の記述なし) |
| https://github.com/akutori/SensitiveMaskerWin/blob/main/src/masking_core/profile_io.py | 2026-10-10 | スライド6。`save_profile` は `model_dump_json` の結果をそのままファイルへ書く(暗号化の処理なし) |
| https://github.com/akutori/SensitiveMaskerWin/blob/main/src/masking_core/models.py | 2026-10-10 | スライド6。Rule の pattern_type は literal / regex、mode は fixed / sequential |
| https://docs.python.org/3/library/tkinter.html | 2026-10-10 | スライド5。tkinter は Tcl/Tk GUI toolkit の標準のPythonインターフェース |
| https://v2.tauri.app/start/ | 2026-10-10 | スライド8。Tauri は小さく速いバイナリを作るフレームワーク。フロントエンドは Web の技術(HTML・JavaScript・CSS)、バックエンドは Rust など |
| https://github.com/clap-rs/clap | 2026-10-10 | スライド8。clap は「Command Line Argument Parser for Rust」 |
| https://github.com/modelcontextprotocol/rust-sdk | 2026-10-10 | スライド8。rmcp は「An official Rust Model Context Protocol SDK implementation with tokio async runtime」 |
| https://www.sqlite.org/about.html | 2026-10-10 | スライド8。SQLite は self-contained・serverless。複数のテーブルを含む完全なSQLデータベースが1つのディスクファイルに入る |
| https://modelcontextprotocol.io/docs/getting-started/intro | 2026-10-10 | スライド8・9。MCP は AI アプリケーションを外部システムにつなぐための、オープンソースの標準 |
| https://modelcontextprotocol.io/specification/2026-07-28/server/tools | 2026-10-10 | スライド9。信頼と安全のため、ツール呼び出しを拒否できる人を常に介在させるべき(SHOULD)。クライアントは確認画面を出す、など |
| https://github.com/FiloSottile/age | 2026-10-10 | スライド9。age はファイル暗号化ツール。`-p/--passphrase` でパスフレーズによる暗号化 |
| https://github.com/akutori/SensitiveMasker | 2026-10-10 | スライド6・8のfooter。発表者の次期版のリポジトリ(公開、162コミット)。READMEは GUI・CLI・MCPサーバーの3つを提供すると記載し、crates/ に masking-core・profile-store・masker・masker-mcp、gui/ に Tauri + React のGUIがある。「v0.0.6」の記述の根拠 |
| https://github.com/akutori/SensitiveMasker/releases | 2026-10-10 | スライド8・10の「v0.0.6」の根拠(footerには未掲載)。リリース v0.0.1(9/13)、v0.0.2(9/14)、v0.0.3(9/15)、v0.0.4(9/20)、v0.0.5(9/20)、v0.0.6(9/24)。v0.0.6 は macOS の dmg、Linux の rpm・deb・AppImage、masker-cli と masker-mcp-cli(Linux・macOS・Windows)などを配布 |
| https://github.com/akutori/SensitiveMasker/tree/v0.0.6/crates | 2026-10-10 | スライド9のfooter。取得済みのソース(タグ v0.0.6、コミット 0263661)で確認した点: MCPのツール定義は `run_masked_command` の1つ(`#[tool(` が1箇所)で、引数は command / timeout_seconds / profile / encoding、説明文に「標準エラー出力は対象外」(crates/masker-mcp/src/server.rs)。masker-mcp は masking-core に依存せず、対象コマンドの出力を `masker mask --stream` にパイプする(server.rs 冒頭のコメントと CLAUDE.md)。スライド9の図と、スライド8の表の「マスクはCLIに任せる」はこの流れ。鍵ファイルは作成時に所有ユーザーのみの権限(Unixはモード0600、Windowsは現在のユーザーに制限)(crates/profile-store/src/key.rs)。exportはageのパスフレーズ(scrypt)方式で、コメントに「age -p相当」(crates/profile-store/src/export.rs)。未初期化なら「初期化されていません。`masker init`を実行してください」で止まる(crates/profile-store/src/lib.rs の NotInitialized)。トレイ(gui/src-tauri/src/tray.rs)。SQLiteは rusqlite(crates/profile-store/Cargo.toml) |
| https://owasp.org/about/ | 2026-10-10 | 読みの確認。OWASP は Open Worldwide Application Security Project。読みの記載なし |
| https://sqlite.org/faq.html | 2026-10-10 | 読みの確認。FAQ に SQLite の読みの記載なし |

## ⚠️ 出典なし・未確認の情報

1. 次期版の記述は、発表者の公開リポジトリ https://github.com/akutori/SensitiveMasker の v0.0.6(2026-09-24 リリース、2026-10-10 確認)に合わせて書き換えた。以前の「設計・未実装」は、シードの記述(過去チャット由来で、元の記憶は 2026-09-05 時点)で、v0.0.1 の公開(9/13)より前のもの。
   - 発表者の確認: v0.0.6 より後に変更があれば、スライド8〜10とセリフを直す。「どこまで動くか」は、スライドでは言っていない(「公開済み」「構成」「渡せる」と書いた)。
   - 次期版のGUI・CLI・MCPサーバーの実行、MCPクライアントからの呼び出しは、この環境では未実行(ビルドのみ確認)。
2. 次期版の個別項目は、取得済みの v0.0.6 のソース(コミット 0263661)で確認した。共有コア masking-core、鍵を別ファイルに分けて所有ユーザーのみの権限で保存、未初期化なら `masker init` を促して止まる、常駐トレイ、exportはageのパスフレーズ方式(`age -p` 相当)、MCPツールは1つで引数は4つ(command / timeout_seconds / profile / encoding)。確認の詳細は、出典一覧の `.../tree/v0.0.6/crates` の行。
3. 「個人用のデスクトップツール」「使っている頻度・場面」は発表者の申告。スライド6の差し込み欄で扱う。
4. Windows版のGUI(tkinter)は、この環境に画面がないため起動していない。`--stream` も未実行。スライド6の「ストリーミング処理では行をまたぐルールが効かない場合がある」は、READMEの記述のみ(一括処理では行をまたぐルールが効くことを確認)。
5. OWASP の「対策の1つ」は、LLM02:2025 の対策のうち、利用者へ指針を示す項目を指す。この種のマスクツールを OWASP が推奨している、という意味ではない。スライド3はその言い方に合わせている。
6. MCP仕様の「人を介在させる」は SHOULD で、守るのは主にクライアント側。次期版のMCPサーバーがどう扱うかは未確認。スライド9のセリフは「仕様は勧めています」と話している。
7. READMEの例は `uv run` 形式。作成時は uv を使わず、`python3 -I` で同じモジュール(cli.main)を実行して確認した。
8. 読み(下の表)は、すべて公式に記載なし。

## 差し込み欄(スライド番号 | 何を入れるか)

| スライド | 何を入れるか |
| --- | --- |
| 6 | 実際の画面と、使っている頻度・場面(スライド側に `【差し込み: 実際の画面と、使っている頻度・場面】`、セリフ側に `(※ここで実体験を話す: 実際の画面を見せながら、使っている頻度と場面について)`) |

差し込みは1か所(上限3)。差し込みがなくても、前後の事実部分だけで話は通る。

発表者への確認事項:

- 次期版の最新の状況(v0.0.6 より後に変更があれば、スライド8〜10とセリフを直す)
- 画面の見せ方(デモはしない方針。スクリーンショットを使うか)
- 使っている頻度・場面(スライド6の差し込み)
- Windows版の「ルールプロファイルのJSONを暗号化しない」理由。シードは「次期版で改善する課題」とだけ記載

## 動作確認(実行したもの / 未実行とその理由 / バージョン / 環境)

実行したもの(作業記録で確認できたもの):

- `akutori/SensitiveMaskerWin` を取得し(コミット 0ce8188、2026-08-01、v1.3.0)、CLIのモジュール `cli.main` を `python3 -I` で直接実行(`uv run` は使っていない)
  - 汎用テンプレート(`PROFILE_TEMPLATES` から GUI と同じ手順で作成)で、スライド5の前後の例を実行。出力はスライドの「後」の2行と一致(in_general.log / out_general.log)
  - SIPテンプレートで、SIPのURI・ヘッダ・Digest認証を含むログを実行(in_sip.log / out_sip.log)
  - 取りこぼし: ハイフンなしの電話番号(0300000000)と IPv6(2001:db8::1)は残った(out_miss.log)。ハイフンありの電話番号とIPv4はマスクされた
  - 過剰マスク: 1.2.3.4 形式のバージョン番号が IP としてマスクされた(out_version_general.log)
  - 行をまたぐルール: 一括処理では2行にまたがる値がマスクされた(out_multiline.log)。`--stream` は未実行
- 次期版 `akutori/SensitiveMasker`(タグ v0.0.6、コミット 0263661、2026-09-25)を取得し、`cargo build`(dev)で masker と masker-mcp のビルドが成功することを確認(約3分10秒)。実行はしていない
- 2026-10-10 に、公開リポジトリのREADME・リリースページと、取得済みのソース(鍵ファイルの権限、exportの方式、未初期化時の動作、トレイ、MCPツールの引数)を読んで、スライド7〜10の記述と照合した(⚠️の項目1・2)

未実行:

- GUI(tkinter)の起動と画面の確認: この環境に画面がないため
- `--stream`、`--batch`、README の `uv run` 形式そのもの
- 次期版のGUI・CLI・MCPサーバーの実行、MCPクライアントからの呼び出し、鍵の作成、age によるexport/import
- いずれも、スライドには実行結果として載せていない(スライドの前後の例は、汎用テンプレートの実際の実行結果)

バージョン・環境:

- Windows版 v1.3.0(コミット 0ce8188)/ 次期版 v0.0.6(コミット 0263661)
- Python 3.13.16 / pydantic 2.13.5 / cargo 1.97.0 / Linux 6.18.44-fc-v80

## 読み方メモ(語 | 採用する読み | 根拠)

| 語 | 採用する読み | 根拠 |
| --- | --- | --- |
| SensitiveMasker | センシティブマスカー(セリフはカタカナ表記) | 公式記載なし。慣用として |
| OWASP | オワスプ | 公式(owasp.org/about)に読みの記載なし。慣用として |
| SIP | シップ または エスアイピー | 公式記載なし。発表者が普段使う読みに合わせる(未確認) |
| tkinter | ティーケーインター | 公式記載なし。慣用として |
| Tauri | タウリ | 公式記載を確認できず。慣用として |
| clap | クラップ | 公式記載なし。英単語の読みとして |
| rmcp | アールエムシーピー | 文字読み。公式記載なし |
| MCP | エムシーピー | 略語の文字読み。公式記載なし |
| SDK | エスディーケー | 略語の文字読み |
| SQLite | エスキューライト | 公式FAQに読みの記載なし。慣用として |
| JSON | ジェイソン | 公式記載なし。慣用として |
| CLI | シーエルアイ | 略語の文字読み |
| GitHub | ギットハブ | 公式記載なし。慣用として |
| Python | パイソン | 公式記載なし。慣用として |
| Rust | ラスト | 公式記載なし。慣用として |
| IP | アイピー | 略語の文字読み |
| 三つ・二つ・一つ | みっつ・ふたつ・ひとつ | 数字を読み上げない規約のため、セリフは漢数字で書いた |

## 言い換え表(言いにくい語 | 言い換え候補)

| 言いにくい語 | 言い換え候補 |
| --- | --- |
| tkinter | Pythonの標準の画面部品(セリフで採用)、画面の部品 |
| Tauri | Webの技術で作る、アプリの枠組み(セリフで採用) |
| clap | RustでCLIの引数を読む部品(セリフで採用) |
| rmcp / SDK | MCPの公式SDK(セリフで採用)、AI向けの入口用の部品 |
| MCP | AIと外のシステムをつなぐ共通の規格(セリフで採用) |
| SQLite | ファイル一つのデータベース(セリフで採用) |
| OWASP | セキュリティ団体(セリフで採用) |
| ルールプロファイル | 隠すルールの設定ファイル(セリフで採用) |
| 正規表現 | 文字の並びの形を書く方法(セリフで採用) |
| CLI | コマンドラインのこと(セリフで採用) |
| マスク | 値を記号に置き換えること(セリフで採用) |
| ツール(MCP) | AIが呼べる機能(セリフで採用) |
| パスフレーズ | 合言葉、長いパスワード |
| ストリーミング | 流しながら処理する方式 |
| 取りこぼし / 過剰マスク | 隠し漏れ / 隠しすぎ |
| 共有コア / 殻 | 共通の本体 / 外側の入口 |

## 質問されそうな点(3〜5個、答えと出典つき)

1. 次期版は、どこまで公開されているのか
   - 公開リポジトリは、READMEが GUI・CLI・MCPサーバーの3つを提供すると記載し、v0.0.1〜v0.0.6 のリリースがある。スライドは「v0.0.6 まで公開済み」「その構成」と話す。動作の保証までは言わない
   - 出典: https://github.com/akutori/SensitiveMasker / https://github.com/akutori/SensitiveMasker/releases
2. 取りこぼしと過剰マスクは、どう防ぐのか
   - 完全には防げない。ルールに合う値だけを置き換える。汎用テンプレートの実行では、ハイフンなしの電話番号と IPv6 が残り、1.2.3.4 形式のバージョン番号が IP としてマスクされた(検証環境)。貼る前にマスク結果を人が確認する
   - 出典: https://github.com/akutori/SensitiveMaskerWin/blob/main/src/gui/settings.py / https://github.com/akutori/SensitiveMaskerWin/blob/main/README.md
3. OWASP の資料と、このツールはどう関係するのか
   - LLM02:2025 は機密情報の漏えいのリスク。利用者が意図せず機密情報を入力するリスクを含み、対策の1つに「機密情報の入力を避ける指針を示す」ことがある。このツールは「貼る前に値を隠す」ための道具で、OWASP が推奨するツールではない
   - 出典: https://genai.owasp.org/llmrisk/llm022025-sensitive-information-disclosure/
4. MCPを通せば、AIにはマスク済みの出力だけが届くのか
   - ツールは、コマンドを実行して標準出力をマスクし、返す。AIに届くのは返された出力。公開リポジトリのツール説明には「標準エラー出力は対象外」とある。MCPの仕様は、ツール呼び出しを人が止められる形を勧める(SHOULD)
   - 出典: https://modelcontextprotocol.io/specification/2026-07-28/server/tools / https://github.com/akutori/SensitiveMasker
5. なぜ、Windows版はJSONを暗号化しないのか
   - 現行のWindows版は、ルールプロファイルをJSONのまま保存している(`save_profile` は暗号化せずに書く)。次期版では、暗号化して保存し、鍵は別ファイルに分けてOSのファイル権限で守る。Windows版の理由は発表者に確認する
   - 出典: https://github.com/akutori/SensitiveMaskerWin/blob/main/src/masking_core/profile_io.py
