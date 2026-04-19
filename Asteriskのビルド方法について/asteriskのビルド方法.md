---
marp: true
paginate: true
---

# Asteriskのビルド方法

<!-- 今回はAsteriskのビルド方法について説明します -->

---

# はじめに

<!-- まずはじめにですが -->

---

<!-- header: はじめに -->

IP-PBXであるAsteriskを導入するにあたり、Asteriskのビルド方法やその他気をつけることについてまとめました

今回はARAの導入や､FreePBXを利用しない前提でのAsteriskのビルド方法について説明します

ユーザーやグループの作成､必要パッケージのインストール､ソースコードのダウンロードからビルド､インストール､サービス設定までを一通り解説します

今回はUbuntuを例に解説しますが､Debian系は`apt install asterisk`でインストールしたほうが正直楽です

※ 作業ディレクトリは`/tmp`であることを想定しています

※ 今回はUbuntuのコンテナ内でビルドを行うため手順が違う・変わる可能性についてはご了承ください

<!-- 今回はIP-PBXのAsteriskのビルド方法について説明します｡とりあえず特殊なAsteriskの運用方法やGUIツールであるFreePBXを使用せずにソースからビルドする方法を解説します -->
<!-- 少し複雑にはなりますが､rootユーザーではなく専用のasteriskユーザーで実行するためのちょっとだけ実務でも利用できそうなやり方について知っていただけると幸いです -->
<!-- ちなみにですがDebian系は「apt install asterisk」でインストールしたほうが正直楽です-->
<!-- 余談ですが､今回作業ディレクトリとして「/tmp」を利用していますが､再ビルドを考慮する場合は､別のディレクトリにしてください｡ -->

---

Asteriskインストールの手順は組織や利用目的､環境によって大きく異なるため､公式を参考にしてください

https://docs.asterisk.org/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/

<!-- Asteriskのインストール方法は利用する組織､ネットワーク､利用方法やOSなどによって大きく変わるため､できる限り公式やコミュニティを参考にしてください｡ -->

---

<!-- header: '' -->

# Asteriskを実行するためのユーザーとグループを作成する

<!-- まず初めにAsteriskを実行するためのユーザーとグループを作成します -->

---

<!-- header: Asteriskを実行するためのユーザーとグループを作成する -->

Asteriskは専用のユーザーとグループで実行することが推奨されているため､事前に作成しておく

参考情報

- https://www.jpcert.or.jp/at/2010/at100032.html
- https://www.voip-info.jp/index.php/Asterisk_SIP_%E3%82%BB%E3%82%AD%E3%83%A5%E3%83%AA%E3%83%86%E3%82%A3

<!-- Asteriskに限らずだとは思いますが､基本的にrootユーザーではなく専用のユーザーを作成｡それを利用して実行する方式が推奨されています｡ -->

---

```bash
# Asterisk用のシステムグループを作成
sudo groupadd --system asterisk

# Asterisk用のシステムユーザーを作成（ログインシェルなし）
sudo useradd --system --no-create-home --shell /sbin/nologin --gid asterisk asterisk
```

- `--system`: システムユーザー／グループとして作成
  - UID/GID が低い番号で割り当てられる
- `--no-create-home`: ホームディレクトリを作成しない
- `--shell /sbin/nologin`: ログインシェルを無効にする（セキュリティ向上）
- `--gid asterisk`: 既存の asterisk グループに所属させる（groupadd で先に作成）

<!-- ユーザー作成ですが､システムユーザーとして作成してください｡普通のユーザーとして作成しても問題ありません｡ 

postgresqlを例にするとわかりやすいかもしれません｡ただ､ユーザー作成からすべて自分たちでやらないのが非常にきつい
-->


---

<!-- header: '' -->

# ソースコードをダウンロード + 展開

<!-- 次にソースをダウンロードして展開します -->

---

<!-- header: ソースコードをダウンロード -->

Asteriskの公式サイトからソースコードをダウンロード

ここに現在サポートされているバージョンのtarballがある
https://downloads.asterisk.org/pub/telephony/asterisk/

```bash
wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-23-current.tar.gz
```

ダウンロードしたtarballを展開して中に入る

