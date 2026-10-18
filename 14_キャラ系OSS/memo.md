# memo: キャラ系OSS

## 前提(想定時間・枚数・ツール・作成日)

- 想定時間: 10分(5分版なし)
- 枚数: 10枚(タイトル1 / 見出し3 / 本文5 / まとめ1)
- ツール: Marp(marp-cli 4.5.1。PNG確認は lt-marp-png 経由)
- 作成日・出典確認日: 2026-10-09
- ファイル: キャラ系OSS.md(スライドとセリフ)、memo.md、preview/(PNG確認用。統括が確認後に削除)、画像/・mermaid/(空。キャラクターの画像・イラストは載せていない・描いていない)
- セリフ合計: 2306字(空白除く)。300字/分なら約7.7分。ゆっくり話す・間を取る・差し込み2か所を足して10分に収める想定
- セリフの自動チェック(自作スクリプト): 1文40字以内、読点2つ以内、1行1コメント、各スライド最終行が「です/ます」、本文行末の「。」なし、`##`以上の見出しなし。指摘ゼロ
- 目視確認: 全10枚のPNGを確認(日本語フォントは Noto Sans CJK JP。はみ出しなし)。8行の目安を超えるのは9枚目のみ(コード7行を含むため)。見た目は問題なし
- シードの注意点への対応: (1)公式のキャラクター記述(3枚目)、(2)運営とライセンス(5〜6枚目)、(3)実用面(8〜9枚目)を中心にした。外見の描写はしていない。「流行・増えている」などの傾向は書いていない

## 構成メモ(スライド番号 / 種別 / 要旨)

| # | 種別 | 要旨 | セリフ字数 |
|---|---|---|---|
| 1 | タイトル | 「キャラ系OSS」。見る点は3つ(公式の説明 / 使ってよい条件と運営での扱い / 実際の役割) | 187 |
| 2 | 見出しA | 公式はマスコットをどう説明しているか | 34 |
| 3 | 本文A | 表。ElysiaJS=考え方(技術はかわいく楽しくあるべき、という構想の一部)、Misskey=定義(看板娘・公式キャラクター)、Anubis=依頼(外さないでほしい。強制ではない)。結論は「語り方は3通り」 | 351 |
| 4 | 見出しB | ライセンスと運営での扱い | 31 |
| 5 | 本文B | 表。コードのライセンス(MIT / AGPL-3.0 / MIT)、マスコット画像の条件(確認できず / 確認できず / コードと同じMIT)、差し替えの有償提供(確認できず / 確認できず / 商用版で提供) | 320 |
| 6 | 本文B続き | Anubisの白ラベル契約、商用版BotStopper、申込方法、2025年8月ブログの還元計画。達成状況は未確認 | 334 |
| 7 | 見出しC | 実際には何をするソフトか | 34 |
| 8 | 本文C | 役割の表(Anubis=ボット対策 / ElysiaJS=フレームワーク / Misskey=分散型SNS)と、キャラ系だけのフルスタックは難しいという発表者の調査結果。【差し込み1】 | 350 |
| 9 | 本文C続き | Anubis v1.28.1 の実行結果(コマンドと出力)。既定の方針で、名乗りにMozillaを含むと計算の課題が出る。【差し込み2】 | 351 |
| 10 | まとめ | 5項目(語り方3通り / コードと画像の条件は別 / 有償差し替えの明記は調べた範囲でAnubisのみ / 役割 / フルスタックは難しい) | 314 |

## 出典一覧(URL | 確認日 | 何の裏付けか)

確認方法の注記: 公式ドキュメント系は、公式リポジトリ(GitHub)のソースを取得して文面を確認した。Anubisの公式ドキュメントサイト(anubis.techaro.lol)はWebFetchで Access Denied となったため、同内容のGitHub上のドキュメント(タグ v1.28.1 と同じ最新コミット)を出典にした。

スライドに載せた出典:

