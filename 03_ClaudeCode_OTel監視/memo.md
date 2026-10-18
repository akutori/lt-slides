# memo: Claude CodeのOpenTelemetry監視

## 前提(想定時間・枚数・ツール・作成日)

- イベント: AkarengaLT 第50回(2026年10月後半の日曜、福岡 Engineer Cafe)
- 持ち時間: 10分。セリフは約300字/分で、2200〜3000字に収める方針
- 枚数: 10枚(タイトル1 / 見出し3 / 本文5 / まとめ1)
- ツール: Marp。セリフはスライドMarkdown内のHTMLコメント
- スライドの作成日: 2026-10-09。この memo.md は、独立点検の担当が 2026-10-10 に作成した(作成時点で memo.md が無かったため)。出典の確認日も 2026-10-10
- セリフ字数: 2268字(差し込み行を除く)。差し込み行を含めると2313字。差し込みの実体験を話す分は、この外に加算される(2268字は約7.6分)
- 言い詰まり配慮: 1文は最長でも60字以内。40字を超えるのは差し込み行(話さない目印)だけ。文頭は「さて/で、/これは/つまり/まず/次に」など言い出しやすい語、各スライドの最後は短い「です/ます」文、短い息継ぎの行(5〜10字ほど)を本文スライドに1〜3行(スライド3だけは最短が11字の行)
- 画像: Mermaid(mermaid/concept.mmd)から作成した 画像/concept.png のみ。キャラクター・ロゴ類は使っていない
- 構想(小さな監視アプリ)は「検討中」で、実装も手元での確認もこれから。作ったとは書いていない
- 「2026年10月時点」と明記した情報: スライド3(traces は beta)、5(既定の出力間隔)、6(出力例)、8(検証環境での確認結果)

## 構成メモ(スライド番号 / 種別 / 要旨)

| # | 種別 | 要旨 |
| --- | --- | --- |
| 1 | タイトル | 「Claude CodeのOpenTelemetry監視」のみ。複数セッションを一か所で見たい。小さな監視アプリを検討中で、まだ実装していない。調べて分かったことを話す |
| 2 | 見出し | Claude Codeが出すテレメトリー |
| 3 | 本文 | OpenTelemetryのシグナル(traces / metrics / logs)。Claude Codeが出すのは metrics と events(traces は beta)。exporter は otlp / console / none。console は標準出力、デバッグ・学習向け(本番非推奨、形式は標準化されていない)。有効化の環境変数(シェルかユーザー設定。プロジェクト設定では無視) |
| 4 | 見出し | console exporterで見えるもの |
| 5 | 本文 | 知りたいこと(セッション / 実行内容 / 結果と所要時間 / 進捗の推定)と、イベント・属性の対応表。events と metrics(8種)、prompt.id、既定の出力間隔(events 5秒 / metrics 60秒) |
| 6 | 本文 | 出力例(`claude -p`、Linux、ダミーAPI、2.1.295)。既定ではプロンプトは `<REDACTED>`、コマンド本文は出ない。OTEL_LOG_USER_PROMPTS=1 / OTEL_LOG_TOOL_DETAILS=1 で出力(機密に注意)。差し込み1 |
| 7 | 見出し | 小さな監視アプリの構想(検討中) |
| 8 | 本文 | 検証環境での確認結果: console の対話は実行中に画面へ出ずデバッグログに記録、非対話は標準出力で回答の文字列と混ざる、OTLP は並行する対話セッション2つを session.id で区別できた。公式に記載は確認できず |
| 9 | 本文 | 構想の図。保存と表示はOpenTelemetryの対象外で、表示側を自作する案。受け口は console と OTLP を比較して決める。コマンド本文の表示には OTEL_LOG_TOOL_DETAILS=1。未確認: 許可待ちの検知(traces(beta)の `claude_code.tool.blocked_on_user`) |
| 10 | まとめ | metrics と events を出力できる。session.id で並行セッションを区別。本文は既定で伏せられる。console の出力先は対話=デバッグログ、非対話=標準出力(検証環境)。受け口は比較して決める。実装・手元での確認・許可待ちの検知はこれから |

## 出典一覧(URL | 確認日 | 何の裏付けか)

