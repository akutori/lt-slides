// Typst.typ — AkarengaLT 第50回「Typst」
// このスライド自体を Typst + Touying で作成している。
//
// 発表用PDF(セリフなし):     typst compile Typst.typ
// セリフ付きPDF(右側に表示): typst compile --input notes=true Typst.typ Typst_notes.pdf
//
// 前提: Typst 0.15 以上 / Touying 0.8.0(@preview から初回に自動取得) / フォント Noto Sans CJK JP
// セリフは speaker-note 関数に渡す(1行1段落)。段落の途中では改行しない(改行は半角スペースになるため)。

#import "@preview/touying:0.8.0": *
#import themes.simple: *

#let with-notes = sys.inputs.at("notes", default: "false") == "true"
#let mono = "Noto Sans Mono CJK JP"
#let primary = aqua.darken(50%)

#set document(title: [Typst])
#set text(lang: "ja", font: "Noto Sans CJK JP", cjk-latin-spacing: none)
#show raw: set text(font: mono)

// コードブロック(コンパイルしたファイルそのものを表示する)
#show raw.where(block: true): it => block(
  width: 100%,
  fill: luma(245),
  stroke: 0.6pt + luma(215),
  inset: (x: 12pt, y: 10pt),
  radius: 4pt,
  text(size: 15pt, it),
)

// コマンド(端末の1行)
#let cmd(s) = block(
  width: 100%,
  fill: luma(38),
  inset: (x: 12pt, y: 8pt),
  radius: 4pt,
  text(fill: white, font: mono, size: 15pt, "$ " + s),
)

// 差し込み欄(発表者が実体験を入れる箇所)
#let ph(body) = text(size: 19pt, fill: rgb("#b45309"))[【差し込み: #body】]

// 出典(本文スライドの下部に小さく)
#let src(..urls) = {
  v(1fr)
  move(dy: 17pt, block(width: 88%, text(size: 10pt, fill: luma(110), urls.pos().map(u => box(u)).join(h(1.4em)))))
}

// 見出しスライド(見出しのみ。まとめは通常の本文スライドとして書く)
#let heading-slide(config: (:), body) = {
  let setting(b) = {
    text(size: 60pt, weight: "bold", utils.display-current-heading(level: 1))
    align(left, b)
  }
  centered-slide(config: config, setting: setting, body)
}

// セリフ付きPDFの右側パネル。長いセリフは、収まる最大の文字サイズに自動で縮める
// (収まらないときはコンパイルを止める。溢れた行が黙って切れるのを防ぐため)
#let my-notes(self: none, note: none, slide-preview: none) = layout(size => {
  let head-h = 36pt
  let pad-x = 28pt
  let pad-y = 12pt
  let w = size.width - 2 * pad-x
  let h = size.height - head-h - 2 * pad-y
  let styled(s, body) = {
    set text(size: s, fill: black, weight: "regular")
    set par(spacing: 0.6em, leading: 0.5em)
    body
  }
  let sizes = range(34, 23, step: -1).map(i => i * 0.5pt)
  let pick = sizes.find(s => std.measure(width: w, styled(s, note)).height <= h)
  assert(pick != none, message: "セリフが長すぎて、パネルに収まりません")
  stack(
    dir: ttb,
    block(
      width: 100%,
      height: head-h,
      fill: self.colors.primary,
      inset: (x: pad-x),
      align(horizon, text(
        size: 18pt,
        fill: white,
        utils.display-current-heading(depth: self.slide-level),
      )),
    ),
    block(
      width: 100%,
      height: size.height - head-h,
      fill: white,
      inset: (x: pad-x, y: pad-y),
      styled(pick, note),
    ),
  )
})

#show: simple-theme.with(
  aspect-ratio: "16-9",
  primary: primary,
  subslide-preamble: block(
    below: 0.7em,
    text(30pt, weight: "bold", utils.display-current-heading(depth: 2)),
  ),
  config-common(
    show-notes-on-second-screen: if with-notes { right } else { none },
    new-section-slide-fn: heading-slide,
    notes-fn: my-notes,
  ),
)