```bash
tar zxvf asterisk-23-current.tar.gz
cd asterisk-23.*/
```

<!-- 安定版は 「asterisk-バージョン-current」といった形式になるので､実際に運用を行う場合は証拠も兼ねてバージョンが明記されているものを選択してください

展開後はディレクトリに移動してください｡ -->

---

<!-- header: '' -->

# 必要パッケージをインストールする

<!-- 次にAsteriskをビルドするために必要なパッケージをインストールします｡ここからが本番です -->

---

<!-- header: 必要パッケージをインストールする -->

2パターンある

1. 手動で必要パッケージをインストールする方法
2. `install_prereq`スクリプトを使う方法 (推奨)

<!-- Asteriskを実行させるためには大量の依存ライブラリが必要であり､それを解決するための方法として2つあります -->

---

## 1. 手動で必要パッケージをインストールする方法

<!-- footer: https://www.voip-info.jp/index.php/Asterisk_22#Asterisk%E3%81%AE%E3%82%B3%E3%83%B3%E3%83%91%E3%82%A4%E3%83%AB%E3%81%A8%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB <br> https://docs.asterisk.org/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Prerequisites/Checking-Asterisk-Requirements/
-->


Cコンパイラに加えて、システムライブラリ一式も必要。
必須ライブラリはAsteriskで使用され、Asteriskをコンパイルする前にインストールする必要がある。

コアライブラリは、追加のコアサポート機能のコンパイルを可能にする。
ほとんどのオペレーティングシステムでは、**ライブラリとそれに対応する開発パッケージの両方をインストールする必要がある**
> 例: `libxml2`ライブラリをインストールするには、`libxml2`と`libxml2-dev`の両方をインストールする必要がある
> https://docs.asterisk.org/Operation/System-Requirements/System-Libraries/

<!-- 1つ目は普通に頑張って手動で追加していくパターンです｡ 
Cコンパイラに加えて、システムライブラリ一式も必要です｡
めんどくさいのが､ライブラリ と､それに対応する開発パッケージの両方が必要になるという点です｡
利用するモジュールごとに必要なライブラリが異なるため､必要に応じて追加していく必要があります｡ -->


---

コミュニティWikiを参考に必要なパッケージをインストールする

参考: https://www.voip-info.jp/index.php/Asterisk_22#Asterisk%E3%81%AE%E3%82%B3%E3%83%B3%E3%83%91%E3%82%A4%E3%83%AB%E3%81%A8%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB

```bash
apt -y install \
build-essential libedit-dev uuid-dev libxml2-dev \
libncurses-dev libsqlite3-dev sqlite3 libssl-dev subversion \
git net-tools dnsutils libsrtp2-dev libunbound-dev
```

これで最小限のAsteriskをビルドするためのパッケージが揃う

<!-- 流石に1からやるのはやってられないのでコミュニティwikiなどを参照してください｡
少なくとも通常､これで最低限ビルドはできるみたいです｡ -->

---

<!-- footer: '' -->

なぜこのやり方が多いのかというと､`install_prereq`スクリプトはすべてのモジュールを利用することを想定しているのか､かなり多くのパッケージをインストールしようとするため､必要最低限に抑えたい場合は手動でインストールしたほうが良い場合があるため

<!-- 後述するやり方よりもこの手法がよく用いられているように感じます｡おそらくこの理由として install_prereq はすべてのモジュールをビルドする前提でパッケージをインストールするので､セキュリティポリシーの都合で必要最低限に留める場合やサイズを気にする場合などはやはり手動で追加するのが好まれるようです｡
それでも1GBはなかったはずですが -->

---

### パッケージ手動インストールパターンのフローチャート

以下の流れで必要なパッケージを少しづつインストールしていく

<br><br><br>


![w:2000](.\images\パッケージ手動インストールパターンのフローチャート.png)

<!-- あまり個別追加はやりたくないタイプですが､もし今後これを利用する方はこのフローに従ってパッケージを追加していくのが良いと思います｡
図は見えますかね?
configureができるまで不足パッケージを追加していき､モジュール追加を行うときに､使いたいモジュールが選択できない場合はそのモジュールに必要なパッケージを追加していったあとに再度 configure を実行｡満足行くまで繰り返す感じです｡ -->

