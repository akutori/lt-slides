# memo: Typst

※ 作成担当のメモが無かったため、独立点検担当が 2026-10-10 に新規作成した。出典・動作確認は、点検時に自分で開く/再実行して確認できたものだけを書いている。

## 前提(想定時間・枚数・ツール・作成日)

- 想定時間: 10分(セリフ合計 2334字。1分300字換算で約8分。差し込み欄2か所は別枠)
- 枚数: 10枚(タイトル1・見出し3・本文5・まとめ1)
- ツール: Typst 0.15.1 + Touying 0.8.0(simple テーマ)。Marp ではない。フォントは Noto Sans CJK JP / Noto Sans Mono CJK JP
- 作成日: スライド 2026-10-09 / このメモ 2026-10-10
- ファイル: Typst.typ(ソース)/ Typst.pdf(発表用)/ Typst_notes.pdf(右側にセリフを表示)/ 画像/ / preview/(確認用PNG)
- 再生成コマンド(Typst.typ のあるフォルダで実行。Touying は初回に自動取得される)
  - `typst compile Typst.typ`
  - `typst compile --input notes=true Typst.typ Typst_notes.pdf`
- 注意: `#speaker-note[...]` の1行は、途中で改行しない(ソース内の改行は半角スペースになるため)
- 「2026年10月時点」の情報: 最新版 0.15.1、Touying 0.8.0、HTML 出力が実験段階であること

## 構成メモ(スライド番号 / 種別 / 要旨)

| # | 種別 | 要旨 |
|---|------|------|
| 1 | タイトル | Typst(タイトルのみ) |
| 2 | 見出し | Typstとは |
| 3 | 本文 | 概要: 種類・書き方・公式の目標・読み方・ライセンスと実装・パッケージ・最新版(表) |
| 4 | 本文 | ソースと結果: 画像/sample.typ とその出力(sample.png)、変換コマンド1行 |
| 5 | 本文 | Touyingでスライド: 画像/mini-deck.typ と出力2枚、PDFを2種類出力する話。差し込み欄あり |
| 6 | 見出し | 日本語の扱い |
| 7 | 本文 | 日本語の設定: lang / font / cjk-latin-spacing、改行規則、実測、ソース内改行の注意 |
| 8 | 見出し | Marpとの違い |
| 9 | 本文 | 比較: 書き方・出力・数式・セリフ・実行環境(表) |
| 10 | まとめ | 5項目。差し込み欄あり |

## 出典一覧(URL | 確認日 | 何の裏付けか)

| URL | 確認日 | 何の裏付けか |
|-----|--------|--------------|
| https://github.com/typst/typst | 2026-10-10 | README: 定義(markup-based typesetting system)、目標(LaTeX と同等に強力で、学びやすく使いやすい)、読み方(IPA /taɪpst/、「Pronunciation and Spelling」節)。Cargo.toml / LICENSE: Apache-2.0。Releases: v0.15.1 が Latest(2026-07-17) |
| https://typst.app/docs/reference/syntax/ | 2026-10-10 | マークアップ・数式($)・スクリプト(#)の書き方。見出しは等号、強調は星印、箇条書きはハイフン |
| https://typst.app/docs/guides/for-latex-users/ | 2026-10-10 | パッケージは初回の使用時に Typst Universe から自動で取得され、以後はキャッシュされる。単体の小さなバイナリ。数式は標準機能 |
| https://typst.app/docs/reference/png/ | 2026-10-10 | PNG 出力と `--ppi`(既定は144) |
| https://typst.app/docs/reference/html/ | 2026-10-10 | HTML 出力は開発中で、機能フラグの先で試せる段階(本番利用は非推奨)。PDF・PNG・SVG との対比 |
| https://typst.app/docs/reference/text/text/ | 2026-10-10 | `font`(優先リストとフォールバック)、`lang`、`cjk-latin-spacing`(和欧文の間隔を自動で入れるか) |
| https://github.com/typst/typst/tree/v0.15.1/crates/typst-layout/src/inline | 2026-10-10 | shaping.rs: 日本語(`Lang::JAPANESE`)は `CjkPunctStyle::Jis`(コメント「Standard JIS X 4051, used in Japan」)。linebreak.rs: UAX #14 の改行機会(ICU4X)。自動取得ツールは robots.txt で拒否されるため、同じタグの raw ファイルで確認した |
| https://typst.app/universe/package/touying/ | 2026-10-10 | Touying 0.8.0、必要な Typst は 0.15.0 以上、ライセンスは MIT |
| https://github.com/touying-typ/touying | 2026-10-10 | 名前の意味(投影。中国語、/tóuyǐng/、projection)。`=` が見出しスライド、`==` が本文スライド。`#speaker-note` と `show-notes-on-second-screen`。PPTX・HTML は外部ツール経由(Export 欄) |
| https://github.com/marp-team/marp-cli | 2026-10-10 | HTML・PDF・PowerPoint・画像へ変換。PDF・PPTX・画像は Chrome / Edge / Firefox のどれかが必要。Node.js 版と単体バイナリ |
| https://github.com/marp-team/marp-core | 2026-10-10 | 数式は MathJax と KaTeX(v4 の README: 既定は MathJax。main の README: オプションのプラグイン) |
| https://marpit.marp.app/usage?id=presenter-notes | 2026-10-10 | HTML コメントがスライドごとの発表者ノートになる(同ページは JS 描画のため、リポジトリの docs/usage.md で本文を確認した) |
| https://marp.app/ | 2026-10-10 | Marp の出力形式(HTML・PDF・PowerPoint)。読み方の記載は無い(footer には載せていない。読み方の確認用) |
| https://www.latex-project.org/about/ | 2026-10-10 | LaTeX の読み方(Lah-tech または Lay-tech)(footer には載せていない。読み方の確認用) |

