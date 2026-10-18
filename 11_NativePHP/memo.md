# memo: NativePHP

## 前提(想定時間・枚数・ツール・作成日)

- 想定時間: 10分(AkarengaLT 第50回、福岡 Engineer Cafe、2026年10月後半の日曜。発表者 akutori)
- 枚数: 10枚(タイトル1 / 見出し3 / 本文5 / まとめ1)。「ご清聴」スライドなし
- ツール: Marp(コードスライドを使う)。Marp CLI 4.5.1(Marp Core 4.4.0)
- 作成日: スライド 2026-10-09。この memo.md は、独立点検(2026-10-10)で新規に作成した(担当者の作成物には memo.md がなかった)。出典の確認日は、特記がなければ 2026-10-10
- 対象バージョン(2026年10月時点): NativePHP Desktop 2.3.1(2026-09-14公開)、NativePHP Mobile 4.6.0(2026-10-02公開)、php-bin 1.2.0(2026-05-21公開)。最新の Laravel は 13.x(2026-03-17公開)
- セリフ: 合計 2364字(差し込みの行を除く。スライド別 195 / 40 / 346 / 38 / 348 / 345 / 330 / 40 / 348 / 334)
- 画像・Mermaid: `画像/boot-flow.png`(`mermaid/boot-flow.mmd` から作成した、起動の流れの図)だけ。キャラクター・ロゴ・既存作品の画像なし
- スタイル: ページローカルの `<!-- _style: ... -->` は使わない。Marp CLI 4.5.1 / Marp Core 4.4.0 では、この指定がCSSに反映されず、文字列がセリフ(ノート)の先頭行に混入することを、ブラウザなしで確認した。スライド6にあった指定は、点検時に削除した。コードは既定の文字サイズでスライドに収まる(プレビューPNGで確認)
- 実行環境(作業記録): Ubuntu 24.04.5 LTS(Linux x86_64)のサンドボックス。GUIは起動できない

## 構成メモ(スライド番号 / 種別 / 要旨)

| 番号 | 種別 | 要旨 |
| --- | --- | --- |
| 1 | タイトル | 「NativePHP」のみ。PHPとLaravelを仕事で使ってきたこと、流れが三つあること、内容は公式のドキュメントとリポジトリで確認したものに絞ること、版と料金は今の時点の情報であることを伝える |
| 2 | 見出し | NativePHPとは |
| 3 | 本文(箇条書き) | 公式の説明。PHPとLaravelでネイティブアプリを作るフレームワーク(2026年10月時点)。Desktop 版は Electron の外枠に静的PHPを同梱(最新タグ 2.3.1)、Mobile 版は Swift / Kotlin の外枠にPHPを埋め込む(最新タグ 4.6.0)。画面の作り方、ライセンス(本体はどちらも MIT)、有料の周辺サービス(Bifrost は月10ドルから) |
| 4 | 見出し | Hello Worldまでの手順 |
| 5 | 本文(箇条書き+コード) | 前提(PHP 8.3以上 / Laravel 11以上 / Node 22以上)、対応OS、公式の対応表(PHP 8.3・8.4 / Laravel 11.x・12.x。最新の Laravel は 13.x)、composer.json の illuminate/contracts は ^13 まで許容(動作は未確認)、公式の推奨(先にブラウザで確認)。公式ドキュメントの3コマンド |
| 6 | 本文(箇条書き+コード) | native:install の内容(公式)。実行結果は Linux x64 で確認した範囲のみ: Electron 40.10.2、同梱の静的PHP(ldd は「not a dynamic executable」、PHP 8.3.31、DB拡張は PDO と pdo_sqlite)。native:install 自体は未実行 |
| 7 | 本文(図+コード) | 起動の流れ(ソースの記述に基づく。実機は未確認): Electron 起動、同梱のPHPでLaravel起動、起動完了の通知、boot() の Window::open()。鍵つきの通信と、起動のたびに鍵を作り直す点は公式のセキュリティの章。【差し込み】開いたウィンドウの画面 |
| 8 | 見出し | Laravel開発者にとっての利点と注意 |
| 9 | 本文(箇条書き) | 利点2点(新しいフレームワークの学習が不要 / UIは自由)、注意4点(.env も配布物に含まれる / 標準対応の DB は SQLite のみ / コードの変更は再起動で反映 / ビルドは1つのOS向け・macOS と Windows は署名が必要)。【差し込み】触った範囲と感想 |
| 10 | まとめ | 5項目(位置づけ、ライセンス、中身、手順と対応表、配る前の確認点) |