---

<!-- footer: https://docs.asterisk.org/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Prerequisites/Checking-Asterisk-Requirements/#using-install_prereq -->

## 2. `install_prereq`スクリプトを使う方法 (推奨)

`install_prereq`スクリプトを使用することで各ディストリビューションに応じた必要パッケージを自動でインストールできる

RockyとUbuntuは問題ないことを確認済み(233 MBくらい)

```bash
# 必要な依存パッケージを自動でインストール(通常これだけで良い)
./contrib/scripts/install_prereq install
```

```bash
# (任意)パッケージのないライブラリをソースコードからビルドしてインストール
./contrib/scripts/install_prereq install-unpackaged 

# (任意)インストールされる予定のパッケージ一覧を表示
./contrib/scripts/install_prereq test 
```

<!-- 2つ目は install_prereq スクリプトを利用する方法です｡ 
基本的に何も考えなくていいのが最大の利点であり､基本的にこれを実行するとモジュールがほとんど選択できるようになります｡
また､これ作っているときに初めて知ったんですが､ソースコードからビルドする必要があるものも install-unpackaged で自動でビルドしてくれるみたいです｡
気をつけてほしいことはそこそこの時間がかかることですかね｡
-->

---

<!-- footer: https://github.com/akheron/jansson -->

すべてのパッケージがインストールされたら`./configure`を実行してAsteriskのビルド環境を構築する

```bash
./configure 
```

よく使われるオプション

- `--with-jansson-bundled`
  - Jansson を OS パッケージではなく Asterisk 同梱版でビルド
  - Jansson = JSONデータのエンコード、デコード、および操作を行うCライブラリ

<!-- パッケージのインストールが終了すれば configure を実行してビルド環境を構築してください｡
ここではバイナリの配置先等の細かいオプションを指定できます｡
ここで最近よく指定されるのが「with-jansson-bundled」です｡ 
これはJSONを扱うためのライブラリをOSのパッケージではなくAsteriskに同梱されたバージョンでビルドするオプションです｡
AsteriskではRest APIを利用する場合にJSONを扱うため､このオプションを指定することが多いです｡
-->

---

<!-- footer: '' -->

`./configure`が成功するとこのように表示される

```
configure: Menuselect build configuration successfully completed

               .$$$$$$$$$$$$$$$=..
            .$7$7..          .7$$7:.
          .$$:.                 ,$7.7
        .$7.     7$$$$           .$$77
     ..$$.       $$$$$            .$$$7
    ..7$   .?.   $$$$$   .?.       7$$$.
   $.$.   .$$$7. $$$$7 .7$$$.      .$$$.
 .777.   .$$$$$$77$$$77$$$$$7.      $$$,
 $$$~      .7$$$$$$$$$$$$$7.       .$$$.
.$$7          .7$$$$$$$7:          ?$$$.
$$$          ?7$$$$$$$$$$I        .$$$7
$$$       .7$$$$$$$$$$$$$$$$      :$$$.
$$$       $$$$$$7$$$$$$$$$$$$    .$$$.
$$$        $$$   7$$$7  .$$$    .$$$.
$$$$             $$$$7         .$$$.
7$$$7            7$$$$        7$$$
 $$$$$                        $$$
  $$$$7.                       $$  (TM)
   $$$$$$$.           .7$$$$$$  $$
     $$$$$$$$$$$$7$$$$$$$$$.$$$$$$
       $$$$$$$$$$$$$$$$.
```

<!-- configureが成功すると最後にこんなのが表示されます｡ ちなみにこれはAsteriskのロゴです｡ -->

---

<!-- header: '' -->

# (任意)make menuselectで必要モジュールを選択する

<!-- ここからは一応任意項目とはなりますが､ほとんどの場合利用されるモジュール選択について説明していきます｡ -->

---

<!-- header: (任意)make menuselectで必要モジュールを選択する -->

基本的には`make menuselect`を実行せずに､そのまま`make`→`make install`しても
問題ないが､用途に応じて必要なモジュールを選択したい場合は
`make menuselect`を実行する