## ⚠️ 出典なし・未確認の情報

- 実測値「106通りの幅・約4900行で、行頭の句読点・閉じ括弧は0件」: 一次情報ではなく、資料作成時の自作実験の結果。検査文章は自作、幅は本文幅 6em〜45em(0.37em刻み)、Typst 0.15.1、Noto Sans CJK JP に限った結果で、一般的な保証ではない。スライドとセリフは「測った範囲では」の言い方にしている
- 「ソース内の改行は半角スペースになる(実測)」: 公式ドキュメントでの記載は未確認。作成時の測定のみ(動作確認を参照)
- 「`lang: "ja"` で句読点・括弧の幅調整が JIS X 4051 の方式になる」: 公式ドキュメント(HTML)に記載を確認できず、根拠はソースコード(shaping.rs)のみ。PDF 上で幅の違いを測る実験は、実行記録を確認できず
- 「改行位置は UAX #14 に従う」: 根拠はソースコードのコメント。ICU4X の分割器が基本で、リンクや中国語・日本語の引用符などに Typst 独自の調整がある
- 読み方「トウイン」「マープ」「アパッチ」「ラスト」: 公式のカタカナ記載なし(慣用・暫定)。セリフでは断定していない(読み方メモを参照)
- 比較表の「出力」は Typst 本体の出力。Touying の README は、外部ツール(Tylina の実験的な PPTX 出力、touying-exporter の PPTX・HTML 出力)を挙げている。比較表の「出力」欄には「PPTXは外部ツール」と書き、スライド9のfooterに touying のリポジトリを加えた。まとめの「PPTXやHTMLを標準機能で出したいか」は、標準機能での比較(質問されそうな点の2を参照)
- Marp Core の数式: v4 の README では MathJax が既定、main の README(v5 系)ではオプションのプラグイン。表の「対応」は両方で成り立つが、版による違いは調べ切っていない
- 「最新版 0.15.1」は 2026-10-10 時点。発表までに更新される可能性がある(発表前に Releases を再確認)
- セリフの「検証環境で、幅を変えながら、大量に組んで測った結果です」は、資料作成時に行った測定の話で、発表者本人の実験ではない。自分の実験として話すなら、再実行してから(動作確認の方法を参照)

## 差し込み欄(スライド番号 | 何を入れるか)

| スライド | 何を入れるか |
|----------|--------------|
| 5 | Touyingでスライドを作った感想(スライド: `#ph[...]` / セリフ: `(※ここで実体験を話す: ...)`) |
| 10 | 自分ならどちらを使うか(使い分けの考え)(スライド: `#ph[...]` / セリフ: `(※ここで実体験を話す: ...)`) |

- 発表者について使ってよいのは「LTスライド・文書作成の仕組みで、Typst を選択肢の1つとして扱っている」だけ(スライド10のセリフで使用済み)
- 差し込み欄を空けても、前後の事実部分で話は通る

