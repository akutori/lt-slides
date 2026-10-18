# memo: FilamentPHP

## 前提(想定時間・枚数・ツール・作成日)

- 想定時間: 10分のLT。セリフは合計約2580字(句読点と差し込み行を含む)。1分300字で換算すると約8.6分で、言い詰まりや間の余裕を残した量
- 枚数: 10枚(タイトル1、見出し3、本文5、まとめ1)
- ツール: Marp(marp-cli 4.5.1)。`lt-marp-png` でPNG化し、10枚すべてを目視確認した(はみ出しと日本語フォントを確認)
- 作成日: 2026-10-09(出典の確認日も同日)
- 対象: Filament 5.x(2026年10月時点の最新は v5.10.1)
- 話の軸: モデルから管理画面ができるまで(Filamentとは、作る流れ、向き不向きと注意、まとめ)
- 表記: タイトルはシード指定どおり「FilamentPHP」。公式の製品名は「Filament」(ドメインは filamentphp.com)なので、本文は公式の表記に合わせて「Filament」とした
- 経験談: セリフとスライドでは、発表者の経験を事実として書いていない。Filamentの使用経験は不明なため、差し込み欄(2か所)にした

## 構成メモ(スライド番号 / 種別 / 要旨)

| スライド | 種別 | セリフ字数 | 要旨 |
|---|---|---|---|
| 1 | タイトル | 60 | 「FilamentPHP」のみ。セリフは3行(話の内容、名前、話す順番) |
| 2 | 見出し | 35 | Filamentとは |
| 3 | 本文 | 426 | 定義(Laravel向けのSDUIフレームワーク。UIをPHPの設定オブジェクトで定義)、土台(Livewire、Alpine.js、Tailwind CSS)、用途、MIT、現行は5系、5系の要件 |
| 4 | 見出し | 32 | モデルから管理画面まで |
| 5 | 本文 | 392 | インストールの3コマンド(公式ドキュメントのコマンド。未実行)、/admin でサインイン、PowerShellの注記 |
| 6 | 本文 | 405 | `make:filament-resource Customer --generate` と生成ファイル、他のオプション、メニューに出ないときの `viewAny()` |
| 7 | 本文 | 386 | フォーム(Schemas)と表(Tables)のコード(公式ドキュメントから抜粋)、ページとの対応、差し込み1 |
| 8 | 見出し | 32 | 向き不向きと注意 |
| 9 | 本文 | 446 | 版の違い(4系のディレクトリ構成、5系はLivewire 4が必要)、サポート期限、独自の画面はLivewire、代替(Laravel Nova)、プラグインの注意、差し込み2 |
| 10 | まとめ | 369 | 5項目(定義、インストール、リソース生成、版ごとの確認、独自の画面とLivewire) |

- 合計: 2583字(句読点込み、差し込み行込み)。差し込み行を除くと2515字。句読点を除くと、差し込み行込みで2310字、差し込み行なしで2251字
- 本文のセリフは1枚あたり369〜446字で、目安の350字をやや超える。ただし1分〜1分30秒の範囲に収まる
- 時間が押したときに削れる行
  - スライド3: 「また、パネルを使わず、部品だけを入れる使い方もあります。」
  - スライド5: 「なお、作れるパネルは、一つに限りません。」と、次の「ただし、インストールは一度で済みます。」
  - スライド7: 「日付の選択や、ファイルの添付も、同じ書き方で作れます。」
  - スライド9: 「なお、セキュリティ修正は、別の期限です。」
  - スライド10: 「今日は触れませんでしたが、通知やダッシュボード用の部品もあります。」と、次の「出典は、これまでの各スライドの下に載せてあります。」

## 出典一覧(URL | 確認日 | 何の裏付けか)

確認方法の凡例: 「サイト」はWebFetchでの本文確認、「原本」は filamentphp/filament の v5.10.1 のリポジトリ(docs/ とソース)の読解。docsの原本はリポジトリの docs/ にあり、サイトの各ページと対応する。