<!-- 実はのままビルドしてしまっても問題はないです｡特にinstall_prereqで必要なパッケージをインストールしていればほとんどのモジュールは有効になっているためです｡ 
しかし､用途によって特定のモジュールの有効化などを行うことがあるためその時にはmenuselectで選択する必要があります｡ -->

---


Asteriskには多くのモジュールがあり､用途に応じて必要なモジュールをビルド前に選択する
`make menuselect`コマンドを実行すると､モジュール選択画面(TUI)が表示される

![w:900](images/make%20menuselect.png)

<!-- make menuselect を実行するとモジュール選択画面がTUIで表示されます｡なかなか洒落ている -->
<!-- 次の2ページではmenuselectでよく確認する項目について少しだけ解説します -->

---

## menuselectでよく確認する項目

- **Channel Drivers**
  - SIP や PJSIP、DAHDI など「通話チャネル」を扱うドライバ 
  - 例：`chan_pjsip`、`chan_sip`、`chan_dahdi`

- **Codec Translators**
  - コーデック変換モジュール 
  - 例：ulaw ↔ alaw、G722、GSM など

<!-- 確認する項目としてはおおよそ4つ程度あります｡ 
「Channel Drivers」では通話に関しての重要なモジュールを､
「Codec Translators」ではコーデック変換ツールについてのモジュールを取り扱っています｡ -->

---

- **Format Interpreters**
  - 音声ファイルの読み書きフォーマット 
  - 例：WAV、SLN、GSM ファイルなど

- **Resource Modules**
  - 外部サービスや内部機能を提供するリソース群 
  - 例：`res_pjsip_*`、`res_rtp_asterisk`、`res_http_websocket`

<!-- 「Format Interpreters」では音声ファイルの読み書きフォーマットについてのモジュールを取り扱っています｡
「Resource Modules」では外部サービスや内部機能を提供するリソース群についてのモジュールを取り扱っています｡ -->

---

## TUIを使わない場合

例えばIaCなどでAsteriskをビルドする場合､TUIを使わずに必要なモジュールを有効化/無効化したい場合がある

`make menuselect.makeopts`を使用してTUIを呼び出さずにモジュールの選択ができる

https://docs.asterisk.org/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Using-Menuselect-to-Select-Asterisk-Options/#controlling-menuselect

<!-- すでにルーチン化の手順を確立している場合は make menuselect.makeopts を使用してTUIを呼び出さずにモジュール選択ができます｡
これの利用用途としてはDockerやIaCなどでAsteriskをビルドする場合です｡ -->

---

`menuselect/menuselect`コマンドにオプションを指定して実行する｡カテゴリ自体の有効無効も指定可能

最後に`menuselect.makeopts`を指定するのを忘れないこと(設定の反映を行う)

```bash
make menuselect.makeopts
menuselect/menuselect \ 
--enable codec_opus \
--enable CORE-SOUNDS-JA-WAV \
--disable res_fax \
--enable-category MENUSELECT_EXTRA_SOUNDS \
menuselect.makeopts
```

<!-- TUIを使用しない場合はカテゴリごとの有効化などもできます｡ 
最後に「menuselect.makeopts」を指定しないと反映されない点に気をつけてください｡ 
ちなみにこの menuselect.makeopts というのはファイルで､TUIでもCLIでもおなじものを参照しているみたいです｡ -->

---

<!-- header: '' -->

# ビルドとインストール

<!-- ここまでやってようやくビルドとインストールになります -->

---

<!-- header: ビルドとインストール -->

`make`コマンドでAsteriskをビルドする

```bash
make

...
Building Documentation For: channels pbx apps codecs formats cdr cel bridges funcs tests main res addons 
 +--------- Asterisk Build Complete ---------+
 + Asterisk has successfully been built, and +
 + can be installed by running:              +
 +                                           +
 +                make install               +
 +-------------------------------------------+
```

<!-- make と make install ですが､これは特になにもないので普通にビルドしてください｡ -->

---