## 動作確認(実行したもの / 未実行とその理由 / バージョン / 環境)

### 実行した

- Typst CLI 0.15.1: crates.io のソースから `cargo install typst-cli --version 0.15.1 --locked` でビルド(約27分)。`typst --version` は「typst 0.15.1 (unknown commit)」(ソース配布からのビルドのため)。GitHub Releases の配布バイナリは、この環境から取得できなかったため
- Touying 0.8.0(依存の uniwarn 0.1.1 を含む)を @preview から取得して、Typst.typ をコンパイル
- `typst compile Typst.typ` → Typst.pdf(10ページ、PDF の Creator 欄は Typst 0.15.1)
- `typst compile --input notes=true Typst.typ Typst_notes.pdf` → 10ページ(幅は発表用の2倍)。右側のセリフ欄が用紙内に収まり、全セリフ行が含まれることを `check_notes_pdf.py` で確認。1ページ目だけ NG と出るが、タイトルスライドでは先頭のセリフ行を見出し欄と取り違えるスクリプト側の仕様で、目視では7行すべて表示されている
- 画像/sample.png: `typst compile sample.typ sample.png --ppi 250`(スライド4に載せたコマンドそのもの)。点検時に同じコマンドで再生成し、PNG がバイト単位で一致した
- 画像/mini-1.png と mini-2.png: 画像/mini-deck.typ を 72ppi で書き出したもの。点検時に再生成し、バイト単位で一致した
- 禁則の実測: 自作の日本語文章(句読点・括弧・小書き仮名・長音などを多く含む)を、本文幅 6em〜45em を 0.37em 刻みにした106通りで組み、PDF から行を再構成して数えた(pdftotext -bbox)
  - 右端を揃えない組み: 4895行で、行頭に来てはいけない文字は0行、行末に来てはいけない文字(開き括弧)は0行
  - 両端揃え: 4563行で、どちらも0行
  - 陽性対照(各文字の後ろにゼロ幅スペースを入れて禁則を迂回させたもの): 行頭954行・行末194行を検出。検査そのものは機能している
  - 点検時に、保存されていた PDF から再集計して一致した
- 改行の実測: フォント20pt で、ソース内で改行したもの 124.48pt、1行で書いたもの 120pt。改行の位置に半角スペース相当(4.48pt)が入る
- 日本語の設定: `lang: "ja"` の有無とフォント指定の有無、`cjk-latin-spacing` の auto / none の比較ファイルを作成。auto / none の見え方は、スライド7の表の中でも実際に表示している
- 点検時に、Typst.pdf と Typst_notes.pdf を同じコマンドで再コンパイルし、文字の抽出結果が保存済みの PDF と一致することを確認

### 未実行 / 実行記録を確認できず

- `lang: "ja"` による句読点・括弧の幅調整(JIS X 4051)を、PDF 上で測る実験: 実行記録を確認できず。公式ソースの記載のみ
- HTML 出力、PPTX 出力(Touying の外部ツール経由): 未実行(公式ドキュメントの記載のみ。スライドでは「実験段階」と書いている)
- Marp 側の変換・数式・HTML コメントのセリフ: 本デッキでは未実行(公式ドキュメントの記載のみ)
- 縦書き、ルビ: 調べていない(スライドでは触れていない)

### バージョン・環境

- Typst 0.15.1 / Touying 0.8.0(必要な Typst は 0.15.0 以上)
- Linux x86_64。フォントは Noto Sans CJK JP と Noto Sans Mono CJK JP(PDF に埋め込み済み)

## 読み方メモ(語 | 採用する読み | 根拠)