| URL | 確認日 | 何の裏付けか |
|---|---|---|
| https://filamentphp.com/ | 2026-10-09 | トップの紹介文(Laravel向けのオープンソースのUIフレームワーク)。メジャー版とライセンス名の記載はなかった(サイト) |
| https://filamentphp.com/docs/llms.txt | 2026-10-09 | ドキュメントの目次(5.x〜1.x)。参照するページの特定に使用(サイト) |
| https://filamentphp.com/docs/5.x/introduction/overview | 2026-10-09 | [3,9,10] 定義(Server-Driven UI。PHPの構造化された設定オブジェクトでUIを定義)、土台(Livewire、Alpine.js、Tailwind CSS)、用途(管理パネル、ダッシュボード、フォーム中心のアプリ)、SDUIの利点(一貫性とロジックの集約)、独自のJavaScript不要、公式以外のプラグインは品質・互換性などを保証しない、プラグインは大半が無料で一部が有料、代替(Livewireを避けたい場合は Laravel Nova)(サイトと原本) |
| https://filamentphp.com/docs/5.x/introduction/installation | 2026-10-09 | [3,5] 要件(PHP 8.2+、Laravel v11.28+、Tailwind CSS v4.1+)、3つのコマンド、PowerShellでは `~5.0`、AdminPanelProvider.php の作成、/admin、パネルは複数作れるがインストールは1回(サイトと原本) |
| https://filamentphp.com/docs/5.x/introduction/version-support-policy | 2026-10-09 | [3,9] 現行は5.x(6.xのstable版は未リリース)、3.xのバグ修正は2026-08-01まで、4.xは2027-01-15まで、セキュリティ修正は別の期限(3.xは2028-01-01、4.xは2028-01-15)(サイトと原本) |
| https://filamentphp.com/docs/5.x/getting-started | 2026-10-09 | [5,6,10] /admin からダッシュボード、リソースの標準3ページ(List、Create、Edit。Viewは任意)、サイドバーの項目は自動登録、初期ダッシュボードのウィジェットは2つ(あいさつと情報)(サイトと原本) |
| https://filamentphp.com/docs/5.x/panel-configuration | 2026-10-09 | [5] 既定のパネルは /admin、設定ファイルは AdminPanelProvider.php、パネルは複数作れる(サイトと原本) |
| https://filamentphp.com/docs/5.x/resources/overview | 2026-10-09 | [6,7] `make:filament-resource` の例(`--simple`、`--generate`、`--view`、`--model --migration --factory`)、生成ファイルのツリー、メニューに出ないときの `viewAny()`、form() は作成と編集、table() は一覧のページで使う、フォームと表のコード例(サイトと原本) |
| https://filamentphp.com/docs/5.x/forms/overview | 2026-10-09 | [7] メソッドでの検証指定(`required()` など)と、IDEの補完が効く利点(サイトと原本 packages/forms/docs/01-overview.md) |
| https://filamentphp.com/docs/5.x/navigation/custom-pages | 2026-10-09 | [9] `make:filament-page`、ページはフルページのLivewireコンポーネント(サイトと原本) |
| https://filamentphp.com/docs/5.x/upgrade-guide | 2026-10-09 | [9] 5系の新要件(PHP 8.2+、Laravel v11.28+、Livewire v4.0+、Tailwind CSS v4.0+)、プラグインが5系でまだ使えない場合がある、自動アップグレードスクリプトの手順(サイトと原本) |
| https://filamentphp.com/docs/4.x/upgrade-guide | 2026-10-09 | [9] v4でリソースとクラスタの標準のディレクトリ構成が新しくなった(サイトと、タグ v4.15.1 の原本) |
| https://packagist.org/packages/filament/filament | 2026-10-09 | [3] 最新の安定版 v5.10.1(2026-10-07 19:53 UTC)、ライセンス MIT、PHP ^8.2(サイト) |
| https://github.com/filamentphp/filament/releases/latest | 2026-10-09 | [3] v5.10.1 が Latest(サイト) |
| https://github.com/filamentphp/filament | 2026-10-09 | リポジトリのAbout欄に MIT license。タグ一覧に v6 系なし(タグ一覧1335件を取得し、v6 で始まるものがないことを確認) |
| https://github.com/filamentphp/filament/tree/v5.10.1 | 2026-10-09 | 取得したタグ。commit f85ef71a8809df17fd3e7c23a22d5585bb125f68(2026-10-07)。LICENSE.md が MIT(Copyright (c) Filament)、packages/support/composer.json(PHP ^8.2、illuminate/contracts ^11.28、^12.0、^13.0、livewire/livewire ^4.4.7)、packages/panels/src/Commands/MakeResourceCommand.php(生成するファイルの種類、`--generate` の意味、対話の質問)、packages/support/src/Commands/InstallCommand.php、packages/panels/src/Commands/MakeUserCommand.php、packages/panels/src/Commands/FileGenerators/PanelProviderClassGenerator.php(原本) |
| https://livewire.laravel.com/docs/4.x/quickstart | 2026-10-09 | [3] Livewireの説明(英語の原文は「using only PHP—no JavaScript required」)。この前提(Laravel 10+、PHP 8.1+)はLivewire自身の要件で、Filamentの要件ではない(サイト) |
| https://livewire.laravel.com/ | 2026-10-09 | トップの紹介文(Laravel向けのフルスタックのフレームワーク)(サイト) |
| https://laravel.com/docs/authorization | 2026-10-09 | [6] ポリシーの定義(英語の原文は「Policies are classes that organize authorization logic around a particular model or resource」)。ページはLaravel 13.x(サイト) |
| https://demo.filamentphp.com | 2026-10-09 | 確認したがログイン画面のみで、スクリーンショットの代わりにならなかった。スライドでは未使用(サイト) |