スライドのfooterに載せたURLは、第3欄に「スライド」の番号を書いた。それ以外は、memo・質疑用の裏取り。

| URL | 確認日 | 何の裏付けか |
| --- | --- | --- |
| https://code.claude.com/docs/en/monitoring-usage | 2026-10-10 | スライド3・5・6・8・9。有効化は `CLAUDE_CODE_ENABLE_TELEMETRY=1`(必須)。`OTEL_METRICS_EXPORTER` は console / otlp / prometheus / none、`OTEL_LOGS_EXPORTER` は console / otlp / none(prometheus は metrics のみ)。リポジトリの `.claude/settings.json` などに書いた OTEL のexporter変数は無視される。既定の出力間隔は logs(events)が 5000 ms、metrics が 60000 ms。metrics は8種(claude_code.session.count など)。events は claude_code.user_prompt / tool_decision / tool_result / api_request など。tool_result は tool_name・success・duration_ms、共通属性に session.id・event.timestamp・event.sequence・prompt.id。OTEL_LOG_USER_PROMPTS と OTEL_LOG_TOOL_DETAILS は既定で無効。traces は beta(`CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1` と `OTEL_TRACES_EXPORTER` が必要)で、`claude_code.tool.blocked_on_user` は許可判断の待ち時間を表す子スパン。OTLP のプロトコルは grpc / http/json / http/protobuf で、既定はなし |
| https://opentelemetry.io/docs/concepts/signals/(.md版) | 2026-10-10 | スライド3。シグナルは traces・metrics・logs・baggage。Events(logs の一種)と Profiles は開発中。スライドは「主なシグナル」として traces / metrics / logs を挙げた |
| https://opentelemetry.io/docs/specs/otel/logs/sdk_exporters/stdout/ | 2026-10-10 | スライド3。標準出力のexporterは「デバッグと学習向け」で本番利用は非推奨。出力形式は仕様化されておらず、いつでも変わりうる |
| https://opentelemetry.io/docs/what-is-opentelemetry/(.md版) | 2026-10-10 | スライド9。OpenTelemetry は観測のバックエンドではなく、保存と可視化は他のツールに任せる |
| https://opentelemetry.io/docs/specs/otlp/ | 2026-10-10 | スライド未使用(スライド8のセリフ「OTLP、つまり標準の送信規格」の裏付け)。OTLP は汎用のテレメトリ配送プロトコルで、gRPC と HTTP の上で実装され、HTTP には binary protobuf と JSON の2つの符号化がある |

## ⚠️ 出典なし・未確認の情報

1. console の出力先の挙動(対話=実行中は画面に出ず、デバッグログ(有効時)に記録。非対話=標準出力で、回答の文字列と混ざる)は、公式ドキュメントに記載を確認できなかった。検証環境(Claude Code 2.1.295、Linux、ダミーAPI)の結果で、スライド8・10に「検証環境」「公式に記載は確認できず」と明記している。点検担当が 2026-10-10 に 2.1.296 で非対話の出力を再実行し、イベントの構造と `prompt: "<REDACTED>"` が同じことを確認した。対話モードの挙動は、作成時の記録で確認し、再実行はしていない。
2. 「OTLP で、並行する対話セッション2つを1か所で受信し、session.id で区別できた」も検証環境の結果。公式の記載はない。プロトコルは http/json(公式の選択肢の1つ)。
3. 「進捗(推定)」は公式の説明ではなく、event.timestamp と event.sequence から推定する構想側の考え方。公式は event.sequence を「Claude Codeのプロセスごとのカウンタで、セッションごとではない」と説明している(質疑用)。
4. 許可待ちの検知は未確認(未実行)。公式に `claude_code.tool.blocked_on_user` スパンの記載はあるが、traces は beta で、試していない。
5. 構想(小さな監視アプリ、ちょっとしたツール程度の規模、console exporter を使う軽量な構成)と「実装も実機での確認もこれから」は、発表者のシード(申告)。外部の出典はない。
6. 「会社や顧客のデータを扱う場合は、特に注意が必要」(スライド6のセリフ)は、公式の文言そのものではない。公式の事実(プロンプトとツールの入力は既定で伏せられ、有効にすると出力される。有効にした本文には機密が混ざりうる)から導いた注意。
7. 差し込み欄に実機の出力を載せるときは user.email を伏せる。公式は user.email を、取得できる場合は常に付くと説明している。
8. 画面に出すコマンド本文の例(`echo hello` など)は、検証用のダミー。実在のコマンドや値は載せていない。
9. 読み(下の表)は、すべて公式に記載なし。