| 語 | 採用する読み | 根拠 |
|----|--------------|------|
| Typst | タイプスト | README「Pronunciation and Spelling」に IPA /taɪpst/(「Ty」は Typesetting の Ty、「pst」は Hipster の pst)。カタカナ表記は公式記載なし。IPA に近い慣用として「タイプスト」 |
| Touying | トウイン | README に「投影(中国語)、/tóuyǐng/」とある。カタカナの公式記載なし。セリフでは「ここでは、トウインと呼びます」と断定を避けている |
| Marp | マープ | 公式サイト・README に読みの記載なし。慣用として「マープ」。セリフ内は「マープ」で統一 |
| LaTeX | ラテック | 公式(latex-project.org/about)に Lah-tech / Lay-tech とある。前者に近いカタカナとして「ラテック」 |
| Apache | アパッチ | 公式の読みの確認はしていない。慣用として「アパッチ」 |
| Rust | ラスト | 公式の読みの確認はしていない。慣用として「ラスト」 |
| Universe | ユニバース | 一般の英単語の読み |
| Markdown | マークダウン | 一般的な読み |
| Node.js | ノード | セリフでは「ノード」と略す。公式の読みは確認していない |
| PPTX | (読まない。セリフは「パワーポイント形式」) | 略称を読み上げないため |
| UAX #14 / JIS X 4051 | (読まない。セリフは「ユニコードの規則」「日本の組版の規格」) | 番号を読み上げないため |

## 言い換え表(言いにくい語 | 言い換え候補)

| 言いにくい語 | 言い換え候補 |
|--------------|--------------|
| タイプスト(Typst) | このツール / この組版ツール |
| トウイン(Touying) | スライド用のパッケージ / このパッケージ |
| マープ(Marp) | マークダウンで書くスライドツール / もう一つのスライドツール |
| ラテック(LaTeX) | 従来の組版ツール / 組版の古くからあるツール |
| 組版 | 文章をページの形に整えること |
| マークアップ | 短い記号で書く書き方 |
| スクリプト | コードで書く部分 |
| コンパイル | 変換 |
| パッケージ | 追加の部品 |
| ユニバース(Universe) | 公式の部品置き場 / 公式のパッケージ置き場 |
| アパッチ(Apache-2.0) | オープンソースのライセンスの一つ / ライセンスの名前 |
| ラスト(Rust) | プログラミング言語の一つ |
| マークダウン | 記号で書く文書の形式 |
| パワーポイント形式 | スライドの標準的なファイル形式 |
| ユニコード | 文字の国際的な規格 |
| 実行ファイル | プログラム本体 |

- スライド9の「マープは、ノードか、単体の実行ファイルで動きます。」は、マープとノードが並ぶ。詰まりそうなら「ノードか」を省いて「マープは、単体の実行ファイルでも動きます。」と言ってよい(Node.js の版は表に載っている)
- スライド3・10の「タイプストは、…組版システムです。」も固有名詞と専門語が並ぶが、直後に「組版、つまり…」と言い換えてある(スライド10は既出のため、そのまま)

## 質問されそうな点(3〜5個、答えと出典つき)

1. LaTeX の代わりになりますか?
   - 公式の目標は「LaTeX と同等に強力で、学びやすく使いやすい」こと。「代わりになる」とは言い切らず、用途しだいと答える。LaTeX ユーザー向けの対応表が公式ガイドにある
   - 出典: https://github.com/typst/typst / https://typst.app/docs/guides/for-latex-users/
2. スライドを PPTX にできますか?
   - Typst 本体の出力は PDF・PNG・SVG で、HTML は実験段階。Touying の README は、外部ツール(Tylina の実験的な PPTX 出力、touying-exporter の PPTX・HTML 出力)を挙げている(2026年10月時点)。Marp は PPTX を標準で出力できる(変換にはブラウザが必要)
   - 出典: https://typst.app/docs/reference/html/ / https://github.com/touying-typ/touying / https://github.com/marp-team/marp-cli
3. Marp より速い・軽いですか?
   - 比較していないので、答えない。Typst の公式ガイドは「コンパイルは通常ミリ秒」と述べ、本体は単体の小さなバイナリ。Marp も単体バイナリを配布している(PDF などの変換にはブラウザが必要)
   - 出典: https://typst.app/docs/guides/for-latex-users/ / https://github.com/marp-team/marp-cli
4. ネットワークが必要ですか?
   - Touying などのパッケージは、各パッケージの初回の使用時に Typst Universe から自動で取得され、以後はキャッシュされる
   - 出典: https://typst.app/docs/guides/for-latex-users/
5. 日本語の縦書きやルビは使えますか?
   - 今回は調べていないので「確認していません」と答える。確認したのは、横書きでの句読点・括弧の幅調整(`lang`)、和欧文の間隔(`cjk-latin-spacing`)、行頭の禁則の実測だけ
   - 出典: なし(未調査)
