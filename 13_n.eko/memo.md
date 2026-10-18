# memo: n.eko

## 前提(想定時間・枚数・ツール・作成日)

- 想定時間: 10分(AkarengaLT 第50回)
- 枚数: 10枚(タイトル1、見出し2、本文6、まとめ1)
- ツール: Marp(marp-cli 4.5.1)。フロントマターで Noto Sans CJK JP を明示。図は Mermaid を lt-mmdc で PNG 化(画像/仕組み.png、元は mermaid/仕組み.mmd)
- 作成日・出典の確認日: 2026-10-09
- セリフ: 各スライドの HTML コメント(1行1コメント)。合計 2515字(空白除く。差し込みの指示行2行を含む)。1分300字なら約8分半で、息継ぎと言い直しの余裕を足して10分に収める想定
- 画像: 仕組みの図のみ。n.eko のロゴ・マスコット・公式画像は使っていない
- 版情報: 最新版 v3.1.6(2026年9月30日公開、2026年10月時点)。公式ドキュメントは v3

## 構成メモ(スライド番号 / 種別 / 要旨)

| 番号 | 種別 | 要旨 |
|---|---|---|
| 1 | タイトル | 「n.eko」。ブラウザをみんなで一緒に使うツールと紹介し、話は「n.ekoとは」「動かし方と注意点」の2つと予告 |
| 2 | 見出し | n.ekoとは |
| 3 | 本文 | 概要。セルフホスト型の仮想ブラウザ(Docker)、1つのブラウザを複数人で共有、操作権限の受け渡し、遅延は公式の記載で300ミリ秒未満、ライセンス、最新版、名前と読み(公式に読みの記載なし) |
| 4 | 本文(図) | 仕組み。ブラウザの実体はサーバー側のコンテナ。参加者には映像と音声が WebRTC で届き、操作はサーバーに送られる。Cookie などは転送されない(公式の記載) |
| 5 | 本文 | 使い道。公式の用途例(Watch Party、Interactive Presentation、Collaborative Tool、Support/Teaching、Embed Anything、Automated Browser、Throwaway Browser)。差し込み欄あり |
| 6 | 見出し | 動かし方と注意点 |
| 7 | 本文 | 公式 Quick start の4手順と推奨スペック。ローカルで試すときは追加の設定が要ると予告 |
| 8 | 本文(コード) | 公式 docker-compose.yaml の抜粋(HTTP ポート、WebRTC 用の UDP 範囲、EPR、NAT1TO1)。「書式の検証のみ。起動は未確認」と明記。差し込み欄あり |
| 9 | 本文 | 注意点。パスワード2種(既定値は公開)、noauth の警告、127.0.0.1 の扱い、つながらないときの確認順、公開しない構成(VPN、SSH) |
| 10 | まとめ | 5項目(概要、仕組み、用途、動かすのに要る設定、公開時の注意) |

構成上の判断

- シードの5部構成(n.ekoとは / 使い道 / 動かし方 / 注意 / まとめ)は、10枚に収めるため、使い道を「n.ekoとは」の後半、注意点を「動かし方と注意点」の後半にまとめた
- シードの用途「画面を共有して操作を渡す」は、公式の Non goals が画面共有(Screen sharing)を対象外としているため、公式の用途名に合わせて「Interactive Presentation: 操作権限を渡しながら進める」と書いた
- 公式の特徴のうち、RTMP 配信、Persistent Browser、Jump Host、知的財産の保護、関連プロジェクト(neko-rooms、neko-apps、neko-vpn)は、時間の都合で載せていない。質問が出たときの材料にとどめた
- 英語の用途名(Watch Party など)は画面にだけ出し、セリフでは読み上げない(「名前は、画面のとおりです」)
- 公式サイトにある暗号資産トークンの注意書きは、スライドにもセリフにも載せていない(質問対応のみ。下の「発表者に確認したい点」を参照)

## 出典一覧(URL | 確認日 | 何の裏付けか)

公式ドキュメントと GitHub は、2026-10-09 に WebFetch で公開ページを取得して確認した。文言の細部は、リポジトリ m1k1o/neko の shallow clone(master HEAD c75a2f6、コミット日 2026-10-07。v3.1.6 のタグ 65fba48 も取得)の webpage/docs/ と webpage/src/ のソースで照合した。