| URL | 確認日 | 何の裏付けか(スライド) |
|---|---|---|
| https://elysiajs.com/illust | 2026-10-09 | マスコットはElysia chan。「技術はかわいく楽しくあるべき」「Elysia chanはその構想の一部であり続ける」。月刊の4コマ(エリシアちゃんの日常)とコミュニティ作のイラストを掲載(3)。文面は公式ドキュメントのソース(github.com/elysiajs/documentation の docs/illust.md と docs/components/4koma/layout.vue)で確認 |
| https://misskey-hub.net/ja/docs/for-users/resources/glossary/ | 2026-10-09 | 藍(読み: あい)はMisskeyの看板娘(公式キャラクター)。詳細は専用サイトへ案内(3)。ソースは misskey-hub-next の content/ja/docs/2.for-users/4.resources/glossary.md |
| https://github.com/TecharoHQ/anubis/blob/main/docs/docs/funding.md | 2026-10-09 | 無料提供の見返りにキャラクターを外さないでほしいという依頼。強制ではない(not demand)。ブランドなし・白ラベル版は作者に連絡して契約(3、6) |
| https://github.com/elysiajs/elysia | 2026-10-09 | ElysiaJSのコードのライセンスはMIT(LICENSE と package.json。バージョン 1.4.30)(5) |
| https://github.com/misskey-dev/misskey/blob/develop/LICENSE | 2026-10-09 | Misskeyのコードのライセンスは GNU AGPL v3(5)。バージョン 2026.10.0(package.json) |
| https://misskey-hub.net/en/brand-assets/ | 2026-10-09 | ロゴ・アイコン・バナー・アバターデコレーション用テンプレートがCC BY-SA。一覧にマスコットは含まれない(5)。ソースは misskey-hub-next の pages/brand-assets.vue と locales/en-US.yml |
| https://github.com/TecharoHQ/anubis/blob/main/web/static/img/ATTRIBUTIONS.txt | 2026-10-09 | マスコット画像はCELPHASE作。リポジトリと同じMITの条件で提供(5) |
| https://github.com/TecharoHQ/anubis/blob/main/docs/docs/admin/botstopper.mdx | 2026-10-09 | 商用版BotStopper。状態ごとの画像・CSS・フォント・題名の差し替え。申込はGitHub Sponsorsの月50ドル以上のプラン、または営業窓口へのメール(5、6) |
| https://github.com/TecharoHQ/anubis/blob/main/docs/blog/2025-08-18-funding-update/index.mdx | 2026-10-09 | 継続収入の段階計画。月1万〜1.5万ドルの段階で商用版限定の機能がOSS版へ流れ始める。商用版の契約も継続収入に数える(6) |
| https://github.com/TecharoHQ/anubis (README.md) | 2026-10-09 | Anubisはスクレイパーボットから上流を守るソフト。AI企業からの大量リクエスト対策。「a bit of a nuclear response」。多くの場合はCloudflareで足りる(8、9) |
| https://elysiajs.com/at-glance | 2026-10-09 | Bun向けに最適化されたTypeScriptのバックエンド用フレームワーク(8)。ソースは docs/at-glance.md |
| https://misskey-hub.net/ja/docs/about-misskey/ | 2026-10-09 | オープンソースの分散型マイクロブログ。2018年にActivityPubを実装(8)。ソースは content/ja/docs/1.about-misskey.md |
| https://github.com/TecharoHQ/anubis/releases/tag/v1.28.1 | 2026-10-09 | バージョン v1.28.1。リリースページ自体はcurlで403だったため、タグ(git clone / git ls-remote。コミット日時 2026-10-08 22:33 -0400)とリリースのtar.gz(linux-amd64)の取得で確認(9) |
| https://github.com/TecharoHQ/anubis/blob/main/data/botPolicies.yaml | 2026-10-09 | 既定の方針。generic-browser(Mozilla\|Opera)で重み+10。重みの閾値で課題の方式と難しさが決まる。difficulty 2 の注釈は「very fast for most clients」(9) |
| https://github.com/TecharoHQ/anubis/blob/main/docs/docs/design/how-anubis-works.mdx | 2026-10-09 | 課題に合格するとcookie(JWT)が発行され、先へ進む(9)。一部が古い(既定5桁、Mozillaを含むかの判定のみ)ため、数値は実測と方針ファイルを優先 |

補助的に確認した出典(スライド未掲載):

| URL | 確認日 | 何の裏付けか |
|---|---|---|
| https://elysiajs.com/quick-start | 2026-10-09 | 「multiple runtime support but optimized for Bun」。Node.jsなど他の実行環境でも使える(質問対応) |
| https://github.com/TecharoHQ/anubis/blob/main/LICENSE | 2026-10-09 | MIT。Copyright (c) 2025 Xe Iaso |
| https://github.com/TecharoHQ/anubis/blob/main/docs/docs/CHANGELOG.md | 2026-10-09 | v1.16.0でプレースホルダのマスコットをCELPHASE作の絵に置換。v1.18.0でマスコット画像のライセンスを明確化(#442) |
| https://registry.npmjs.org/elysia | 2026-10-09 | dist-tags: latest 1.4.30 / next 2.0.0-beta.27 / experimental 2.0.0-exp.64 |
| https://elysiajs.com/blog/elysia-14 | 2026-10-09 | 1.4のリリースノートで、マスコットを表紙に初めて使い、今後のリリースノートでも続ける旨(補助。ソースの docs/blog/elysia-14.md) |
| https://elysiajs.com/blog/elysia-20 | 2026-10-09 | Elysia 2 beta のリリースノートの表紙画像にもマスコットが載っている(画像のalt textの記述。補助。ソースの docs/blog/elysia-20.md) |
| https://misskey-hub.net/en/docs/for-users/resources/glossary/ | 2026-10-09 | 英語版でも「Ai is Misskey's official mascot」。藍専用サイト(https://xn--931a.moe/)へのリンクあり。藍.moe側には利用条件の記載を見つけられなかった |