// ================= 1. タイトル =================
#title-slide(config: config-common(freeze-slide-counter: false))[
  #text(size: 72pt, weight: "bold")[Typst]
  #speaker-note[
    さて、始めます。

    今日は、タイプストの話です。

    実は、この資料も、タイプストで作っています。

    スライドも、発表用の原稿も、同じファイルに書いています。

    流れは、三つです。

    概要と、日本語の扱いと、マープとの違いです。

    では、よろしくお願いします。
  ]
]

// ================= 2. Typstとは =================
= Typstとは
#speaker-note[
  まずは、タイプストがどんなツールなのかを、画面の表の項目に沿って確認していきます。
]

== 概要
#set text(size: 23pt)
#table(
  columns: (auto, 1fr),
  align: left + horizon,
  stroke: (x, y) => (bottom: 0.5pt + luma(205)),
  inset: (x: 10pt, y: 12pt),
  [*種類*], [マークアップで書く組版システム],
  [*書き方*], [マークアップ、数式、\#で始まるスクリプト],
  [*公式の目標*], [LaTeXと同等に強力で、学びやすく使いやすい],
  [*読み方*], [\/taɪpst\/(タイプスト)],
  [*ライセンス・実装*], [Apache-2.0、Rust],
  [*パッケージ*], [Typst Universeから、初回の使用時に自動で取得],
  [*最新版*], [0.15.1(2026年10月時点)],
)
#speaker-note[
  で、タイプストは、新しい組版システムです。

  組版、つまり文章をページの形に整える作業のことです。

  書き方は、二本立てです。

  一つ目は、マークアップです。

  見出しや箇条書きを、短い記号で書けます。

  二つ目は、スクリプトです。

  計算や繰り返しを、コードで書けます。

  どちらも、同じファイルの中で使えます。

  ここがポイントです。

  次に、目標です。

  公式の説明では、ラテックと同じくらい強力で、学びやすく使いやすいことが目標です。

  ちなみに、読み方は、タイプストです。

  公式の説明書きに、発音記号つきで書いてあります。

  ライセンスは、アパッチです。

  実装は、ラストという言語です。

  そして、パッケージ、つまり追加の部品の話です。

  ユニバースという置き場から、使うときに自動で取得されます。

  最新版の番号は、画面のとおりです。
]
#src(
  "https://github.com/typst/typst",
  "https://typst.app/docs/reference/syntax/",
  "https://typst.app/docs/guides/for-latex-users/",
)

== ソースと結果
#set text(size: 22pt)
#grid(
  columns: (1.3fr, 1fr),
  gutter: 20pt,
  align: left + top,
  raw(read("画像/sample.typ").trim(), lang: "typ", block: true),
  block(
    stroke: 0.8pt + luma(190),
    image(
      "画像/sample.png",
      width: 100%,
      alt: "左のソースをコンパイルした結果。見出し、強調、箇条書き、総和の数式、関数の計算結果が表示されている",
    ),
  ),
)
#v(12pt)
#cmd("typst compile sample.typ sample.png --ppi 250")
#speaker-note[
  では、実際に書いてみます。

  左が、ソースです。

  右が、コンパイル、つまり変換した結果です。

  左のソースは、実際に変換したファイルそのものです。

  右の画像も、その実際の出力です。

  見出しは、等号で書きます。

  強調は、星印で囲みます。

  箇条書きは、ハイフンです。

  数式は、ドル記号で囲んで書きます。

  ここまでが、マークアップです。

  次の二行は、スクリプトです。

  関数を一つ定義して、文章の中で呼び出しています。

  計算の結果が、そのまま文章に入ります。

  つまり、書いた文章が、そのままページになります。

  変換のコマンドは、画面の一行だけです。

  出力は、PDFだけでなく、画像にもできます。

  最後の指定は、画像の細かさです。

  ところで、数字と日本語の間が、少し空いています。

  これは、あとで説明します。

  以上が、基本の書き方です。
]
#src("https://typst.app/docs/reference/syntax/", "https://typst.app/docs/reference/png/")

