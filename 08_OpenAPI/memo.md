# memo: OpenAPI

## 前提(想定時間・枚数・ツール・作成日)

- 想定時間: 10分(5分版は作らない)
- 枚数: 10枚(タイトル1、見出し3、本文5、まとめ1)
- ツール: Marp(marp-cli 4.5.1)。`lt-marp-png` で全10枚をPNG化し、すべて目視で確認した
- 作成日: 2026-10-09(出典の確認日も同日)
- 発表: AkarengaLT 第50回(2026年10月後半の日曜、福岡 Engineer Cafe)
- ファイル
  - `OpenAPI.md`: スライドとセリフ(セリフは各スライドのHTMLコメント、1行1コメント)
  - `画像/flows.png`: 図(元は `mermaid/flows.mmd`)
  - `preview/`: 確認用PNG(統括が確認後に削除)
- 話の軸: 小さなAPIで仕様(OpenAPI)を真ん中に置くと、型とドキュメントを機械的に作れる。「1エンドポイント + 1つの見せ場(仕様の変更が型エラーとして見つかる)」に絞った
- セリフの分量: 合計2298字(差し込み行を除く)。差し込み行(47字)を含めると2345字。1分300字の換算で約7.7分
  - 差し込みの実体験(30〜60秒を想定)と、画面を見せる間を足して、10分に収まる見込み
  - 通しの音読による計測はしていない。練習で時間を測ってほしい
- セリフの自己チェック: 自作スクリプトで確認し、指摘なし
  - つなぎ語での書き出し、です/ます止め、1文40字以内(最長60字)、読点は2つまで
  - 数字・URL・コマンドを読まない、見出し30〜60字、本文200〜350字

## 構成メモ(スライド番号 / 種別 / 要旨)

| # | 種別 | 要旨 | セリフ字数 |
|---|---|---|---|
| 1 | タイトル | 「OpenAPI」のみ。話の流れ(3つ)の予告と、コマンドは読み上げず画面を見てもらう旨 | 144 |
| 2 | 見出し | OpenAPIとは | 31 |
| 3 | 本文 | OASの定義、YAML/JSON、ツール連携、OAIとLinux Foundation、Swagger由来、最新版3.2.1と版番号の意味(2026年10月時点) | 342 |
| 4 | 見出し | 仕様から型を作る | 30 |
| 5 | 本文(コード) | 1エンドポイントの `openapi.yaml`(抜粋、省略は `...`) | 344 |
| 6 | 本文(コード) | 型の生成コマンドと実際の出力、生成された `Order` の型 | 346 |
| 7 | 本文(コード + 差し込み) | 型を使うコード、仕様の変更(status → state)、`tsc` の型エラー。差し込み1か所 | 344 |
| 8 | 見出し | 仕様ファーストとコードファースト | 30 |
| 9 | 本文(図) | 2つの流れ(図)、OAIのガイドは仕様ファースト推奨、コードファーストの例としてFastAPI | 339 |
| 10 | まとめ | 4項目(定義、仕様を中心に置く効果、型エラーで見つかる、2つの流れ) | 348 |

- 見出し + 本文の組: 「OpenAPIとは」(2〜3)、「仕様から型を作る」(4〜7)、「仕様ファーストとコードファースト」(8〜9)。タイトルが最初、まとめが最後
- サンプルの `openapi:` は 3.1.0 にした。最新版は3.2.1だが、openapi-typescript の公式ドキュメントが対応を書いているのは3.0と3.1のため(スライド6の箇条書きとセリフで触れている)
- コードスライド(5〜7)のコード行は、スライド5が13行、スライド6が11行、スライド7が約8行。SKILL.md 1-3 の目安(コード5行以下)を超えている
  - BRIEF 2章の「コマンドとその出力をスライド上に置く」を優先した。PNGで収まりと読みやすさは確認済み
  - 減らす場合は、スライド6の上段(コマンドと出力)か下段(`Order` の抜粋)のどちらかを削る案がある
- 加えた説明の言い換え: スライド9で「公式ガイド」ではなく「OAIのガイド」と表記した(理由は ⚠️ の7番)

## 出典一覧(URL | 確認日 | 何の裏付けか)

確認日はすべて 2026-10-09。「footer」はスライドの footer に載せている URL。

