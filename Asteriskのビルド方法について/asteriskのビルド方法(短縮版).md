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

<!-- 今回はIP-PBXである｡Asteriskのビルド方法について説明します｡ -->
<!-- 専用ユーザーで実行するちょっと実務寄りの構成です。 -->
<!-- ちなみにですがDebian系は「apt install asterisk」でインストールしたほうが正直楽です-->

---

Asteriskインストールの手順は組織や利用目的､環境によって大きく異なるため､公式を参考にしてください

https://docs.asterisk.org/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/

<!-- Asteriskのインストール方法は利用する組織､ネットワーク､利用方法やOSなどによって大きく変わるため､できる限り公式やコミュニティを参考にしてください｡ -->

---

<!-- header: '' -->

# まとめ

<!-- footer: '' -->

<!-- いきなり まとめというか､rootでとりあえず実行してみたい人向けにコマンドをまとめてみました｡ -->

---

<!-- header: まとめ -->

`root`でも良いのでとりあえずビルドして動かしたい場合は以下のコマンドを順に実行すれば使える

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
/usr/sbin/asterisk # or systemctl start asterisk
```

<!-- とりあえずrootでもOKならこの手順で終わりです｡ -->
<!-- これ以降はこの手順たちをある程度詳しく説明します｡ -->

---

<!-- header: '' -->

# Asteriskを実行するためのユーザーとグループを作成する

<!-- まず初めにAsteriskを実行するためのユーザーとグループを作成します -->

---

<!-- header: Asteriskを実行するためのユーザーとグループを作成する -->

Asteriskは専用のユーザーとグループで実行することが推奨されているため､事前に作成しておく

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

<!-- Asteriskに限らずだとは思いますが､基本的にrootユーザーではなく専用のユーザーを作成｡それを利用して実行する方式が推奨されています｡ -->
<!-- ユーザー作成ですが､システムユーザーとして作成してください｡普通のユーザーとして作成しても問題ありません｡  -->

<!-- footer: https://www.jpcert.or.jp/at/2010/at100032.html <br> https://www.voip-info.jp/index.php/Asterisk_SIP_%E3%82%BB%E3%82%AD%E3%83%A5%E3%83%AA%E3%83%86%E3%82%A3 -->

---

<!-- header: '' -->
<!-- footer: '' -->

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
   1. *prereq* = *prerequisite*(プリレクイジット: 「前提条件」・「事前に必要なもの」)

<!-- Asteriskを実行させるためには大量の依存ライブラリが必要であり､それを解決するための方法として2つあります -->

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

<!-- 一般的に個別でライブラリを追加していくのが一般的ですが､推奨するのは install_prereq(プリレクイジット) スクリプトを利用する方法です｡ 
基本的にこれを実行するとモジュールがほとんど選択できるようになります｡
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
最近よく指定されるのが「with-jansson-bundled」です｡ 
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

<!-- 実はこれをせずにビルドしてしまっても問題はないです｡
しかし､用途によって特定のモジュールの有効化などを行うことがあるためその時にはmenuselectで選択する必要があります｡ -->

---


Asteriskには多くのモジュールがあり､用途に応じて必要なモジュールをビルド前に選択する
`make menuselect`コマンドを実行すると､モジュール選択画面(TUI)が表示される

![w:900](images/make%20menuselect.png)

<!-- make menuselect を実行するとモジュール選択画面がTUIで表示されます｡なかなか洒落ている -->

---

## TUIを使わない場合

例えばIaCなどでAsteriskをビルドする場合､TUIを使わずに必要なモジュールを有効化/無効化したい場合がある

`make menuselect.makeopts`を使用してTUIを呼び出さずにモジュールの選択ができる

https://docs.asterisk.org/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Using-Menuselect-to-Select-Asterisk-Options/#controlling-menuselect

<!-- すでにルーチン化の手順を確立している場合は make menuselect.makeopts を使用してTUIを呼び出さずにモジュール選択ができます｡
これの利用用途としてはDockerやIaCなどでAsteriskをビルドする場合です｡ -->

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

<!-- make install 後 設定ファイルがない場合は動かすことができません｡
すでに準備している設定ファイルを配置するか､持っていない場合などは設定ファイルを作成する必要があります｡

make samples はプレーンな設定ファイルを配置します｡
make basic-pbx は pbxとして直ぐに使用ができるようなサンプル設定を配置します｡とりあえずすぐに動かしてみたい! といった場合はこちらを使用してください｡
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
systemdユニットファイルを使用する場合は､ソース内のユニットファイルを /etc/systemd/system にコピーしてください -->

---

`make install-logrotate`コマンドを実行すると､Asteriskのログローテーション設定ファイルが配置される

`/etc/logrotate.d/asterisk`が作成される

https://github.com/asterisk/asterisk/blob/master/contrib/scripts/asterisk.logrotate

<!-- logrotateについても設定ファイルは用意されています｡
Asteriskは超膨大なログを吐き出しつづけることが多いです｡
できればログローテーションの設定ファイルも作成しておきましょう｡ -->

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

## systemdサービスとして起動する場合

サービスとして起動する場合､systemdユニットファイル内で実行ユーザーとグループを指定する

`/etc/systemd/system/asterisk.service`を編集して以下の行があることを確認する

```ini
[Service]
User=asterisk
Group=asterisk
Type=simple # ← 完了通知を待たずに起動完了とみなす(サービス実行時shellが戻ってこなければ)
```

その後に実行させればAsteriskは`asterisk`ユーザーとグループで実行される**はず**
```bash
systemctl daemon-reload
systemctl enable --now asterisk
systemctl status asterisk
```

<!-- systemdのサービスとして起動させるにはまずユーザーとグループにasteriskが指定されていることを確認してください｡
確認といったのは元々のユニットファイルがこのようにすでにasteriskユーザーを定義しているためです｡
その後にsystemctlを使って起動してやれば問題なく実行される「はず」です｡ -->

<!-- 終わりです｡ -->