スライドの footer に載せたもの(14件)

| URL | 確認日 | 何の裏付けか |
|---|---|---|
| https://neko.m1k1o.net/ | 2026-10-09 | 公式トップ。セルフホスト型の仮想ブラウザ(Docker、WebRTC)、遅延は300ms未満(公式の記載)、参加者間の操作権限の共有、用途の例(Watch Party ほか)、Throwaway Browser(履歴・Cookie・キャッシュが残らない)、映像と音声だけが共有される |
| https://github.com/m1k1o/neko | 2026-10-09 | README(説明、複数ユーザーの同時アクセス、用途の一覧、Neko は日本語の猫という説明(Why neko?)、元の作者が友人とアニメを見たくて作った経緯、Cookie など機密データは転送されず映像のみ共有)。LICENSE(Apache License 2.0)。GitHub の表示も Apache-2.0 |
| https://github.com/m1k1o/neko/releases/tag/v3.1.6 | 2026-10-09 | 最新リリース v3.1.6(releases/latest で「Latest」を確認)。公開日の表示は「30 Sep」(年の表示なし)。年はタグのコミット日時 2026-09-30T14:30:00+02:00 で補った |
| https://webrtc.org/ | 2026-10-09 | WebRTC の説明(ブラウザにリアルタイム通信を与える仕組み。映像・音声・データをピア間で送れる)。セリフの言い換えの根拠 |
| https://playwright.dev/ | 2026-10-09 | Playwright はテスト・スクリプト・AI エージェント向けのブラウザ自動化(公式トップ)。用途の名前の出典 |
| https://pptr.dev/ | 2026-10-09 | Puppeteer は Chrome / Firefox を操作する JavaScript ライブラリ(公式トップ)。用途の名前の出典 |
| https://neko.m1k1o.net/docs/v3/quick-start | 2026-10-09 | Quick start の手順(公開IPのサーバー、Docker と Compose プラグイン、compose ファイルの取得と起動、サーバーのIPを開く)。推奨スペック表(1280x720@30、4コア・3gb が Good Performance)。スペックが必要な理由。既定パスワード neko。ローカルネットワーク用の注記 |
| https://docs.docker.com/compose/ | 2026-10-09 | Docker Compose の説明(複数コンテナのアプリを定義して動かすツール。YAML ファイルで設定)。セリフの言い換えの根拠 |
| https://github.com/m1k1o/neko/blob/master/docker-compose.yaml | 2026-10-09 | Quick start の wget で取得するファイル。スライド8の抜粋の元(1959 bytes) |
| https://neko.m1k1o.net/docs/v3/configuration/webrtc | 2026-10-09 | EPR と公開する UDP 範囲を同じにする(リマップしない)。WebRTC は HTTP を使わないため nginx などのリバースプロキシで転送できない。NAT 1-to-1 |
| https://neko.m1k1o.net/docs/v3/configuration/authentication | 2026-10-09 | Multi-User(既定のプロバイダー。user 用 neko、admin 用 admin が既定値)。No-Auth は誰でも管理者としてログインできるため本番では使わない(danger の記載) |
| https://neko.m1k1o.net/docs/v3/installation | 2026-10-09 | docker run と compose の例。NAT1TO1 の値の使い分け(同じ端末だけなら 127.0.0.1、プライベートネットワークはホストの IP、公開ネットワークは環境変数を削除)。パスワードの環境変数 |
| https://neko.m1k1o.net/docs/v3/troubleshooting | 2026-10-09 | つながらないときの確認順(クライアント、ポートの公開、UDP の到達性、外部 IP)。NAT1TO1 に 127.0.0.1 を使うと各クライアントが自分の localhost に接続するため失敗する |
| https://neko.m1k1o.net/docs/v3/customization/networking | 2026-10-09 | 公開しない構成の例(VPN 経由、SSH ポート転送) |

スライドには載せず、確認や質問対応に使ったもの