## ⚠️ 出典なし・未確認の情報

- **「ストレージ・DB・監視・CI/CDの層に、キャラ系OSSが見つからなかった」「キャラ系だけのフルスタックは難しい」**(8、10枚目): シードにある発表者の過去の調査結果。第三者の出典なし。この環境で再調査はしていない。スライドには「発表者の調査」「出典なし」と明記
- **「記載を確認できず」(ElysiaJS / Misskeyのマスコット画像の条件、有償差し替え)**(5枚目): 調べた範囲の否定的な結果。範囲は、ElysiaJSのリポジトリと公式ドキュメントのソース、Misskey Hubのソース、ブランド素材ページ、藍.moeの案内。存在しないことの証明ではない
- **Hono と Lucia**: シードの指示(載せない、または「確認できず」)のうち、調べずに載せない方を選んだ。スライドに登場しない
- **シードの「月5,000ドルの支援目標を達成したらOSSに還元」は一次情報と異なる**: 2025-08-18のブログでは、月5,000ドルは作者が本業の時間を減らし始める目安。商用版限定機能がOSS版へ流れ始めるのは月1万〜1.5万ドルの段階(いずれも「rough plan」)。6枚目は後者に直した
- **シードの「ElysiaJSのフレンドリーなコミュニティ方針とマスコットが結びつく」は未確認**: 確認できたのは、illustページの「技術はかわいく楽しくあるべき」「Elysia chanはその構想の一部」と、公式サイトの「ボランティアとコミュニティ主導」という記述(マスコットとの結びつきは書かれていない)。スライドには確認できた記述だけを使った
- **シードの「Anubisは猫耳の少女」は公式のalt textと異なる**: READMEのalt textは「chibi dark-skinned anthro jackal」。外見は一切描写していない(シードの指示どおり)
- **シードの「有償のフォーク」は確認できず**: 公式の記述は、BotStopper(OSSの中核を土台にした商用版)と、白ラベルの契約。スライドはこの2つだけを載せた
- **還元計画の達成状況**: 2025年8月時点の計画のみ。現在の達成状況は確認できていない(セリフでも「確認できていません」と述べている)
- **GitHub Discussion #278 / Issue #442**: WebFetchの要約のみで、原文の引用ができなかった。スライドでは使っていない
- **how-anubis-works.mdx は一部が古い**: 既定の難しさ「5桁」と「Mozillaを含むかの判定のみ」という記述は、v1.28.1 の既定方針(閾値と重み)と合わない。実測(difficulty 2)と方針ファイルを優先した
- **ブラウザで課題を解いて通過する流れ**: 未実行。9枚目のセリフ「課題を解いたブラウザは先へ進める、と説明されています」は公式ドキュメントの記載のみ
- **読み方**: ミスキー・エリシア・アヌビス・バン・クラウドフレアの公式の読みは確認できなかった(読み方メモ参照)
- **発表者へ確認したい点**: (1)過去の「キャラ系OSS探訪」との重複(2)Anubis / ElysiaJSを実際に触った経験の有無(差し込み欄)(3)9枚目の出力は統括の作成環境で取ったもので、発表者本人の実行ではない点(4)Misskeyを入れてよいか(5)月5,000ドルの件を修正した点

## 差し込み欄(スライド番号 | 何を入れるか)

| スライド | 何を入れるか | 備考 |
|---|---|---|
| 8 | ElysiaJSを触った経験や、選ぶ理由 | シードに「触った」記載がないため空欄。セリフは `(※ここで実体験を話す: ElysiaJSを触った経験や、選ぶ理由について)` |
| 9 | Anubisを実際に触った感想や、見かけた場面 | 同上。セリフは `(※ここで実体験を話す: Anubisを実際に触った感想や、見かけた場面について)` |