| URL | 確認日 | 何の裏付けか |
|---|---|---|
| https://spec.openapis.org/oas/latest.html | 2026-10-09 | footer: スライド3・5。最新版が v3.2.1。OASの定義(言語に依存しない、HTTP API向けの標準インターフェース)。仕様ファイル(OAD)がドキュメント生成・コード生成・テストのツールで使えること。入口ファイルの推奨名 openapi.json / openapi.yaml。版番号の意味(major.minor が機能の区分、.patch は誤りの修正・明確化)。paths、components、`$ref` の記法。WebFetch で確認し、全文は同じ版の Markdown(下のraw)で照合した。curl は接続拒否(403)だったため使っていない |
| https://spec.openapis.org/oas/ | 2026-10-09 | 公開されている版の一覧(3.2.1、3.2.0、3.1.2、3.1.1、3.1.0、3.0.4、3.0.3、3.0.2、3.0.1、3.0.0、2.0)。3.2.1が最新で、公開日は2026年9月10日 |
| https://spec.openapis.org/ | 2026-10-09 | OAIの仕様公開サイトの入口。仕様本文が「この仕様の正式な表示(authoritative rendering)はここ」と案内しているため、latest.html を一次情報に採用した根拠 |
| https://github.com/OAI/OpenAPI-Specification/releases | 2026-10-09 | 3.2.1が最新リリース。表示は「10 Sep」で年の表示なし。年は仕様本文の改訂履歴表(2026-09-10)で補った |
| https://github.com/OAI/OpenAPI-Specification/releases/tag/3.2.1 | 2026-10-09 | リリースノートに "no significant changes" とあり、文言の修正・明確化が中心のパッチ版であること(スライド3「末尾の数字は修正・補足のみ」の補強) |
| https://raw.githubusercontent.com/OAI/OpenAPI-Specification/3.2.1/versions/3.2.1.md | 2026-10-09 | 仕様本文(HTTP 200で取得し、手元で grep して照合)。language-agnostic、OADの用途、推奨ファイル名、major.minor.patch の意味、Apache 2.0、改訂履歴表(3.2.1は2026-09-10、3.2.0は2025-09-19、「Swagger 2.0をOAIへ寄贈」は2015-12-31) |
| https://www.openapis.org/ | 2026-10-09 | OAIのトップ。HTTP APIを記述する正式な標準であること、Linux Foundation の表記。読み方の記載なし |
| https://www.openapis.org/about | 2026-10-09 | footer: スライド3。OAIは Linux Foundation 配下のオープンなガバナンス体制。ベンダー中立な記述形式を掲げる。OASはもとは SmartBear が寄贈した Swagger Specification |
| https://www.openapis.org/what-is-openapi | 2026-10-09 | OpenAPIはHTTP API向けの仕様言語で、言語に依存せず、YAMLかJSONで書くのが一般的。コード生成に使えることの記載(補助的な確認)。Swaggerの記載なし、読み方の記載なし |
| https://www.openapis.org/style-guide | 2026-10-09 | 名称の表記と使い方(OAIの歴史、ガバナンス、ロゴの使い方を含む)。読み方の記載なし。「OpenAPI Specification」の表記に合わせた |
| https://learn.openapis.org/ | 2026-10-09 | OAIが公開する学習サイト(フッターが © OpenAPI Initiative、ドキュメントのリポジトリはOAI組織配下)。ページ自身は「公式」とは書いていない |
| https://learn.openapis.org/best-practices | 2026-10-09 | footer: スライド5・9。OAIはDesign-first(仕様ファースト)を推奨(スライド9・10)。理由はコードで作れるAPIの範囲が、OpenAPIで記述できる範囲より広いこと(スライド9)。Code-first と Design-first の説明(スライド9)。同じ定義を繰り返さず components と `$ref` にまとめる(スライド5)。コード注釈は code-first と相性がよい(スライド9)。GitHub の Markdown(https://raw.githubusercontent.com/OAI/learn.openapis.org/main/best-practices.md、HTTP 200)でも全文を照合 |
| https://openapi-ts.dev/introduction | 2026-10-09 | footer: スライド6・7。OpenAPI 3.0 と 3.1 に対応(スライド6)。runtime-free types を生成(スライド6のセリフ)。MIT。Node.js 20 以上を推奨。インストールコマンド(スライド6)。YAML/JSONをローカル・リモートから読める。スライド7の import と `components["schemas"][...]` の書き方は、この使用例の形に倣った(中身は独自のサンプル)。GitHub の docs/introduction.md(raw、HTTP 200)でも照合 |
| https://openapi-ts.dev/cli | 2026-10-09 | footer: スライド6。CLIの使い方(入力、`-o` / `--output`、リモートのスキーマ、`--check` は生成済みの型が最新かの検査)。GitHub の docs/cli.md(raw、HTTP 200)でも照合 |
| https://github.com/openapi-ts/openapi-typescript | 2026-10-09 | リポジトリの所有は openapi-ts 組織で、OAIの製品ではない。ライセンスはMIT。スライドには載せていない(「誰が作っているか」という質問用) |
| https://registry.npmjs.org/openapi-typescript(`npm view` で取得) | 2026-10-09 | 最新版は 7.13.0(公開 2026-02-11)、MIT、peerDependencies は typescript ^5.x。スライド6の「7.13.0」の裏付け(実行時の表示とも一致) |
| https://registry.npmjs.org/typescript(`npm view` で取得) | 2026-10-09 | latest は 7.0.2(公開 2026-07-08)、5.9.3 は 2025-09-30。TypeScript 7 の注意点(⚠️の4番)の裏付け |
| https://fastapi.tiangolo.com/tutorial/first-steps/ | 2026-10-09 | footer: スライド9。FastAPIがOpenAPI標準でAPI全体のスキーマを自動生成すること。/openapi.json、/docs(Swagger UI)、/redoc。クライアントコードの自動生成に使えること。`"openapi": "3.1.0"` の表示。GitHub の docs/en/docs/tutorial/first-steps.md(raw、HTTP 200)でも照合 |
| https://fastapi.tiangolo.com/features/ | 2026-10-09 | OpenAPIに基づくクライアントコードの自動生成が可能と記載(補強)。FastAPIはPythonの型宣言に基づく |
| https://yaml.org/spec/1.2.2/ | 2026-10-09 | YAMLの読み(英語): rhymes with "camel"(YAML 1.2.2、2021-10-01)。読み方メモを参照 |
| https://www.typescriptlang.org/tsconfig/#noEmit | 2026-10-09 | footer: スライド7。`noEmit` は出力ファイルを作らない設定で、型チェッカーとして使える(`tsc --noEmit`)。ページ本文の取得が途中で切れたため、TypeScript-Website の原文(https://raw.githubusercontent.com/microsoft/TypeScript-Website/v2/packages/tsconfig-reference/copy/en/options/noEmit.md、HTTP 200)と、手元の `tsc --help`(TypeScript 5.9.3、"Disable emitting files from a compilation.")で確認した |