```
make install
...

done
 +---- Asterisk Installation Complete -------+
 +                                           +
 +    YOU MUST READ THE SECURITY DOCUMENT    +
 +                                           +
 + Asterisk has successfully been installed. +
 + If you would like to install the sample   +
 + configuration files (overwriting any      +
 + existing config files), run:              +
 +                                           +
 + For generic reference documentation:      +
 +    make samples                           +
 +                                           +
 + For a sample basic PBX:                   +
 +    make basic-pbx                         +
 +                                           +
 +                                           +
 +-----------------  or ---------------------+
 +                                           +
 + You can go ahead and install the asterisk +
 + program documentation now or later run:   +
 +                                           +
 +               make progdocs               +
 +                                           +
 + **Note** This requires that you have      +
 + doxygen installed on your local system    +
 +-------------------------------------------+
```

<!-- make install 後は設定ファイル周りでやることが変わってくるので､これについては次のページで解説します -->

---

<!-- header: '' -->

# サービス設定とサンプル設定ファイルのインストール

<!-- ここからは実行のために必要な設定の追加やファイルについて説明します -->

---

<!-- header: サービス設定とサンプル設定ファイルのインストール -->

`make install`後､設定ファイルが`/etc/asterisk`に存在しない場合､Asteriskは実行できない

このとき､設定ファイルの生成方法は2つある(上書きに注意)

1. `make samples`コマンドを実行してサンプル設定ファイルを配置
   - これは設定例を含むサンプルファイルを配置するだけで､内線設定やダイヤルプランは含まれない
2. `make basic-pbx`コマンドを実行してPBX用の基本設定ファイルを配置
    - こちらは内線設定やダイヤルプランも含む､とりあえず動作するPBX用の設定ファイルを配置する

設定ファイルの内容は以下を参照
https://github.com/asterisk/asterisk/tree/master/configs

<!-- make install 後 /etc/asterisk に設定ファイルがない場合は動かすことができません｡
そのため､すでに準備している設定ファイルを個々に配置するか､持っていない場合などは設定ファイルを作成する必要があります｡
その中でも make samples はプレーンな設定ファイルを一通り全て配置します｡
make basic-pbx は pbxとして直ぐに使用ができるようなダイヤルプランや内線設定などが生成されます｡とりあえずすぐに動かしてみたい! といった場合はこちらを使用してください｡
注意点ですが､この2つは/etc/asteriskの中身を上書きする点に注意してください｡ -->

---

<!-- header: '' -->

# Asterisk を OS のサービスとして起動できるようにするための systemd ユニット & logrotationを配置する

<!-- ここからは自動起動などの設定などに関する説明を行います｡
asteriskユーザーを使用する前提での話になるので､rootユーザーで動かす場合などはほとんど手順を無視しても問題ないです｡ -->

---

<!-- header: Asterisk を OS のサービスとして起動できるようにするための systemd ユニット & logrotationを配置する -->

`make config`コマンドを実行すると､AsteriskをOSのサービスとして起動できるようにするためのsystemdユニットファイルが配置される

https://github.com/asterisk/asterisk/tree/master/contrib/systemd

24.04.3 LTSの場合､`make config`コマンドを実行すると古いinitスクリプトが`/etc/init.d/asterisk`に配置される

systemdの場合は`make config`は行わずに`contrib/systemd/asterisk.service`を`/etc/systemd/system/`にコピーする

<!-- footer: ドキュメント https://docs.asterisk.org/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Installing-Initialization-Scripts/ -->

<!-- make configを使用することでinit.dスクリプトが /etc/init.d/asterisk に配置されます｡
ご存知の通り､SysVinit はsystemdに置き換えが進んでおり､今後使われなくなるのでsystemdユニットファイルを使用する場合は､make config は使用せずにソース内のユニットファイルを /etc/systemd/system にコピーしてください -->

---

`make install-logrotate`コマンドを実行すると､Asteriskのログローテーション設定ファイルが配置される

`/etc/logrotate.d/asterisk`が作成される

https://github.com/asterisk/asterisk/blob/master/contrib/scripts/asterisk.logrotate

<!-- logrotateについても設定ファイルは用意されています｡
Asteriskは超膨大なログを吐き出しつづけることが多いです｡
そのため､logroateによるログの定期圧縮などはほぼ必須であるため､できればログローテーションの設定ファイルも作成しておきましょう｡ -->

---

<!-- header: '' -->
<!-- footer: '' -->