| URL | 確認日 | 何の裏付けか |
|---|---|---|
| https://neko.m1k1o.net/docs/v3/introduction | 2026-10-09 | 読み方の記載の有無を確認(記載なし) |
| https://neko.m1k1o.net/non-goals | 2026-10-09 | 画面共有は対象外(screego を案内)、複数ルームの管理は対象外(neko-rooms を案内)、公式サポートは Linux のみ、モバイルはベストエフォート |
| https://neko.m1k1o.net/docs/v3/configuration | 2026-10-09 | multiuser の既定値の照合 |
| https://gigazine.net/news/20260117-neko | 2026-10-09 | 日本語の紹介記事。読み方の記載の有無を確認(記載なし)。二次情報なのでスライドには使っていない |
| WebSearch「n.eko m1k1o neko 仮想ブラウザ 読み方 ネコ」 | 2026-10-09 | 読み方を示す一次情報は見つからなかった |
| リポジトリのソース(webpage/src/components/HomepageUseCases と HomepageFeatures、webpage/src/pages/index.tsx、webpage/docs/release-notes.md、LICENSE) | 2026-10-09 | トップの文言の照合、暗号資産トークンの注意書き(Scam Warning)、v3.1.6 の変更点、ライセンス全文 |

## ⚠️ 出典なし・未確認の情報

- 「公開前にパスワードの変更を決める」(スライド9、スライド10、各セリフ): 公式ドキュメントに、変更を促す明示の記載は確認できなかった。公式の記載は、既定パスワードが公開されていること、No-Auth の警告、Installation ページと compose ファイルにパスワードを設定する環境変数があること。スライド9には「(発表者の整理)」と表示し、セリフでも「私の整理です」と断っている。スライド10の最後の項目は同じ内容で、ラベルはない
- 読み方: 公式に記載なし(トップ、Introduction、README、GIGAZINE、WebSearch で確認)。README の「Why neko?」に、Neko は日本語の猫という説明があるのみ。セリフでは「公式に記載がありません」と断ったうえで「この発表では、ネコと呼びます」と宣言している
- 遅延300ミリ秒未満: 公式の主張で、実測していない。スライドは「公式の記載では」、セリフは「検証はしていません」と明記
- Cookie などが転送されない、Throwaway Browser で履歴・Cookie が残らない: 公式の記載のみ。動作は未確認
- リリース日(2026年9月30日): このセッションでは gh api が 403 だったため、API からは取れなかった。リリースページの「30 Sep 12:39」(年なし)と、git で取得したタグのコミット日時で判断した
- 公式ドキュメント内の表記の揺れ: Quick start の注記は `NEKO_NAT1TO1`、compose ファイル・Installation・Troubleshooting は `NEKO_WEBRTC_NAT1TO1`。スライドは後者を使った。また、compose のコメントは「クライアントが到達できる IP の指定は必須」、Installation は「公開ネットワークでは環境変数を削除」、WebRTC のページは「既定ではサーバーの公開 IP を自動検出」と書いており、説明が分かれている。スライド8は「自分の環境の値に置き換える」とだけ書き、どちらが正しいかは断定していない
- 「元の作者が友人とアニメを見たくて作った」(スライド5のセリフ): README の About の記載のみ。作者本人や第三者による裏付けは取っていない。セリフは「READMEによると」と出典を示している
- 仕組みの図(スライド4): 公式の説明(README、トップ)をもとにした概念図。実機の通信を観測したものではない
- 既定パスワード neko と admin: 公式ドキュメントに載っている既定値で、実在の認証情報ではない
- 公開ページとリポジトリの docs ソースが完全に同期しているかは確認していない(確認した範囲では文言は一致)

発表者に確認したい点

- 読みを「ネコ」で進めてよいか(スライド1から統一している)
- 公式サイトの暗号資産トークンの注意書きに口頭で触れるか(現状は触れていない。質問対応の材料は下に記載)
- 「公開前にパスワードの変更を決める」を発表者自身の整理として話してよいか
- 差し込み欄2か所(下記)を話すか、削るか
- 発表前にこの構成を実際に起動してみるか(起動した場合は、スライド8の注記と、セリフ「書式の検証までで、起動は未確認です。」を書き換える)

## 差し込み欄(スライド番号 | 何を入れるか)