- 出典は21件(確認のみのものを含む)。スライドの footer に載せたのは次の7件
  - https://spec.openapis.org/oas/latest.html(スライド3・5)
  - https://www.openapis.org/about(スライド3)
  - https://learn.openapis.org/best-practices(スライド5・9)
  - https://openapi-ts.dev/introduction(スライド6・7)
  - https://openapi-ts.dev/cli(スライド6)
  - https://www.typescriptlang.org/tsconfig/#noEmit(スライド7)
  - https://fastapi.tiangolo.com/tutorial/first-steps/(スライド9)
- Web検索を3回行った(根拠にはしていない): 仕様ファースト/コードファーストの公式の説明を探す検索、OpenAPIの読み方の公式記載を探す検索、FastAPIの読み方の公式記載を探す検索。後ろ2つは公式の記載を見つけられなかった

## ⚠️ 出典なし・未確認の情報

1. 読み方(発音): OpenAPI、OAI、Swagger、FastAPI、Linux Foundation、TypeScript、SmartBear、GET、API は公式の記載を確認できなかった
   - 確認した範囲は、openapis.org のトップ・about・style-guide、spec.openapis.org、検索2回。YAMLだけは yaml.org に英語の説明(rhymes with "camel")がある
   - 読み方メモを参照。セリフでは英字のまま表記し、読みを断定する言い方はしていない
2. openapi-typescript の OpenAPI 3.2 対応: 公式ドキュメントに記載なし(書かれているのは3.0と3.1だけ)
   - スライド6は「ツールの公式ドキュメントの対応版は OpenAPI 3.0 と 3.1」と事実だけを書いた
   - 参考の観察: サンプルの `openapi:` を 3.0.3 / 3.1.0 / 3.1.2 / 3.2.0 / 3.2.1 に変えても、生成された型は同一だった。公式の保証ではなく、3.2固有の機能は未確認