## 出典一覧(URL | 確認日 | 何の裏付けか)

確認日は、特記がなければ 2026-10-10(独立点検でページを開いて確認)。英語の引用は1出典につき1か所・15語未満にとどめ、ほかは言い換え。

| URL | 確認日 | 裏付け |
| --- | --- | --- |
| https://nativephp.com/docs/desktop/2/getting-started/introduction | 2026-10-10 | スライド3・9・10: Desktop 版の説明(PHPでデスクトップアプリを作るフレームワーク)。静的PHPのランタイムを含み、利用者の端末側の準備が要らない。GUIフレームワークではなく、画面の技術は自由(React・Vue・Livewire・Inertia・素のHTMLとCSS)。新しいフレームワークを覚え直す必要がなく、Laravelの上に構築されている("not a completely new framework")。Credits に Electron が載る |
| https://nativephp.com/docs/mobile/getting-started/introduction | 2026-10-10 | スライド3: Mobile 版は iOS と Android 向け。ビルド済みのPHPランタイムを、コードと一緒に Swift / Kotlin の外枠へ同梱する。標準でネイティブUI(Webビューではない) |
| https://github.com/NativePHP/desktop | 2026-10-10 | スライド3・5・7・10: READMEの説明、LICENSE.md は MIT、composer.json は license が MIT、php ^8.3、illuminate/contracts ^10.0 から ^13.0 まで、nativephp/php-bin ^1.0。取得したタグ 2.3.1(コミット 2e517ff)。起動の流れ(スライド7)は、このリポジトリのソースの読み取り: resources/electron/electron-plugin/src/index.ts(`app.whenReady()`、`startPhpApp()`、`notifyLaravel('booted')` の順)、routes/api.php(`_native/api/booted`)、src/Http/Controllers/NativeAppBootedController.php(`boot()` を呼ぶ)、resources/stubs/NativeAppServiceProvider.php.stub(`Window::open();`)。確認日は、取得が 2026-10-09、内容の再確認が 2026-10-10 |
| https://github.com/NativePHP/desktop/releases/latest | 2026-10-10 | スライド3: 2.3.1 が Latest(9月14日公開) |
| https://packagist.org/packages/nativephp/desktop | 2026-10-10 | スライド3・5: 最新の安定版 2.3.1(2026-09-14)、ライセンス MIT、php ^8.3、illuminate/contracts ^10.0 から ^13.0 まで |
| https://github.com/NativePHP/mobile-air | 2026-10-10 | スライド3: Mobile 版のリポジトリ。Composer のパッケージ名は nativephp/mobile、LICENSE.md は MIT。取得したタグ 4.6.0。確認日は、取得が 2026-10-09、内容の再確認が 2026-10-10 |
| https://github.com/NativePHP/mobile-air/releases/latest | 2026-10-10 | スライド3: 4.6.0 が Latest(10月2日公開) |
| https://packagist.org/packages/nativephp/mobile | 2026-10-10 | スライド3: 最新の安定版 4.6.0(2026-10-02)、ライセンス MIT |
| https://github.com/NativePHP/php-bin | 2026-10-10 | スライド6・9: 説明は「NativePHPが使うPHPの実行ファイル」。static-php-cli で、他に依存しない静的リンクのPHPを作る。コンパイル済みの拡張の一覧は php-extensions.txt(pdo・pdo_sqlite・sqlite3 を含み、MySQL系なし。取得したタグ 1.2.0 のリポジトリで確認) |
| https://packagist.org/packages/nativephp/php-bin | 2026-10-10 | スライド6: 最新の安定版 1.2.0(2026-05-21)。desktop の composer.json は ^1.0 を要求するため、現時点では 1.2.0 が入る |
| https://www.electronjs.org/ | 2026-10-10 | スライド3・6・7: Electron は Chromium と Node.js を組み込む("Electron embeds Chromium and Node.js")。セリフ「ブラウザの部品を組み込める土台」の語釈 |
| https://bifrost.nativephp.com/ | 2026-10-10 | スライド3: Bifrost は、iOS / Android のアプリをクラウドでビルド・署名・配布するサービス。ホビー向けの Apprentice プランが月10ドル(1アプリ・50ビルド)、ほかに月29ドルなどのプランの記載。公式サイト(nativephp.com)のトップページのカードにも「Plans start from just $10/month」の記載(公式サイトのリポジトリで確認)。desktop リポジトリのREADME(スポンサー欄)に、Bifrost は Desktop と Mobile のアプリをビルドする旨の記載 |
| https://nativephp.com/docs/desktop/2/getting-started/installation | 2026-10-10 | スライド5・6: 要件(PHP 8.3以上、Laravel 11以上、Node 22以上、Windows 10以上 / macOS 12以上 / Linux)、3つのコマンド(composer require nativephp/desktop、php artisan native:install、php artisan native:run)。native:install の内容(サービスプロバイダの登録、設定ファイルの公開、composer.json への native:dev スクリプトの追加、composer update 後に実行する登録、Electron に必要な依存の導入)。公式の推奨: ネイティブで動かす前に、ブラウザで動かしてみる |
| https://nativephp.com/docs/desktop/2/getting-started/support-policy | 2026-10-10 | スライド5・10: 対応表は ^2.0 で PHP 8.3 と 8.4、Laravel 11.x と 12.x。Laravel 13.x の記載なし。サポートを求めるときは、サポート対象の版を使うよう求めている |
| https://laravel.com/docs/13.x/releases | 2026-10-10 | スライド5「最新の Laravel は 13.x」: Laravel 13 が最新のメジャー版(2026-03-17公開、PHP 8.3 から 8.5)。点検時に、フッターの旧URL(laravel.com/docs/installation)から差し替えた。旧URLは、WebFetch では古い版のページが返り、「最新は13.x」の裏付けにならなかった |
| https://nativephp.com/docs/desktop/2/the-basics/windows | 2026-10-10 | スライド7: ウィンドウは Window::open() で開く。通常は NativeAppServiceProvider の boot() から呼ぶ。幅や高さなどを指定できる。既定ではアプリのルートURLを開く |
| https://nativephp.com/docs/desktop/2/digging-deeper/security | 2026-10-10 | スライド7: PHP側とランタイム側の2つのWebサーバーが、事前共有の動的な鍵で、認証つきのHTTP呼び出しをする。鍵は、アプリが起動するたびに作り直される。ビルド時は PreventRegularBrowserAccess のミドルウェアが全ルートに付く。ソースでは、起動時に生成した乱数を `X-NativePHP-Secret` ヘッダで送る(index.ts と server/state.ts) |
| https://nativephp.com/docs/desktop/2/getting-started/env-files | 2026-10-10 | スライド9: .env もバンドルに含まれ、バンドルを手に入れた人が読める。API キーやパスワードを入れない。cleanup_env_keys でバンドル時に取り除くキーを指定できる |
| https://nativephp.com/docs/desktop/2/digging-deeper/databases | 2026-10-10 | スライド9: 標準で対応するのは SQLite のみ("only supports SQLite out of the box") |
| https://nativephp.com/docs/desktop/2/getting-started/development | 2026-10-10 | スライド9: コードの変更は、再起動するまで実行中のアプリに反映されない。ホットリロードは一部のファイルだけ(Vite の設定による) |
| https://nativephp.com/docs/desktop/2/publishing/building | 2026-10-10 | スライド9: ビルドは1回につき1つのプラットフォーム。`native:build` は実行中の環境向けで、os 引数で mac・win・linux を指定できる(クロスコンパイルは全環境では未対応)。macOS と Windows は、配る前にコード署名が必要。「署名が必要」の文は、WebFetch の要約では拾えなかったため、公式サイトのリポジトリ(下の行)のdocsのソースで確認した |
| https://github.com/NativePHP/nativephp.com | 2026-10-09 | 公式サイトのdocsのソース(コミット 8410f55、2026-10-07)。上の docs ページの本文を、ソースで照合した: building(署名の必要性)、support-policy(サポート対象の版を使う旨)、installation、security。ホームのカードの価格表記 |