| スライド | 何を入れるか |
|---|---|
| 5 | スライド: 【差し込み: 使ってみたい用途、または使った場面】。セリフ: (※ここで実体験を話す: 使ってみたい用途、または使った場面について)。n.eko を使った経験があるかはシードに記載がない。使っていなければ「使ってみたい用途」を話す。話さない場合は、スライドの行とセリフの行を削除してよい(前後の事実だけで話は通る) |
| 8 | スライド: 【差し込み: 実際に起動して見えた画面や感想】。セリフ: (※ここで実体験を話す: 実際に起動して見えた画面や感想について)。発表までに起動した場合だけ使う。起動しない場合は、スライドの行とセリフの行を削除する。スライドは「起動は未確認」と書いてあるので、削除しても矛盾しない |

## 動作確認(実行したもの / 未実行とその理由 / バージョン / 環境)

実行したもの(2026-10-09)

- `docker --version`: Docker version 29.8.2, build 7fc2dff
- `docker compose version`: Docker Compose version v5.5.1(buildx v0.37.1)
- `docker info`: クライアントは動作する。サーバーは「failed to connect to the docker API at unix:///var/run/docker.sock」で接続できず、daemon が動いていない。/usr/bin/dockerd は存在するが、/var/run/docker.sock はない
- `wget https://raw.githubusercontent.com/m1k1o/neko/master/docker-compose.yaml`(Quick start の手順どおり。作業用の空ディレクトリで実行): 1959 bytes を取得。リポジトリ HEAD の同ファイルと一致
- `docker compose config -q`: 取得した compose ファイルと、Installation ページの compose 例の2つで、終了コード0、エラー出力なし。daemon がなくてもできる書式の検証であり、動作の確認ではない。services は neko、image は ghcr.io/m1k1o/neko/firefox:latest、UDP 52000〜52100 の101ポート、shm_size は 2gb と解釈された
- スライドの確認: lt-marp-png で10枚を PNG 化して目視(はみ出し、日本語フォント、図の収まり)。図は lt-mmdc で PNG 化。自作のチェックスクリプトで、セリフ字数、文の長さ、読点の数、行末の「。」、見出しのクリアなどを確認(エラー0)

未実行(公式ドキュメントの記載のみ)

- `docker compose up -d`、イメージの取得(ghcr.io/m1k1o/neko/firefox:latest)、ブラウザでの接続とログイン、WebRTC の接続: daemon が動いていないため。共有環境で、環境外のファイルを変更しない取り決めのため、daemon の手動起動もしていない
- Troubleshooting の確認コマンド(`nc -ul` と `nc -u`、`docker compose logs neko | grep nat_ips`): 未実行
- 遅延300ミリ秒未満、推奨スペックの性能、Cookie が転送されないこと: 公式の記載のみ。測定も検証もしていない

環境

- Linux 6.18.44-fc-v80 x86_64(サンドボックスの VM、root)
- Docker CLI 29.8.2、Docker Compose v5.5.1
- marp-cli 4.5.1(統括提供のラッパー経由)

## 読み方メモ(語 | 採用する読み | 根拠)

| 語 | 採用する読み | 根拠 |
|---|---|---|
| n.eko / Neko | ネコ(スライド1から統一) | 公式記載なし。慣用として「ネコ」。README の「Why neko?」に「Neko is the Japanese word for cat」とある |
| README | リードミー | 公式記載なし。慣用として |
| WebRTC | ウェブアールティーシー | 公式記載なし。慣用として |
| Docker / Compose | ドッカー / コンポーズ | 公式記載なし。慣用として |
| nginx | エンジンエックス | 公式記載なし。慣用として(読みの一次情報は未確認) |
| Firefox | ファイヤーフォックス | 公式記載なし。慣用として |
| Cookie | クッキー | 公式記載なし。慣用として |
| UDP / HTTP / IP / VPN / SSH | ユーディーピー / エイチティーティーピー / アイピー / ブイピーエヌ / エスエスエイチ | 公式記載なし。慣用として |
| Playwright / Puppeteer | セリフでは読まない(画面に名前だけ出す) | 読みは公式に記載なし。慣用ではプレイライト / パペッティア |
| NAT1TO1、EPR、noauth | セリフでは読まない(「接続先のIP」「UDPの範囲」「認証なしの設定」に言い換え) | 画面に名前だけ出す |