3. TypeScript 7 との組み合わせ: 公式の記載なし
   - openapi-typescript 7.13.0 の peerDependencies は typescript ^5.x。一方、npm の latest は TypeScript 7.0.2
   - 実測: 先に `npm i -D typescript`(7.0.2)を入れてから `npm i -D openapi-typescript` を実行すると、ERESOLVE で失敗した
   - スライド6と同じ1コマンド(`npm i -D openapi-typescript typescript`)なら成功し、typescript 5.9.3 が入る。TypeScript 7 での型生成と型チェックは未確認
4. GitHub のリリースページ(3.2.1)に年の表示がない。2026年という根拠は、仕様本文の改訂履歴表(2026-09-10)と spec.openapis.org の表示
5. 取得できず: `gh api` による OAI/OpenAPI-Specification のリリース情報は、アクセス拒否(HTTP 403、このセッションでは GitHub アクセスが無効)で取得できなかった。回避せず、WebFetch と raw.githubusercontent.com(許可リスト内)で代替した
6. learn.openapis.org の「公式」表記: ページ自身は「公式」と書いていない(OAIが公開し、フッターに © OpenAPI Initiative、リポジトリはOAI組織配下)。本文中に "in the opinion of the OpenAPI Initiative (OAI)" とあるため、スライドとセリフでは「OAIのガイド」と表記した
7. 「型のズレが減る」という効果の一般論: 出典なし。スライドは今回の実測(仕様の変更が型エラーとして見つかる)に限定している。実務での効果は差し込み欄(発表者の実体験)に任せた
8. 変わりうる情報: 最新版 3.2.1、openapi-typescript 7.13.0、対応版(3.0/3.1)は「2026年10月時点」と書いた。発表直前に spec.openapis.org/oas/latest.html と npm(`npm view openapi-typescript version`)を再確認してほしい

### 発表者に確認したい点

- スライド7の差し込み欄に実体験を入れるか、削るか
- コードスライド(5〜7)のコード量が目安を超えている(構成メモ参照)。減らしたい場合は相談
- サンプルは 3.1.0 で、最新の 3.2.1 と違う(理由はスライド6のセリフで説明している)。この説明の仕方でよいか

## 差し込み欄(スライド番号 | 何を入れるか)

| スライド番号 | 何を入れるか |
|---|---|
| 7 | 実務で型生成を使って、型のズレが減った(または困った)実体験 |

- スライド上の行: `【差し込み: 実務で型生成を使って、型のズレが減った(または困った)実体験】`
- セリフの行: `(※ここで実体験を話す: 実務で型生成を使って、型のズレが減った(または困った)経験について)`。「ここがポイントです。」の直後に置いてある。目安は30〜60秒
- 使わない場合: スライドの1行とセリフの1行を消す。前後は、実測した事実(仕様を変えると型エラーが出る)だけで話が通る
- 注意: 差し込みは実務での型生成の経験として話し、なければ削除する

## 動作確認(実行したもの / 未実行とその理由 / バージョン / 環境)

### 実行したもの

すべて作業用の空プロジェクトで実行した(2026-10-09)。

1. `npm i -D openapi-typescript typescript` → 33パッケージを追加。解決された版は openapi-typescript 7.13.0 と typescript 5.9.3
2. `npx openapi-typescript ./openapi.yaml -o ./schema.d.ts` → スライド6の出力のとおり(`openapi-typescript 7.13.0` と `./openapi.yaml → ./schema.d.ts [233.6ms]`)
   - 所要時間は実行のたびに変わる(今回の各回で 93〜261ms)。スライドは233.6msの回を載せた
3. `npx tsc --noEmit`(仕様が status のとき) → エラーなし(終了コード0)
4. `npx openapi-typescript ./openapi.yaml -o ./schema.d.ts --check`
   - 型が最新のとき: 終了コード0
   - 仕様を変えて、型を作り直す前: `Generated types are not up-to-date!` で終了コード1(スライドには載せていない)