## ⚠️ 出典なし・未確認の情報

- 最新の Laravel 13.x での動作: 公式の対応表(support-policy)は Laravel 11.x と 12.x まで。desktop 2.3.1 の composer.json は illuminate/contracts を ^13 まで許容するが、動作は未確認。スライド5とセリフにも「未確認」と書いた。発表前に support-policy を再確認する
- `composer require nativephp/desktop`、`php artisan native:install`(コマンド全体)、`php artisan native:run` は未実行。スライドには「公式ドキュメントの例」と書いた(実行記録を確認できず)
- 起動の流れ(スライド7)は、desktop 2.3.1 のソースの読み取り。実機でウィンドウが開く様子は未確認。スライドとセリフに「実機は未確認」と書いた
- Mobile 版の導入と実行は未実行(公式の説明の確認のみ)
- macOS・Windows での実行、`native:build` によるビルドと署名は未実行(実行環境は Linux x64 のみ)
- 読み方(発音): NativePHP・Laravel・SQLite などは、公式に読み方の記載を確認できなかった(下の読み方メモ)
- Bifrost の料金は変わりうる。2026-10-10 に、ホビー向けの月10ドルのプランの記載を確認した。発表前に再確認する。ページの文言は iOS / Android 向けの説明で、Desktop への対応は desktop リポジトリのREADME(スポンサー欄)の記載のみ。スライドの「クラウドビルド」は、ビルド・署名・配布のサービスという説明の要約で、公式の用語そのものではない
- Mobile 版のほかの有料要素(プラグインなど)は確認していない。スライドは「有料の周辺サービスあり(例: Bifrost)」の範囲にとどめた
- 版の番号(Desktop 2.3.1、Mobile 4.6.0、php-bin 1.2.0)と、実行結果の Electron 40.10.2、PHP 8.3.31 は 2026年10月時点。発表日までに更新される可能性がある。発表前に Releases を再確認する
- 発表者の NativePHP の使用経験は不明のため、感想は差し込み欄にした(経験の創作なし)。スライド1のセリフ「PHPとLaravelを、仕事で使ってきました」は、シードの「PHP / Laravel の実務経験が約3年ある」の範囲(年数は言っていない)