## 言い換え表(言いにくい語 | 言い換え候補)

| 言いにくい語 | 言い換え候補 |
|---|---|
| n.eko / Neko | 「ネコ」(この発表で統一) / 「この共有ブラウザ」 |
| セルフホスト | 「自分のサーバーで動かす」(セリフ内で定義済み) |
| 仮想ブラウザ | 「サーバー上で動くブラウザ」(セリフ内で定義済み) |
| WebRTC | 「映像と音声を送る仕組み」 / 「ブラウザで映像や音声をやり取りする仕組み」 |
| Docker Compose | 「コンテナの設定をファイルに書いて動かす仕組み」 / 「Composeの設定ファイル」 |
| リバースプロキシ | 「中継サーバー」 / 「nginxなどの中継役」 |
| NAT1TO1 | 「接続先のIP」 / 「クライアントが接続するIP」 |
| EPR(ephemeral port range) | 「UDPの範囲」 / 「映像と音声用のUDPポートの範囲」 |
| noauth | 「認証なしの設定」 |
| Cookie | 「ログイン情報などを覚えるデータ」 |
| Playwright / Puppeteer | 「ブラウザを自動で操作するツール」 |
| 用途の英語名(Interactive Presentation など) | 「画面のとおりです」と画面を指す / 「操作を渡す使い方」 |

## 質問されそうな点(3〜5個、答えと出典つき)

1. 公開したとき、誰でも入れてしまわないか
   - 答え: 既定の認証は Multi-User で、パスワードは user 用と admin 用の2つ。既定値(neko と admin)は公式ドキュメントに載っている。パスワードは環境変数で設定できる。No-Auth は誰でも管理者として入れるため、公式が本番では使わないよう警告している。OAuth や OIDC などのプロバイダーもある
   - 出典: https://neko.m1k1o.net/docs/v3/configuration/authentication 、https://neko.m1k1o.net/docs/v3/installation

2. なぜ UDP のポートが要るのか。443 だけではだめか
   - 答え: WebRTC は HTTP を使わないので、nginx などのリバースプロキシでは転送できない。443 しか開けていないなら、WebRTC のポートも開けるか、TURN サーバーを使う(公式の記載)。EPR と公開する UDP の範囲は同じにして、ポートをずらさない
   - 出典: https://neko.m1k1o.net/docs/v3/configuration/webrtc 、https://neko.m1k1o.net/docs/v3/troubleshooting

3. 画面が出ない、つながらないときは
   - 答え: 公式の順序は、まずクライアント(about:webrtc などで WebRTC が有効か、拡張機能がブロックしていないか)、次にネットワーク(UDP ポートの公開、UDP の到達性、外部 IP の判定)。NAT1TO1 に 127.0.0.1 を使うと、各クライアントが自分の localhost に接続しようとして失敗する。確認コマンドは未実行(公式ドキュメントの記載のみ)
   - 出典: https://neko.m1k1o.net/docs/v3/troubleshooting

4. 画面共有ツールとの違い、複数の部屋を持てるか
   - 答え: 公式の Non goals は、画面共有(Screen sharing)を対象外とし、screego を案内している。複数ルームを扱うサービス化も対象外で、neko-rooms を案内している。n.eko は、サーバー側のデスクトップやブラウザを WebRTC で複数人に配信する(README)。公式サポートは Linux のみ。モバイルはベストエフォート
   - 出典: https://neko.m1k1o.net/non-goals 、https://github.com/m1k1o/neko

5. 暗号資産のトークンと関係があるのか
   - 答え: 公式サイトに注意書きがある。Neko が暗号資産トークンを出すと称する偽のアカウントがあるが、公式プロジェクトとは無関係で、公式プロジェクトは X(Twitter)のアカウントを持たず、暗号資産トークンにも関わらない、という内容
   - 出典: https://neko.m1k1o.net/(上部の Scam Warning。リポジトリの webpage/src/pages/index.tsx でも文言を確認)