- 合計2か所(シードの上限2、ブリーフの上限3以内)
- 差し込み欄を空にしても、前後の事実部分だけで話が通る
- 使ってよい経験として扱ったのは、シードにある「キャラ系OSSに関心がある」「キャラ系だけのフルスタックを調べ、難しいという結論になった」の2点のみ

## 動作確認(実行したもの / 未実行とその理由 / バージョン / 環境)

実行したもの:

- Anubis v1.28.1(linux-amd64のリリースtar.gz、24,981,187バイト、sha256 adcb3c2fdfd0fb91cbf7e8376dbcc479f654c85dd3795db3e9a06004786bbdc9)を専用の空ディレクトリに展開。`anubis --version` は `Anubis v1.28.1`
- 起動は `anubis -use-remote-address`(方針ファイルの指定なし。ログに `"fname":""` が出るので内蔵の既定方針)。待受 :8923、転送先 http://localhost:3923。9枚目のコードブロックに載せた
  - `-use-remote-address` なしだと、この環境ではHTTP 500(ログは `[misconfiguration] X-Real-IP header is not set`)。直接curlする検証ではこのフラグが要る。リバースプロキシ配下ではX-Real-IPを渡す前提
- 転送先は `python3 -I -m http.server 3923`(127.0.0.1)で、`<!doctype html><title>backend</title><p>Hello from backend</p>` を返すだけの簡易サーバー
- 結果(9枚目の出力と一致)
  - `curl -s localhost:8923` はバックエンドのページ(HTTP 200)
  - `curl -s -A Mozilla/5.0 localhost:8923` は確認ページ(HTTP 200、title は「Making sure you're not a bot!」)。バックエンドへのリクエストは増えなかった(backend.log で確認)
  - 確認ページ内のJSONは `"rules":{"algorithm":"fast","difficulty":2}`。Anubisのログは `new challenge issued` と `"weight":10`(generic-browserの+10と一致)
  - 確認ページのフッターに「Mascot design by CELPHASE」。ページが参照するキャラクター画像は取得していない
  - 起動ログの警告(スライドでは省略): GeoIP/ASNデータベース未設定、署名鍵がランダム生成、REDIRECT_DOMAINS未設定
- ElysiaJS 1.4.30: `bun add elysia` で導入し、`new Elysia().get('/', 'Hello Elysia').listen(3000)` を実行。`curl -s localhost:3000` は `Hello Elysia`(HTTP 200、content-type は text/plain;charset=utf-8)。スライドには未掲載
- スライドのPNG化と目視確認(lt-marp-png)。セリフの自作チェック(`python3 -I`)

未実行(理由):

- ブラウザでAnubisの課題を解いて通過する流れ: 未実行(公式ドキュメントの記載のみ)。ブラウザ操作の環境がなく、本テーマの主題でもないため
- BotStopper(商用版): 未実行(有償・非公開イメージのため)。公式ドキュメントの記載のみ
- Misskeyの導入・起動: 未実行(公式ドキュメントの記載のみ)。本テーマは公式の説明と運営の扱いが主で、導入手順は扱わないため
- GitHub API(`gh api`): 403(この環境で未許可)。回避せず、git clone と raw.githubusercontent.com で取得した

バージョン / 環境:

- Anubis v1.28.1、elysia 1.4.30、Bun 1.4.2、Python 3.13.16、curl 8.5.0、marp-cli 4.5.1
- Linux x86_64(カーネル 6.18.44)。作業ファイルは SCR/work/14_キャラ系OSS/(ダウンロードは専用ディレクトリ、スクリプトは別ディレクトリ)
- 画面の出力に載せた値は、ループバック(localhost)のみ。実在のIP・認証情報はなし

## 読み方メモ(語 | 採用する読み | 根拠)

| 語 | 採用する読み | 根拠 |
|---|---|---|
| 藍 | あい | 公式用語集に「(読み: あい)」と記載 |
| Elysia chan | エリシアちゃん | illustページの日本語見出し「エリシアちゃんの日常」。ElysiaJS自体の読みの明記は確認できず |
| ElysiaJS | エリシア(「ジェイエス」は省略) | 公式記載なし。マスコット名の表記からの慣用。セリフ内は「エリシア」に統一 |
| Misskey | ミスキー | 公式記載なし。慣用 |
| Anubis | アヌビス | 公式記載なし。エジプト神話の神の名の慣用表記 |
| Bun | バン | 公式の読みは確認できず。慣用 |
| Cloudflare | クラウドフレア | 公式の読みは確認できず。慣用 |
| 四コマ(4koma) | よんコマ | illustページのコード内に「4koma (yonkoma)」とある |
| OSS | オーエスエス | 慣用 |
| SNS | エスエヌエス | 慣用 |
| 看板娘 | かんばんむすめ | 一般的な読み |
| 名乗り(User-Agent) | なのり | 「ブラウザが送る名前」と言い換えて使う |
| BotStopper | 読み上げない(「商用版」と言う) | 公式の読みの記載なし |

読み上げない語: Techaro、CELPHASE、BotStopper、GitHub Sponsors、ActivityPub、AGPL、MIT、CC BY-SA(スライドのみ)

## 言い換え表(言いにくい語 | 言い換え候補)

| 言いにくい語 | 言い換え候補 |
|---|---|
| ElysiaJS | エリシア / Bun向けのフレームワーク |
| Elysia chan | エリシアちゃん / ElysiaJSのマスコット |
| Misskey | ミスキー / 分散型SNSのソフト |
| Anubis | アヌビス / ボット対策のソフト |
| BotStopper | 商用版 / ブランドなしの有償版 |
| ライセンス | 使ってよい条件 / 利用条件 |
| 白ラベル | ブランドなしの版 / ロゴやキャラを外した版 |
| ボット | 自動で動くプログラム / 機械的なアクセス |
| フレームワーク | プログラムを書く土台 |
| フルスタック | 全部の層をそろえた構成 |
| 名乗り(User-Agent) | ブラウザが送る名前 |
| 継続収入 | 毎月続く収入 |
| 既定の方針(ポリシー) | 初期設定の判定ルール |
| 課題(チャレンジ) | 計算の問題 / 確認のための計算 |
| クライアント | 接続してくる側 / 利用者の端末 |
| 最適化 | 向けに作る / 合わせて作る |
| クラウドフレア | 大手のCDNサービス |
| 分散型 | サーバー同士がつながる方式 |

## 質問されそうな点(3〜5個、答えと出典つき)

1. **マスコットの画像は自由に使えるのか**
   - 調べた範囲では、ElysiaJSとMisskeyのマスコット画像の利用条件の記載は確認できなかった。Misskeyのブランド素材(ロゴ・アイコン等)はCC BY-SAだが、その一覧にマスコットは含まれない。Anubisは画像もリポジトリと同じMITで、作者名も明記されている
   - 出典: https://github.com/TecharoHQ/anubis/blob/main/web/static/img/ATTRIBUTIONS.txt、https://misskey-hub.net/en/brand-assets/
   - 実際に使う場合は、各公式に確認するのが確実。この資料は条件の有無を並べただけで、法的な判断はしていない
2. **Anubisのキャラクターを外してよいのか**
   - 公式は「外さないでほしい」と依頼しているが、強制ではないと明記している。ブランドなしで使いたい組織向けに、白ラベルの契約(作者への連絡)と、商用版BotStopper(月50ドル以上のGitHub Sponsorsまたは営業窓口)を案内している
   - 出典: https://github.com/TecharoHQ/anubis/blob/main/docs/docs/funding.md、https://github.com/TecharoHQ/anubis/blob/main/docs/docs/admin/botstopper.mdx
3. **「月5,000ドルでOSSに還元」と聞いたが**
   - 2025-08-18のブログでは、月5,000ドルは作者が本業の時間を減らし始める目安。商用版限定機能がOSS版へ流れ始めるのは、月1万〜1.5万ドルの段階(rough planと明記)。現在の達成状況は確認できていない
   - 出典: https://github.com/TecharoHQ/anubis/blob/main/docs/blog/2025-08-18-funding-update/index.mdx
4. **ElysiaJSはBun専用か**
   - 専用ではない。公式のquick-startは「multiple runtime support but optimized for Bun」と書き、Node.jsなどでの利用手順もある。8枚目のセリフの「バンに最適化」は、Bunのみ対応という意味ではない
   - 出典: https://elysiajs.com/quick-start、https://elysiajs.com/at-glance
5. **Anubisは本当にボットを止めるのか、なぜ計算をさせるのか**
   - READMEは「a bit of a nuclear response」と書き、「good bots」を妨げる可能性や、多くの場合はCloudflareで足りることにも触れている。計算の課題(proof-of-work)は、最新のブラウザでSHA-256を計算できるかを確かめる仕組みと説明されている。実測では、既定の方針でMozillaを名乗るクライアントに難しさ2の課題が出た(起動オプションの既定値4とは別で、既定方針の閾値が優先された)。ブラウザで解く部分は未実行
   - 出典: https://github.com/TecharoHQ/anubis (README.md)、https://github.com/TecharoHQ/anubis/blob/main/data/botPolicies.yaml、https://github.com/TecharoHQ/anubis/blob/main/docs/docs/design/how-anubis-works.mdx