## 差し込み欄(スライド番号 | 何を入れるか)

| スライド | スライド上の表記 | セリフ上の表記 | 何を入れるか |
| --- | --- | --- | --- |
| 7 | 【差し込み: 開いたウィンドウの画面】 | (※ここで実体験を話す: 実際にウィンドウが開いたときの様子について) | 実機で起動した場合の画面と様子。実機で起動していなければ入れず、スライドの「実機は未確認」とセリフ末尾2行の「実機での起動は、未確認です」をそのまま使う。実機で起動した場合は、その2か所を実際に合わせて直す |
| 9 | 【差し込み: NativePHP を実際に触った範囲と、使ってみた感想】 | (※ここで実体験を話す: 実際に触った範囲と、使ってみた感想について) | 実際に触った範囲(触っていなければ「触っていない」)と、感想 |

2か所とも、差し込みがなくても、前後の事実の部分で話は通る。

## 動作確認(実行したもの / 未実行とその理由 / バージョン / 環境)

- 環境: Ubuntu 24.04.5 LTS(Linux x86_64)のサンドボックス。Node v22.22.0、npm 10.9.4、Composer 2.8.12。ホストの PHP は 8.3.6(NativePHP の同梱PHPとは別物で、スライドの出力には使っていない)
- 実行した(作業記録 SCR/work/11_NativePHP/ で確認。スライド6の出力は、点検時に再実行して一致を確認した):
  - desktop 2.3.1 の `resources/electron` を `npm install` し、`node -p "require('electron/package.json').version"` → `40.10.2`(package.json は `^40.10.2` 指定。作業用のコピーの package.json は、タグ 2.3.1 のリポジトリのものと一致)
  - php-bin 1.2.0 の `bin/linux/x64/php-8.3.zip`(SHA256 `aeec695114d1d7a88e2a9aafd1a6ecb2388a1b61bdb17ec2a3294fe480936c91`。タグ 1.2.0 と現在の先頭でzipは同一)を専用ディレクトリに展開した `php`(SHA256 `7b4bdd6c27bf76789f718dafcbfeea5cd538ad48ad1e67c12aa053b11ecdd1c2`)で、次のコマンドを実行:
    - `ldd ./php` → `not a dynamic executable`
    - `./php -v | head -1` → `PHP 8.3.31 (cli) (built: May 21 2026 01:45:33) (NTS x86_64-linux-musl-gcc)`
    - `./php -m | grep -i pdo` → `PDO` と `pdo_sqlite`
  - desktop の `src/Support/Composer.php` を無改変で読み込み、`installDevScript()` と `installUpdateScript()` を、Laravel のスケルトン(v13.11.0)の composer.json に対して実行(Laravel のヘルパー関数だけ最小限の代用品を定義)。composer.json に `native:dev` スクリプトと、`post-update-cmd` への `native:install --force --quiet` が追加された(作業記録の proj-composer-json の差分)。スライド6の「composer.json 更新」の裏付け(コマンド全体ではなく、その中の関数の部分実行)。スライドには出力を載せていない