# ディレクトリの所有権と権限を設定する

<!-- ここからはrootユーザーを使用せずにシステムユーザーを使用してasteriskを利用する上で特に重要な点について説明します｡
個人的には最もめんどくさいと感じる箇所ですね｡ -->

---

<!-- header: ディレクトリの所有権と権限を設定する -->

一番最初に作成したAsterisk用のユーザーとグループに対して､Asteriskのディレクトリの所有権を変更する

使っているディレクトリは`etc/asterisk/asterisk.conf`で確認できる

https://www.voip-info.jp/index.php/Asterisk_22#%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB

```bash
chown -R asterisk:asterisk /var/log/asterisk
chown -R asterisk:asterisk /var/lib/asterisk
chown -R asterisk:asterisk /var/spool/asterisk
chown -R asterisk:asterisk /usr/lib/asterisk
chown -R asterisk:asterisk /etc/asterisk
chown -R asterisk:asterisk /var/run/asterisk
```

<!-- まずasteriskユーザーを使用する場合､root権限では利用できなくなるディレクトリの所有権を変更します｡
ここで気をつけてほしいことが､asterisk.confに記載のあるディレクトリすべての所有権を変える必要はないということです｡
ここについてはドキュメントやコミュニティwikiその他ブログなどでも人によって指定が違うので特に混乱することろではあります｡ -->

---

Asteriskの実行ユーザーとグループを設定する
`/etc/default/asterisk`または`/etc/asterisk/asterisk.conf`で実行ユーザーの設定が可能

`/etc/asterisk/asterisk.conf`の場合以下のコメントを外す

```ini
runuser = asterisk             ; The user to run as.
rungroup = asterisk            ; The group to run as.
```

この設定は直接`/usr/sbin/asterisk`コマンドに`-U asterisk -G asterisk`オプションを付与するのと同じ効果がある

<!-- 続いて単体実行を行う場合､自動でasteriskユーザーを使用するためにasterisk.confのユーザーとグループのコメントアウトを外します｡
これによってrootユーザーでasteriskを直接実行してもrootで起動しなくなります｡ -->

---

単体実行するときに必要であることを確認

```bash
root@fa5d44c43bb9:/tmp/asterisk-23.2.2# grep run* /etc/asterisk/asterisk.conf
astrundir => /var/run/asterisk
runuser = asterisk              ; The user to run as.
rungroup = asterisk             ; The group to run as.
root@fa5d44c43bb9:/tmp/asterisk-23.2.2# /usr/sbin/asterisk
root@fa5d44c43bb9:/tmp/asterisk-23.2.2# ps aux | grep asterisk
asterisk   87940  6.8  0.2 4896780 83668 ?       Ssl  13:16   0:00 /usr/sbin/asterisk
root       88015  0.0  0.0   3528  1736 pts/0    S+   13:16   0:00 grep --color=auto asterisk
root@fa5d44c43bb9:/tmp/asterisk-23.2.2# 
```

<!-- 変更するとこのようにasteriskユーザーで実行されていることがわかります｡
これは自己流になるのですが､しっかりとasteriskユーザーで実行されていることを確認するには /usr/sbin/asterisk のプロセスを確認したほうが早いです｡当たり前といえば当たり前なんですが｡ -->

---

## systemdサービスとして起動する場合

サービスとして起動する場合､systemdユニットファイル内で実行ユーザーとグループを指定する

`/etc/systemd/system/asterisk.service`を編集して以下の行があることを確認する

```ini
[Service]
User=asterisk
Group=asterisk
```

その後に実行させればAsteriskは`asterisk`ユーザーとグループで実行される**はず**
```bash
systemctl daemon-reload
systemctl enable --now asterisk
systemctl status asterisk
```

<!-- systemdのサービスとして起動させるにはまずユーザーとグループにasteriskが指定されていることを確認してください｡
確認といったのは元々のユニットファイルがこのようにすでにasteriskユーザーを定義しているためです｡
その後にsystemctlを使って起動してやれば問題なく実行される「はず」です｡
次ページでは今回詰まった箇所とその解決方法について説明します｡ -->

---

### トラブルシューティング