== Touyingでスライド
#grid(
  columns: (1.3fr, 1fr),
  gutter: 20pt,
  align: left + top,
  [
    #raw(read("画像/mini-deck.typ").trim(), lang: "typ", block: true)
    #v(4pt)
    #set text(size: 20pt)
    #set list(spacing: 0.6em)
    - この資料も、この方法で作成
    - 同じソースから、PDFを2種類出力
    - 発表用(セリフなし)と、セリフ付き
    #v(2pt)
    #ph[Touyingでスライドを作った感想]
  ],
  [
    #block(stroke: 0.8pt + luma(190), image(
      "画像/mini-1.png",
      width: 78%,
      alt: "左のソースから作られた1枚目。見出しスライド",
    ))
    #v(6pt)
    #block(stroke: 0.8pt + luma(190), image(
      "画像/mini-2.png",
      width: 78%,
      alt: "左のソースから作られた2枚目。本文スライド",
    ))
  ],
)
#speaker-note[
  さて、次はスライドです。

  スライドは、パッケージを読み込んで作ります。

  名前は、ここでは、トウインと呼びます。

  中国語で、投影という意味の言葉だと、説明書きにあります。

  これは、ユニバースに公開されています。

  使い方は、画面の左のとおりです。

  最初は、読み込みです。

  あとは、等号で見出しを書くだけです。

  等号が一つなら、見出しスライドです。

  等号が二つなら、本文スライドです。

  セリフ、つまり発表用の原稿も、同じファイルに書けます。

  右が、この数行を変換した結果です。

  見出しスライドと、本文スライドが、できています。

  実は、この資料も、この方法で作っています。

  出力するPDFは、二種類あります。

  発表用と、セリフ付きです。

  二つのファイルを、別々に書く必要はありません。

  (※ここで実体験を話す: Touyingでスライドを作ってみた感想について)

  ここまでが、スライドの作り方です。
]
#src("https://typst.app/universe/package/touying/", "https://github.com/touying-typ/touying")

// ================= 3. 日本語の扱い =================
= 日本語の扱い
#speaker-note[
  次は、日本語がきちんと使えるのかを、設定と実際の測定結果で見ていきます。
]

== 日本語の設定
#set text(size: 21pt)
#table(
  columns: (auto, 1fr),
  align: left + horizon,
  stroke: (x, y) => (bottom: 0.5pt + luma(205)),
  inset: (x: 10pt, y: 14pt),
  [`lang: "ja"`], [句読点・括弧の幅調整が、JIS X 4051 の方式になる],
  [`font`], [日本語フォントを指定。省略すると環境のフォントで代用],
  [`cjk-latin-spacing`], [和欧文の間隔。autoは「#box[#set text(cjk-latin-spacing: auto); Typstとは]」、noneは「#box[#set text(cjk-latin-spacing: none); Typstとは]」],
)
#v(10pt)
#set text(size: 22pt)
#set list(spacing: 1.1em)
- 改行位置は、Unicodeの改行規則(UAX \#14)に従う
- 実測: 106通りの幅・約4900行で、行頭の句読点・閉じ括弧は0件
- ソース内の改行は半角スペースになる(実測)ため、段落は1行で書く
#speaker-note[
  まず、設定は三つあります。

  一つ目は、言語です。

  日本語にすると、句読点や括弧の幅が調整されます。

  調整は、日本の組版の規格に沿った方式です。

  二つ目は、フォントです。

  日本語のフォントを、指定します。

  指定しないと、パソコンにあるフォントが選ばれます。

  さて、日本語と英数字の間の隙間です。

  さっきの例で、少し空いていた部分です。

  三つ目の設定で、入れるか詰めるかを選べます。

  改行の位置は、ユニコードの規則に従います。

  句読点が行頭に来ないように、組まれます。

  検証環境で、幅を変えながら、大量に組んで測った結果です。

  行頭に句読点や閉じ括弧が来た行は、ゼロでした。

  注意点も、一つあります。

  ソースの途中で改行すると、半角スペースが入ります。

  なので、段落は、一行で書きます。

  日本語は、設定すれば、組めます。
]
#src("https://typst.app/docs/reference/text/text/", "https://github.com/typst/typst/tree/v0.15.1/crates/typst-layout/src/inline")