- 実行記録を確認できず(未実行として扱う。未実行の理由は記録なし。ウィンドウの表示は、GUIを起動できない環境のため実行できない):
  - `composer require nativephp/desktop`(作業用ディレクトリに vendor がなく、Composer のキャッシュ composer-cache も空)
  - `php artisan native:install` のコマンド全体
  - `php artisan native:run` と、ウィンドウの表示
  - `php artisan native:build`(ビルドと署名)
  - Mobile 版の導入と実行
  - macOS・Windows 上での動作
- 作業用のコピー(作業記録): SCR/work/11_NativePHP/repos/(desktop はタグ 2.3.1、mobile-air はタグ 4.6.0、php-bin、laravel-skeleton は v13.11.0、website は公式サイトのdocsのソース)。出力ディレクトリには置いていない

## 読み方メモ(語 | 採用する読み | 根拠)

| 語 | 採用する読み | 根拠 |
| --- | --- | --- |
| NativePHP | ネイティブピーエイチピー | 公式記載なし(introduction・installation・READMEに読み方の記載を確認できず)。慣用として。セリフでは断定しない |
| PHP | ピーエイチピー | 一般的な読み(文字読み) |
| Laravel | ララベル | 公式のドキュメントに読み方の記載を確認できず。慣用として。発表者の普段の読みに合わせる |
| Electron | エレクトロン | 公式記載なし。一般的な読み |
| composer | コンポーザー | 一般的な読み |
| Node | ノード | 一般的な読み |
| SQLite | エスキューライト | sqlite.org の About SQLite に発音の記載を確認できず。慣用として |
| MIT | エムアイティー | 一般的な読み(文字読み) |
| Hello World | ハロー ワールド | 一般的な読み |
| macOS / Windows / Linux | マックオーエス / ウィンドウズ / リナックス | 一般的な読み |
| iOS / Android | アイオーエス / アンドロイド | 一般的な読み |