## 差し込み欄(スライド番号 | 何を入れるか)

| スライド | 何を入れるか |
| --- | --- |
| 6 | 手元の実機のconsole出力(user.emailは伏せる)(スライド側に `【差し込み: 手元の実機のconsole出力(user.emailは伏せる)】`、セリフ側に `(※ここで実体験を話す: 手元のClaude Codeで取ったconsole出力について)`) |

差し込みは1か所(上限3)。差し込みがなくても、前後の事実部分だけで話は通る。

発表者への確認事項:

- 手元で取った出力を載せるか(載せる場合は user.email を伏せる)。シードは「実機での確認はまだしていない」ため、取っていなければ、この差し込みは削除する
- 構想の規模や次の予定(スライド9のセリフは「実装も、手元での確認も、これから」)

## 動作確認(実行したもの / 未実行とその理由 / バージョン / 環境)

実行したもの(作業記録で確認できたもの):

- `claude -p`(Claude Code 2.1.295)を、ダミーのAPIキーとローカルのモックAPIサーバーに向け、HOME を隔離し、`CLAUDE_CODE_ENABLE_TELEMETRY=1` で実行。外部通信を抑える環境変数(DISABLE_TELEMETRY など)も設定
  - 既定(console exporter): イベントが標準出力に出る。`claude_code.user_prompt` は `prompt: "<REDACTED>"`、`claude_code.tool_result` は `tool_name: "Bash"`・`success: "true"`・`duration_ms: "136"`。出力例の session.id (22f351f3-…)はスライド6の抜粋と一致(A_logs_default.stdout)
  - `OTEL_LOG_USER_PROMPTS=1` と `OTEL_LOG_TOOL_DETAILS=1` を有効にした実行: プロンプト本文と `tool_parameters`(`full_command`)、`tool_input` が出る(B_logs_details.stdout)
  - 同条件の再実行(R1・R2)
- 対話モード(pty 上で起動したTUI。プロンプトを入力して `/exit`):
  - console exporter: 実行中の画面にテレメトリは出ない(T1)。`/exit` の後に、最後のイベントと metrics が出る(T4)
  - デバッグログを有効にした実行: イベントが `console.log: {...}` の形でデバッグログに残る(T3)
- OTLP(http/json): ローカルの受信サーバー `otlp_recv.py` へ送信
  - 1セッション: `/v1/logs` と `/v1/metrics`(claude_code.session.count / cost.usage / token.usage / active_time.total)を受信し、event.sequence の順に user_prompt → tool_decision → api_request → tool_result → … を確認(O1)
  - 並行する対話セッション2つ: 別々の session.id のイベントが同じ受信サーバーに届き、session.id で区別できた(O2)
- 点検担当が 2026-10-10 に、Claude Code 2.1.296 で非対話の console 出力を再実行し、イベントの構造と `<REDACTED>` が同じことを確認

未実行:

- traces(beta)と `claude_code.tool.blocked_on_user`: 試していない(スライド9にも「未確認」と明記)
- 実際のAPI・アカウントでの実行: すべてダミーAPI。user.email などの認証情報の属性は出力に含まれていない
- プロジェクトの `.claude/settings.json` に OTEL 変数を書いたときに無視される動作: 実行記録を確認できず(公式ドキュメントの記載のみ)
- prometheus exporter、grpc、http/protobuf: 未実行
- 監視アプリ本体: 未実装(構想のみ)

バージョン・環境:

- Claude Code 2.1.295(作成時)/ 2.1.296(点検時の再実行)
- node v22.22.0 / Python 3.13.16 / Linux 6.18.44-fc-v80

## 読み方メモ(語 | 採用する読み | 根拠)