## ⚠️ 出典なし・未確認の情報

- 読み方(フィラメント、ララベル、ライブワイヤー、ノヴァ、パワーシェル、「五系」などの「系」): 公式記載なし。filamentphp/filament v5.10.1 のMarkdown全体で「pronounc」を検索しても該当なし。Laravelの読みはWebSearchでも調べたが、権威のある記載は見つからなかった(他の語は、読んだ公式ページに記載がなかった)。セリフでは読みを断定する言い方をしていない
- Tailwind CSSの要件: インストールページは v4.1+、5.x アップグレードガイドは v4.0+ と書いている(公式内の不一致)。スライド3はインストールページに合わせた
- Livewireの要件: ドキュメントは v4.0+、リポジトリの packages/support/composer.json は `^4.4.7` を要求している。スライド9は「Livewire 4が必要」と書き、細かい下限は書いていない
- スライド6の生成ファイル一覧: 実機で生成していない。公式ドキュメントのファイルツリー(`make:filament-resource Customer`)と、v5.10.1 のソース(`--generate` はファイルの種類を変えず、フォームと表の中身をDBカラムから作る)で確認した
- スライド5の3コマンド: 実機で実行していない(理由は「動作確認」)。公式ドキュメントの記載のみ
- ソースのみで確認したこと(公式ドキュメントに明記なし): `make:filament-resource` はオプションを付けないと、タイトルに使う列、Viewページの有無、DBカラムからの生成を対話で聞く。`filament:install --panels` は composer.json の post-autoload-dump にスクリプトを足し、公開アセットを .gitignore に足す。どちらもスライドとセリフでは使っていない
- GitHubの LICENSE のページ(blob)は、WebFetchが2回エラーになった。代わりに、取得したタグの LICENSE.md、Packagist、リポジトリのAbout欄でMITを確認した
- タグのコミット日(v5.0.0 は 2026-01-16、v4.0.0 は 2025-08-12)は、リリース日と一致する保証がない。スライドでは使っていない
- 「つまり〜のことです」の言い換え(サーバー側でUIを組み立てる方式、PHPだけで画面を動かす仕組み、リソース、パネル、ポリシー)は、公式の英語の説明を発表者向けに言い換えた文で、公式の日本語訳ではない
- スクリーンショット: この環境ではブラウザの画面を取得できない。差し込み欄にした

## 差し込み欄(スライド番号 | 何を入れるか)

| スライド番号 | 何を入れるか |
|---|---|
| 7 | 生成された画面(一覧、作成、編集)のスクリーンショットと、触った感想。スライド: 「【差し込み: 生成された画面のスクリーンショットと、触った感想】」。セリフ: 「(※ここで実体験を話す: 生成された画面を触った感想について)」 |
| 9 | Filamentを使って困った点、または検討中の理由。スライド: 「【差し込み: Filamentを使って困った点、または検討中の理由】」。セリフ: 「(※ここで実体験を話す: 使って困った点、または検討している理由について)」 |