## 言い換え表(言いにくい語 | 言い換え候補)

| 言いにくい語 | 言い換え候補 |
| --- | --- |
| NativePHP | このフレームワーク / PHPでネイティブアプリを作る仕組み |
| Laravel | PHPのフレームワーク |
| Electron | 外枠 / ブラウザの部品を組み込める土台 |
| 静的PHP | ライブラリごと一つにまとめたPHP / 単体で動くPHP |
| フレームワーク | 土台 / 部品がそろった枠組み |
| ネイティブアプリ | その端末向けのアプリ |
| composer | PHPのパッケージ管理ツール |
| 同梱 | 中に入れる / 一緒に入れる |
| 依存 | 頼っている部品 / 必要な部品 |
| ライセンス | 利用条件 |
| 署名 | 発行元を示す印をつけること / 本物だと示す印 |
| ビルド | 配れる形にまとめること |
| 環境ファイル(.env) | 設定を書いたファイル |
| SQLite | ファイルで動く軽いデータベース |
| データベース | データをためる仕組み |
| 鍵つきの通信 | 確認つきの通信 |
| 位置づけ | どういうものか |
| リポジトリ | ソースの置き場 |

## 質問されそうな点(3〜5個、答えと出典つき)

1. 最新の Laravel 13 でも動きますか
   - 答え: 公式の対応表(2026年10月時点)は Laravel 11.x と 12.x までで、13.x は載っていない。desktop 2.3.1 の composer.json は illuminate/contracts を ^13 まで許容するが、動作は未確認(スライド5のとおり)。公式は、サポートを求めるときはサポート対象の版を使うよう求めている
   - 出典: https://nativephp.com/docs/desktop/2/getting-started/support-policy / https://packagist.org/packages/nativephp/desktop / https://laravel.com/docs/13.x/releases
2. 利用者の端末に PHP は必要ですか
   - 答え: 不要。公式は、静的PHPのランタイムを同梱するので、利用者側の準備は要らないと説明している。同梱の php は、Linux x64 の実行結果で ldd が「not a dynamic executable」(ほかのライブラリに依存しない)
   - 出典: https://nativephp.com/docs/desktop/2/getting-started/introduction / https://github.com/NativePHP/php-bin / 動作確認の節
3. 無料で使えますか。料金は
   - 答え: 本体(Desktop と Mobile)のライセンスは MIT で、無料で使える。有料なのは周辺サービス。例の Bifrost(クラウドでのビルド・署名・配布)には、月10ドルのプランの記載がある(2026年10月時点)。Mobile 版のほかの有料要素は確認していない
   - 出典: https://github.com/NativePHP/desktop / https://github.com/NativePHP/mobile-air / https://bifrost.nativephp.com/
4. MySQL や PostgreSQL は使えませんか
   - 答え: 公式は、標準で対応するのは SQLite のみと説明している。同梱の php の拡張も、DB は pdo_sqlite と sqlite3 だけ(php-extensions.txt と `php -m` の結果)。ほかのDBにつなぐ方法は、この発表では確認していない
   - 出典: https://nativephp.com/docs/desktop/2/digging-deeper/databases / https://github.com/NativePHP/php-bin / 動作確認の節
5. 配るときに気をつけることは
   - 答え: .env もアプリに含まれるので、秘密情報は入れない。ビルドは1回につき1つのOS向けで、macOS と Windows は配る前にコード署名が必要。クロスコンパイルは全環境では対応していない
   - 出典: https://nativephp.com/docs/desktop/2/getting-started/env-files / https://nativephp.com/docs/desktop/2/publishing/building