5. 仕様の変更 status → state(`sed -i 's/status/state/' openapi.yaml`)→ 型を再生成 → `npx tsc --noEmit`
   - 結果: `client.ts(5,47): error TS2339: Property 'status' does not exist on type '{ id: string; state: "pending" | "paid" | "shipped"; }'.`(終了コード2)
   - スライド7に掲載
6. 候補の値の変更 paid → settled(`sed -i 's/paid/settled/' openapi.yaml`)→ 型を再生成 → `npx tsc --noEmit`
   - 結果: `client.ts(5,41): error TS2367: This comparison appears to be unintentional because the types '"pending" | "settled" | "shipped"' and '"paid"' have no overlap.`(終了コード2)
   - スライドには載せていない。スライド7のセリフ「候補の文字列を変えても、同じように見つかります」の根拠
7. 仕様と型を元に戻して `npx tsc --noEmit` → エラーなし(終了コード0)
8. FastAPI: 同じ `Order` を pydantic のモデル(`Literal["pending", "paid", "shipped"]`)で書き、`app.openapi()` を出力
   - 結果: `"openapi": "3.1.0"`、paths は `/orders/{order_id}`、`Order` の enum は仕様どおり
   - Starlette の TestClient で `/openapi.json`、`/docs`、`/redoc`、`/orders/a1` がすべて HTTP 200(TestClient 使用時に、httpx に関する Starlette の非推奨警告が出たが、動作には影響なし)
9. FastAPI が出力した openapi.json を、同じコマンドで型に変換 → 成功。`Order` は `id: string` と、`status` が3つの候補の文字列の型
   - スライド9・10の「型を作る手順は、どちらの流れでも同じ」の根拠。FastAPI側の出力はコメント行が少し増えるが、型の形は同じ
10. バージョン文字列の確認: `openapi:` の値を 3.0.3 / 3.1.0 / 3.1.2 / 3.2.0 / 3.2.1 に変えて生成 → 5通りとも同一の出力(スライド6の出力と同じ)。観察であり、公式の対応保証ではない
11. Redocly CLI 2.62.1 で lint
    - `--extends=minimal`(仕様としての妥当性): valid、警告3(servers なし、operation summary なし、security 未定義)
    - recommended ルール: error 3、warning 2(上の3つに加え、license 未記載と 4XX 応答なし)
    - サンプルを発表用に小さくしているための指摘。実運用の仕様では書く
12. TypeScript 7 との組み合わせ(別ディレクトリ): `npm i -D typescript`(7.0.2)の後に `npm i -D openapi-typescript` → ERESOLVE で失敗(peer が typescript ^5.x)。1コマンドで両方を指定すると成功し、typescript は 5.9.3
13. 図とスライドのPNG確認: `lt-mmdc` で `mermaid/flows.mmd` から `画像/flows.png`(940×666)を作成。`lt-marp-png` で全10枚をPNG化し、はみ出し・日本語フォント・図の収まりを目視した。最終版を再描画して確認済み

### 未実行とその理由

- uvicorn で実サーバーを起動してのブラウザ確認(Swagger UI と ReDoc の見た目): 未実行。発表で画面を見せないため。TestClient で HTTP 200 までの確認
- TypeScript 7 での型生成と型チェック: 未実行。標準の手順(peer 依存の解決)では入らない。`--legacy-peer-deps` などでの強行は未検証
- openapi-typescript での OpenAPI 3.2 固有機能の確認: 未実行(公式ドキュメントに記載なし)
- ライブデモ: なし(BRIEF の方針。コマンドと出力をスライドに載せた)

### バージョン

- OpenAPI Specification: v3.2.1(2026-09-10)
- openapi-typescript: 7.13.0(npm の latest、公開 2026-02-11)
- typescript: 5.9.3(デモで解決された版。npm の latest は 7.0.2)
- Node.js v22.22.0、npm 10.9.4
- Python 3.13.16、fastapi 0.143.0、pydantic 2.14.0、starlette 1.7.0、httpx 0.28.1
- Redocly CLI 2.62.1(lint のみ)
- marp-cli 4.5.1(BRIEF の記載。ラッパー経由で使用)

### 環境

Linux 6.18.44(コンテナ)。外部通信は許可リスト制(npm と GitHub の raw は可、spec.openapis.org などへの curl は拒否されたため WebFetch を使用)。

### スライド上の加工(実際の出力との差)