もし`systemctl status asterisk`でいつまで経ってもshellが戻って来ない場合､もしかしたら､「実行されているが､systemdが起動完了を検知できていない」可能性がある

```bash
root@fa5d44c43bb9:/tmp/asterisk-23.2.2# ps aux | grep asterisk
asterisk  111958 16.6  0.2 4896692 85312 ?       Ssl  13:35   0:00 /usr/sbin/asterisk -mqf -C /etc/asterisk/asterisk.conf
root      112033  0.0  0.0   3528  1692 pts/0    S+   13:35   0:00 grep --color=auto asterisk
root@fa5d44c43bb9:/tmp/asterisk-23.2.2# systemctl status asterisk
● asterisk.service - Asterisk PBX and telephony daemon.
     Loaded: loaded (/etc/systemd/system/asterisk.service; disabled; preset: enabled)
     Active: activating (start) since Wed 2026-02-11 13:37:18 UTC; 1min 11s ago
   Main PID: 112039 (asterisk)
     CGroup: /docker/fa5d44c43bb9d89a76d38efb559244c93ab17a33ea59b58826be951b1770a939/system.slice/asterisk.service
             └─112039 /usr/sbin/asterisk -mqf -C /etc/asterisk/asterisk.conf

Feb 11 13:37:22 fa5d44c43bb9 systemd[1]: asterisk.service: Scheduled restart job, restart counter is at 1.
Feb 11 13:37:22 fa5d44c43bb9 systemd[1]: Starting asterisk.service - Asterisk PBX and telephony daemon....

root@fa5d44c43bb9:/tmp/asterisk-23.2.2# ps aux | grep asterisk
asterisk  112039  1.2  0.2 4896700 83800 ?       Ssl  13:37   0:00 /usr/sbin/asterisk -mqf -C /etc/asterisk/asterisk.conf
root      112118  0.0  0.0   3528  1744 pts/0    S+   13:38   0:00 grep --color=auto asterisk
```

<!-- 今回このスライドを作成するにあたり､dockerコンテナ上ですが､systemctlから実行をしようとしたところshellが戻ってこない現象が発生しました｡確認したところ戻ってこないだけで普通に起動自体はできていますが､心臓に悪いです｡ -->

---

一番わかりやすい解決策として､`/etc/systemd/system/asterisk.service`の`[Service]`セクションの`Type`を`simple`に変更する方法がある

```ini
[Service]
#Type=notify
Type=simple # <-- 完了通知を待たずに起動完了とみなす
```

特に実行ユーザーを`asterisk`に変更している場合､ディレクトリ権限周りなどやることが多すぎるので､テスト用など､とりあえずで動かす場合はユーザー作成せずに`root`で動かすのもあり

<!-- 今回は ServiceセクションのTypeをsimpleに変更したところ想定通りの動作を行いました｡
元々notifyとなっていたのですが､これは完了通知を受け取って初めて完了とみなすという方式です｡ 
この辺はもしかしたらコンテナ内で実行させようとしていたのが原因かもしれません｡-->

<!-- footer: https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html <br> https://docs.redhat.com/ja/documentation/red_hat_enterprise_linux/10/html/using_systemd_unit_files_to_customize_and_optimize_your_system/important-service-section-options -->

---

<!-- header: '' -->

# まとめ

<!-- footer: '' -->

<!-- 最後にまとめというか､rootでとりあえず実行してみたい人向けにコマンドをまとめてみました｡ -->

---

<!-- header: まとめ -->

`root`でも良いのでとりあえずビルドして動かしたい場合は以下のコマンドを順に実行すれば良い

```bash
wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-23-current.tar.gz
tar xzf asterisk-23-current.tar.gz
cd asterisk-23.2.2/
./contrib/scripts/install_prereq install
./configure
# 使用モジュールの選択をしたい場合は以下を実行(任意)
# TUIで操作したい場合
make menuselect
# GUIなしでオプション設定したい場合
make menuselect.makeopts
menuselect/menuselect [有効・無効にするモジュールを選択]  menuselect.makeopts

make
make install
make samples # or make basic-pbx
make config
make install-logrotate
/usr/sbin/asterisk # systemctl start asterisk でもOK
```

<!-- 以上です｡ありがとうございました｡ -->