- 差し込みがなくても、前後の事実部分(公式ドキュメントの内容)で話が通る
- まだ試していない、または検討中の場合は、そう分かる言い方にする(使った経験があるように話さない)
- 評価語(「爆速」など)を使う場合は、発表者の感想と分かる言い方にする(スライドとセリフには評価語を入れていない)

## 動作確認(実行したもの / 未実行とその理由 / バージョン / 環境)

実行したもの

- `php -v`: PHP 8.3.6 (cli) (NTS)。Filament 5.x の要件 PHP 8.2+ を満たす
- `composer --version`: Composer 2.8.12(root実行のため `COMPOSER_ALLOW_SUPERUSER=1` を指定)
- `php -m`: pdo_sqlite、sqlite3、intl、mbstring、openssl、curl、zip、xml、dom、tokenizer、fileinfo、ctype を確認
- filamentphp/filament を v5.10.1 のタグで浅くクローンし(commit f85ef71a8809df17fd3e7c23a22d5585bb125f68)、docs/ とソースを読んだ。比較用に v5.0.0、v4.0.0、v4.15.1 のタグも取得した
- リモートのタグ一覧(1335件)を取得し、v6 で始まるタグがないこと、最新が v5.10.1 であることを確認した
- Marp(marp-cli 4.5.1)のPNG化と目視確認。全10枚で、はみ出しなし、日本語フォントが正しいことを確認した

未実行(公式ドキュメントの記載のみ)

- `composer require filament/filament:"^5.0"`、`php artisan filament:install --panels`、`php artisan make:filament-user`、/admin でのサインイン、`php artisan make:filament-resource Customer --generate`、生成ファイルの確認
- 理由: この環境の外向き通信のプロキシが、Packagist(repo.packagist.org、packagist.org)、getcomposer.org、laravel.com への接続を 403 で拒否する。Composerが依存パッケージを解決できず、Laravelのプロジェクトを作れない。環境の方針により、迂回していない
- 代わりに、公式ドキュメントの原本(リポジトリの docs/)と、サイトの各ページ(WebFetch)、v5.10.1 のソースで内容を確認した。スライド5・6・7には「公式ドキュメント」の例と明記してある
- 実際の出力(`filament:install` や `make:filament-resource` の画面出力)は、スライドに載せていない
- 発表前に、新しいLaravelプロジェクトで3コマンドとリソース生成を一度実行し、出力とスクリーンショットを確認するのがよい。出力が公式ドキュメントと違う場合は、スライド5と6を直す

バージョン

- Filament: 5.x(最新は v5.10.1。2026年10月時点)
- 要件: PHP 8.2+、Laravel v11.28+、Livewire v4.0+、Tailwind CSS v4.1+(Tailwindはページにより v4.0+ の記載もある)

環境

- Linux 6.18(サンドボックス)、PHP 8.3.6、Composer 2.8.12、marp-cli 4.5.1

## 読み方メモ(語 | 採用する読み | 根拠)

| 語 | 採用する読み | 根拠 |
|---|---|---|
| Filament | フィラメント | 公式記載なし。慣用として「フィラメント」 |
| Laravel | ララベル | 公式記載なし。慣用として「ララベル」 |
| Livewire | ライブワイヤー | 公式記載なし。慣用として「ライブワイヤー」 |
| Laravel Nova | ノヴァ(セリフでは「ノヴァ」のみ) | 公式記載なし。慣用として「ノヴァ」 |
| Server-Driven UI(SDUI) | サーバードリブンUI(「SDUI」の略称は読まない) | 公式は英語表記のみ。読みは公式記載なし。慣用として「サーバードリブンUI」 |
| 5.x、4.x、3.x | 五系(ごけい)、四系(よんけい)、三系(さんけい) | 公式は「5.x」などと表記。「◯系」は口頭で言うための慣用。セリフでは漢数字で統一 |
| MIT | エムアイティー(アルファベット読み) | 略称。公式記載なし。慣用として「エムアイティー」 |
| PHP | ピーエイチピー | 略称。公式記載なし。慣用として「ピーエイチピー」 |
| DB | ディービー | 略称。公式記載なし。慣用として「ディービー」 |
| UI | ユーアイ | 略称。公式記載なし。慣用として「ユーアイ」 |
| PowerShell | パワーシェル | 公式記載なし。慣用として「パワーシェル」 |