- コマンド出力の先頭の絵文字(✨ と 🚀)を除いた。Marp が絵文字を外部画像として描画し、オフラインのプレビューで壊れるため。文字の部分は実際の出力のまま
- `tsc` のエラーは実際は1行。スライド幅に合わせて手で2行に折り返した
- `schema.d.ts` から `Order` の部分(5行)を抜粋し、インデントを詰めて、前後を `...` で省略した
- `openapi.yaml`(全28行)は抜粋し、省略した部分を `...` で示した。`schema:` の行のインデントは元ファイルのまま
- コードブロックの末尾に空行を1行入れた(Marp でコードの最終行が欠けるのを避けるため)
- `npm i` の出力(追加したパッケージ数など)は載せていない

### 再現用ファイル(全文)

作業用のファイルは SCR/work/08_OpenAPI/ に残してあるが、消える可能性があるため、必要なものを下に載せる。

手順:

```bash
mkdir demo && cd demo && npm init -y
npm i -D openapi-typescript typescript
# openapi.yaml、client.ts、tsconfig.json を下の内容で作る
npx openapi-typescript ./openapi.yaml -o ./schema.d.ts
npx tsc --noEmit                      # エラーなし
sed -i 's/status/state/' openapi.yaml  # 仕様の変更
npx openapi-typescript ./openapi.yaml -o ./schema.d.ts
npx tsc --noEmit                      # client.ts で TS2339 のエラー
```

openapi.yaml(全文):

```yaml
openapi: 3.1.0
info:
  title: Order API
  version: 0.1.0
paths:
  /orders/{order_id}:
    get:
      operationId: getOrder
      parameters:
        - name: order_id
          in: path
          required: true
          schema: { type: string }
      responses:
        "200":
          description: OK
          content:
            application/json:
              schema: { $ref: "#/components/schemas/Order" }
components:
  schemas:
    Order:
      type: object
      required: [id, status]
      properties:
        id: { type: string }
        status: { type: string, enum: [pending, paid, shipped] }
```

client.ts:

```ts
import type { components } from "./schema";

type Order = components["schemas"]["Order"];

export const isPaid = (order: Order) => order.status === "paid";
```

tsconfig.json:

```json
{
  "compilerOptions": {
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "strict": true,
    "noEmit": true
  },
  "include": ["client.ts"]
}
```

`module` と `moduleResolution` の設定は、openapi-typescript の公式ドキュメント(introduction)に書かれている設定に合わせた。`strict` と `noEmit` は型チェックのために追加した。

## 読み方メモ(語 | 採用する読み | 根拠)

| 語 | 採用する読み | 根拠 |
|---|---|---|
| OpenAPI | オープンエーピーアイ | 公式記載なし。慣用として「オープンエーピーアイ」(openapis.org のトップ・about・style-guide に読み方の記載なし) |
| API | エーピーアイ | 公式記載なし。慣用として「エーピーアイ」 |
| OAI | オーエーアイ | 公式記載なし。慣用として「オーエーアイ」(アルファベットを1字ずつ読む) |
| Swagger | スワッガー | 公式記載なし。慣用として「スワッガー」 |
| YAML | ヤムル | yaml.org の YAML 1.2.2 に、英語で rhymes with "camel" とある。カタカナの表記は慣用(「ヤメル」と読む人もいる) |
| FastAPI | ファストエーピーアイ | 公式記載なし(検索でも確認できず)。慣用として「ファストエーピーアイ」 |
| Linux Foundation | リナックスファウンデーション | 公式記載なし。慣用として「リナックスファウンデーション」 |
| TypeScript | タイプスクリプト | 公式記載なし。慣用として「タイプスクリプト」 |
| GET | ゲット | 公式記載なし。慣用として「ゲット」 |
| Order | オーダー | サンプルの識別子。公式記載なし。慣用として「オーダー」 |
| id | アイディー | サンプルの識別子。公式記載なし。慣用として「アイディー」 |
| status | ステータス | サンプルの識別子。公式記載なし。慣用として「ステータス」 |
| SmartBear | スマートベア | スライドのみ(セリフでは読まない)。公式記載なし。慣用として「スマートベア」 |
| JSON、HTTP、OAS | セリフでは読まない | 画面の表記のみ |

- セリフ内の表記は統一している(OpenAPI、API、OAI、YAML、FastAPI、TypeScript は英字のまま)