// ================= 4. Marpとの違い =================
= Marpとの違い
#speaker-note[
  最後は、同じようにスライドが作れるマープと、違いを事実の範囲で比べます。
]

== 比較
#set text(size: 21pt)
#table(
  columns: (auto, 1fr, 1fr),
  align: left + horizon,
  stroke: (x, y) => (bottom: 0.5pt + luma(205)),
  inset: (x: 10pt, y: 9pt),
  fill: (x, y) => if y == 0 { primary } else { none },
  table.header(
    text(fill: white, weight: "bold")[項目],
    text(fill: white, weight: "bold")[Typst + Touying],
    text(fill: white, weight: "bold")[Marp],
  ),
  [*書き方*], [マークアップとスクリプト], [Markdown],
  [*出力*], [PDF・PNG・SVG\ HTMLは実験段階\ PPTXは外部ツール], [HTML・PDF・PPTX・画像],
  [*数式*], [標準機能], [Marp Coreが対応\ (MathJax・KaTeX)],
  [*セリフ*], [`#speaker-note`], [HTMLコメント],
  [*実行環境*], [Typst本体\ (単体の実行ファイル)], [Node.jsか単体の実行ファイル\ PDF等はブラウザが必要],
)
#speaker-note[
  では、画面の表を見ながら、比べます。

  どちらも、スライドが作れる道具です。

  ただ、書き方と、出力の形式が違います。

  まず、マープです。

  書き方は、マークダウンです。

  出力は、HTMLとPDFと、パワーポイント形式などです。

  ただ、PDFへの変換には、ブラウザが必要です。

  セリフは、HTMLコメントで書きます。

  次は、タイプストです。

  こちらは、独自のマークアップで書きます。

  出力は、PDFが基本で、画像も出せます。

  HTMLの出力は、今は実験段階です。

  パワーポイント形式は、外部のツールで出します。

  セリフは、専用の関数で書きます。

  実行環境も、少し違います。

  マープは、ノードか、単体の実行ファイルで動きます。

  こちらも、本体は単体の実行ファイルです。

  数式は、どちらも対応しています。

  どちらが上、という話ではありません。

  用途に合わせて、選ぶことになります。
]
#src(
  "https://typst.app/docs/reference/html/",
  "https://typst.app/docs/guides/for-latex-users/",
  "https://github.com/marp-team/marp-cli",
  "https://github.com/marp-team/marp-core",
  "https://marpit.marp.app/usage?id=presenter-notes",
  "https://github.com/touying-typ/touying",
)

// ================= 5. まとめ =================
= まとめ <touying:hidden>
#set text(size: 24pt)
#set list(spacing: 1.2em)
#show raw.where(block: false): set text(size: 1.12em)
- Typstは、マークアップとスクリプトで書く組版システム
- Touyingで、見出しからスライドを作り、セリフ付きPDFも出せる
- 日本語は、`lang`と`font`の指定で組める
- Marpとは、書き方と出力形式が異なる
- PPTXやHTMLを標準機能で出したいかが、選ぶ目安になる
#v(4pt)
#ph[自分ならどちらを使うか(使い分けの考え)]
#speaker-note[
  では、まとめます。

  まず、タイプストは、記号とコードで書く組版システムです。

  次に、トウインを使うと、見出しからスライドが作れます。

  セリフ付きのPDFも、同じソースから出せます。

  この資料も、その方法で作っています。

  日本語は、言語とフォントを指定すれば組めます。

  行頭の句読点も、測った範囲では、ゼロでした。

  最後に、マープとは、書き方と出力の形式が違います。

  どちらも、スライドは作れます。

  選ぶ目安は、パワーポイント形式を、標準機能で出したいかどうかです。

  つまり、どちらかが正解、ということはありません。

  最新の情報は、公式サイトで確認してください。

  自分のLTスライドを作る仕組みでは、タイプストを選択肢の一つにしています。

  (※ここで実体験を話す: 自分ならどちらを使うか、使い分けの考えについて)

  試すだけなら、公式のドキュメントが入口です。

  以上です。
]