- コマンド、オプション、ファイル名、URL、日付、バージョン番号は、セリフで読み上げない(「画面のとおりです」と指す)

## 言い換え表(言いにくい語 | 言い換え候補)

| 言いにくい語 | 言い換え候補 |
|---|---|
| フィラメント(Filament) | 「この道具」、「管理画面の道具」 |
| ララベル(Laravel) | 「PHPのフレームワーク」、「このフレームワーク」 |
| ライブワイヤー(Livewire) | 「PHPだけで画面を動かす仕組み」、「あの仕組み」 |
| ノヴァ(Nova) | 「ララベルのチームが作る別の道具」、「公式が挙げる別の道具」 |
| サーバードリブンUI | 「サーバー側でUIを組み立てる方式」 |
| リソース(Resource) | 「モデルの操作画面を定義するクラス」、「画面の定義」 |
| ポリシー(Policy) | 「権限の判定をまとめたクラス」、「権限の設定」 |
| ダッシュボード | 「最初の画面」、「トップの画面」 |
| パワーシェル(PowerShell) | 「Windowsの端末」 |
| モーダル | 「ポップアップの画面」、「重ねて開く画面」 |
| プラグイン | 「追加の拡張」、「拡張パッケージ」 |
| 移行ガイド(アップグレードガイド) | 「版を上げる手順」 |
| セキュリティ修正 | 「安全面の修正」 |

## 質問されそうな点(3〜5個、答えと出典つき)

1. ライセンス、料金、動作要件は?
   - 答え: ライセンスはMIT。5系の要件は PHP 8.2+、Laravel v11.28+、Tailwind CSS v4.1+。5.x のアップグレードガイドには Livewire v4.0+ も新要件として載り、Tailwind は v4.0+ と書かれている(公式内の差)。プラグインは大半が無料で、一部に有料のものがある
   - 出典: https://packagist.org/packages/filament/filament 、https://filamentphp.com/docs/5.x/introduction/installation 、https://filamentphp.com/docs/5.x/upgrade-guide 、https://filamentphp.com/docs/5.x/introduction/overview 、リポジトリの LICENSE.md
2. 4系以前から5系に上げるには?
   - 答え: 5.x のアップグレードガイドに、自動アップグレードスクリプトの手順がある(`filament/upgrade` を開発用に入れ、`vendor/bin/filament-v5` を実行して、出力されたコマンドを実行する)。先に新要件(Livewire v4.0+ など)と、使っているプラグインの対応を確認する。3系から4系は 4.x のガイドを見る
   - 出典: https://filamentphp.com/docs/5.x/upgrade-guide 、https://filamentphp.com/docs/4.x/upgrade-guide
3. リソースを作ったのにメニューに出ないのは?
   - 答え: モデルポリシーがあるなら、`viewAny()` が `true` を返しているか確認する(公式のヒント)
   - 出典: https://filamentphp.com/docs/5.x/resources/overview 、https://laravel.com/docs/authorization
4. Livewireを触らずに使える? 代替は?
   - 答え: 公式は、多くの部分はLivewireに触れずに済むが、独自の部品を作るときは触れる場合がある、と説明している(要約)。避けたい場合の代替として Laravel Nova(Vue.js と Inertia.js 製で、Laravelチームの公式プロジェクト)を挙げている。CMSが要るなら Statamic、Bladeだけで書くなら Flux も挙げている
   - 出典: https://filamentphp.com/docs/5.x/introduction/overview(Alternatives to Filament)
5. `--generate` は何を前提にする?
   - 答え: モデルが `App\Models` にあり(別の場所なら `--model-namespace`)、DBのスキーマを読めること。モデル、マイグレーション、ファクトリーも同時に作るなら `--model --migration --factory`。オプションを付けない場合の対話の質問は、v5.10.1 のソースで確認した(公式ドキュメントに明記なし)
   - 出典: https://filamentphp.com/docs/5.x/resources/overview 、リポジトリの packages/panels/src/Commands/MakeResourceCommand.php(v5.10.1)