## 言い換え表(言いにくい語 | 言い換え候補)

| 言いにくい語 | 言い換え候補 |
|---|---|
| OpenAPI | ウェブAPIの標準仕様 / 仕様ファイルの規格 |
| OAI(OpenAPI Initiative) | 仕様を決めている団体 / 規格の団体 |
| Linux Foundation | 上にある財団 / 親の財団 |
| Swagger | もとの名前 / 昔の名前 |
| YAML | テキスト形式 / 書き方の形式 |
| FastAPI | Python製のAPIの道具 / PythonのAPI用の道具 |
| TypeScript | 型のある言語 / 型を扱う言語 |
| openapi-typescript | 型を作るツール / 画面のツール |
| 仕様ファースト | 先に仕様を書く流れ / 仕様が先 |
| コードファースト | 先にコードを書く流れ / コードが先 |
| 仕様ファイル | 仕様を書いたファイル / 仕様 |
| エンドポイント | 入り口(セリフで使用) / APIの窓口 |
| スキーマ(schema) | データの形 / 項目の定義 |
| `$ref` | 参照(セリフで使用) / 同じ定義を指す印 |
| enum | 決まった候補の文字列(セリフで使用) / 選択肢 |
| GET | 取得する操作 / 読み取りの操作 |
| Order | 注文のデータ / 注文 |
| status | 状態の項目 / 状態 |
| `tsc`、`--noEmit` | 型のチェック(コマンド名は読まない) |

## 質問されそうな点(3〜5個、答えと出典つき)

1. 最新版が 3.2.1 なのに、サンプルが 3.1.0 なのはなぜか
   - 答え: openapi-typescript の公式ドキュメントが対応を書いているのは OpenAPI 3.0 と 3.1 だけで、3.2 の記載はないため。版番号は major.minor が機能の区分、.patch は誤りの修正・明確化なので、3.2.1 は 3.2 のパッチ版
   - 補足: このサンプルでは 3.0.3 から 3.2.1 のどの文字列でも、出力は同一だった。ただし公式の保証ではなく、3.2固有の機能は未確認
   - 出典: https://openapi-ts.dev/introduction、https://spec.openapis.org/oas/latest.html、動作確認の10番
2. 仕様ファーストとコードファーストは、結局どちらがよいか
   - 答え: OAIのガイドは仕様ファーストを推奨している。理由は、コードで作れるAPIが、OpenAPIで記述できる範囲より広く、後から記述しようとして合わなくなることがあるため。同じガイドは、どちらの流れでも情報の置き場を1つに保つこと(single source of truth)を求めている。コード注釈から仕様を作る方法は、コードファーストと相性がよいとも書かれている
   - コードファーストの例として、FastAPI はコード注釈から OpenAPI のスキーマを自動で作る
   - 出典: https://learn.openapis.org/best-practices、https://fastapi.tiangolo.com/tutorial/first-steps/
3. 型は実行時の検証にもなるのか
   - 答え: ならない。公式ドキュメントは「runtime-free types」と説明しており、生成されるのは型の定義で、実行時のコードは含まれない。実行時の入力を検証したい場合は、別の仕組みが必要(この発表の範囲外)
   - 出典: https://openapi-ts.dev/introduction
4. TypeScript 7 でも使えるか
   - 答え: 未確認。openapi-typescript 7.13.0 の peerDependencies は typescript ^5.x で、npm の latest は TypeScript 7.0.2。7.0.2 を先に入れてから openapi-typescript を入れると ERESOLVE で失敗した。スライドの1コマンドなら 5.9.3 が入って成功する
   - 出典: https://registry.npmjs.org/openapi-typescript、https://registry.npmjs.org/typescript、動作確認の12番
5. Swagger と OpenAPI は何が違うのか
   - 答え: OpenAPI Specification は、もとは SmartBear が寄贈した Swagger Specification。改訂履歴にも「2015-12-31: Swagger 2.0 をOAIへ寄贈」とある。仕様の名前が OpenAPI で、Swagger の名前は FastAPI の `/docs` の Swagger UI のように、ツールの名前として残っている
   - 出典: https://www.openapis.org/about、https://raw.githubusercontent.com/OAI/OpenAPI-Specification/3.2.1/versions/3.2.1.md(改訂履歴)、https://fastapi.tiangolo.com/tutorial/first-steps/