| 語 | 採用する読み | 根拠 |
| --- | --- | --- |
| Claude Code | クロードコード | 公式記載なし。慣用として |
| OpenTelemetry | オープンテレメトリー | 公式記載なし。慣用として |
| OTLP | オーティーエルピー | 略語の文字読み。公式記載なし |
| console | コンソール(セリフはカタカナ表記) | 一般的な読み |
| exporter | エクスポーター(セリフは「エクスポーター、つまり出力先」) | 一般的な読み。表記は長音ありで統一 |
| テレメトリー | テレメトリー | 表記は長音ありで統一。公式記載なし |
| JSON | ジェイソン | 公式記載なし。慣用として |
| ID | アイディー | 一般的な読み |
| Linux | リナックス | 公式記載なし。慣用として |
| session.id | セッションのアイディー(セリフの言い方) | 識別子は読み上げない規約 |
| 一つ・二つ | ひとつ・ふたつ | 数字を読み上げない規約のため、セリフは漢数字で書いた |

## 言い換え表(言いにくい語 | 言い換え候補)

| 言いにくい語 | 言い換え候補 |
| --- | --- |
| OpenTelemetry | 監視データを出す標準の枠組み、テレメトリーを出す枠組み(セリフで採用) |
| テレメトリー | 動作の記録(セリフで採用) |
| エクスポーター | 出力先(セリフで採用) |
| メトリクス | 集計用の数値(セリフで採用) |
| イベント | 何かが起きた記録(セリフで採用) |
| OTLP | 標準の送信規格(セリフで採用) |
| プロンプト | 指示文(セリフで採用) |
| デバッグログ | 調査用の記録(セリフで採用) |
| セッション | 一つの会話の単位(セリフで採用) |
| 非対話 | 一回だけ実行する形式(セリフで採用) |
| トレース | 処理の流れの記録 |
| ツール | コマンド実行やファイル編集の機能(セリフで採用) |
| 受け口 | 受信する窓口 |
| console | 画面への出力、標準出力 |

## 質問されそうな点(3〜5個、答えと出典つき)

1. console exporter だけで、複数セッションを監視できるのか
   - 検証環境の結果では、非対話(`claude -p`)は標準出力に出るが回答の文字列と混ざる。対話は実行中に画面へ出ず、デバッグログ(有効時)に記録される。対話の様子を見るには別の受け口が要る。OTLP なら、並行する対話セッション2つを1か所で受信し、session.id で区別できた。公式ドキュメントにこの挙動の記載は確認できない
   - 出典: https://code.claude.com/docs/en/monitoring-usage(OTLP のプロトコル、exporter の値)/ 作業記録(検証環境)
2. プロンプトやコマンドの中身は出力されるのか
   - 既定では伏せられる(プロンプトは `<REDACTED>`、ツールの入力は出ない)。OTEL_LOG_USER_PROMPTS=1 と OTEL_LOG_TOOL_DETAILS=1 で出力される。出力した本文には機密が混ざりうるため、会社や顧客のデータを扱う場合は特に注意する。リポジトリの設定で有効にすることはできない(プロジェクト設定の OTEL 変数は無視される)
   - 出典: https://code.claude.com/docs/en/monitoring-usage
3. セッションの区別と進捗の測り方は
   - 区別は session.id(既定で付く。OTEL_METRICS_INCLUDE_SESSION_ID=false で外せる)。進捗は、イベントの種類と event.timestamp から推定する構想。event.sequence は、セッションごとではなく Claude Code のプロセスごとのカウンタ
   - 出典: https://code.claude.com/docs/en/monitoring-usage
4. 許可待ち(ユーザーの承認待ち)は検知できるのか
   - 未確認。traces(beta)に、許可判断の待ち時間を表す `claude_code.tool.blocked_on_user` スパンがある。traces を有効にするには CLAUDE_CODE_ENABLE_TELEMETRY=1 と CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1 を設定し、OTEL_TRACES_EXPORTER を指定する。試していない
   - 出典: https://code.claude.com/docs/en/monitoring-usage
5. OpenTelemetry だけで、保存と表示までできるのか
   - できない。OpenTelemetry は観測のバックエンドではなく、保存と可視化は他のツールに任せる。そのため、表示側を自作する案を検討している
   - 出典: https://opentelemetry.io/docs/what-is-opentelemetry/
