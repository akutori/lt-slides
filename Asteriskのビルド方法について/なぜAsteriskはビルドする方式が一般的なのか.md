---
marp: true
paginate: true

---

# なぜAsteriskはビルドする方式が一般的なのか?

---

# はじめに

---

<!-- header: はじめに -->

IP-PBXであるAsteriskを導入するにあたり、
Asteriskはソースコードからビルドする方式が一般的です

今回は､なぜAsteriskはビルドする方式が一般的なのかについて説明します

---


<!-- header: '' -->

# 結論

---

<!-- header: 結論 -->

**Debian系OSで､`apt install asterisk`** が一番最速

---

<!-- header: '' -->

# apt install する場合

---

<!-- header: apt install する場合 -->

Debian系OSであれば､`apt install asterisk`でAsteriskをインストールできます｡

Ubuntu 24.04.3 LTS のdockerイメージを利用して確認した例

```bash
root@357638f2232b:/# apt search asterisk
Sorting... Done
Full Text Search... Done
asterisk/noble 1:20.6.0~dfsg+~cs6.13.40431414-2build5 amd64
  Open Source Private Branch Exchange (PBX)
```

最新LTS(22.8.1)より少し古いバージョン(20.6.0)がインストールされる

---

Asteriskの基本機能を構成するために必要な最小限のパッケージ群はすべて揃っている

```bash
root@357638f2232b:/# apt-cache depends asterisk
asterisk
  PreDepends: init-system-helpers
  Depends: adduser
 |Depends: asterisk-config
  Depends: <asterisk-config-custom>
  Depends: asterisk-core-sounds-en
  Depends: asterisk-modules
  Depends: libc6
  Depends: libcap2
  Depends: libcrypt1
  Depends: libedit2
  Depends: libjansson4
  Depends: libpopt0
  Depends: libsqlite3-0
  Depends: libssl3t64
  Depends: libsystemd0
  Depends: liburiparser1
  Depends: libuuid1
  Depends: libxml2
  Depends: libxslt1.1
  Recommends: asterisk-moh-opsound-gsm
  Recommends: sox
  Suggests: asterisk-dahdi
  Suggests: asterisk-dev
  Suggests: asterisk-doc
  Suggests: asterisk-ooh323
  Suggests: <asterisk-opus>
```

---

どこが管理しているかを`apt show asterisk`で確認する(一部省略)

```bash
Package: asterisk
Version: 1:20.6.0~dfsg+~cs6.13.40431414-2build5
Priority: optional
Section: universe/comm
Origin: Ubuntu
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Original-Maintainer: Debian VoIP Team <pkg-voip-maintainers@lists.alioth.debian.org>
Bugs: https://bugs.launchpad.net/ubuntu/+filebug
...
Recommends: asterisk-moh-opsound-gsm, sox
Suggests: asterisk-dahdi, asterisk-dev, asterisk-doc, asterisk-ooh323, asterisk-opus
Homepage: https://www.asterisk.org/
Download-Size: 2601 kB
APT-Sources: http://archive.ubuntu.com/ubuntu noble/universe amd64 Packages
Description: Open Source Private Branch Exchange (PBX)
```
`Origin: Ubuntu`となっているが､これは **Ubuntu の公式リポジトリから提供されている** という意味

---

URLを確認してみると､Debianのパッケージ管理ページに飛ぶ｡
https://qa.debian.org/developer.php?login=pkg-voip-maintainers%40lists.alioth.debian.org

![](images\DebianVoIPTeamパッケージ一覧.png)

きっちり22系までサポートされていることがわかる｡

---

実際に`apt install asterisk`でインストールしてみる｡

```bash
Adding system user for Asterisk
info: Adding user `asterisk' to group `dialout' ...
info: Adding user `asterisk' to group `audio' ...
invoke-rc.d: could not determine current runlevel
invoke-rc.d: policy-rc.d denied execution of start.
Processing triggers for libc-bin (2.39-0ubuntu8.6) ...
Processing triggers for ca-certificates (20240203) ...
Updating certificates in /etc/ssl/certs...
0 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
```

asteriskユーザの追加など､必要な初期設定も自動で行われる
`systemctl enable --now asterisk`でAsteriskを有効化&起動できる

---

<!-- header: '' -->

# なぜビルドする方式が一般的なのか?

---

<!-- header: なぜビルドする方式が一般的なのか? -->

`apt install asterisk`でAsteriskをインストールできるにもかかわらず､ソースコードからビルドする方式がよく採用されているのかについては理由がある｡

次のページではその理由について説明

---

<!-- header: なぜビルドする方式が一般的なのか? -->

## 理由1: 日本問題

Asteriskの日本語対応は､標準では不十分
apt install する場合依存として`asterisk-core-sounds-en`がインストールされる

`asterisk-core-sounds-[国名]`
はガイダンスやIVRで利用される音声ファイルセットの英語版

(おそらく使う機会はそうないと思うが)日本語音声を利用するには音声ファイルを別途インストールする必要がある

- URL: https://downloads.asterisk.org/pub/telephony/sounds/releases/


---

## 理由2: そもそもパッケージが用意されていない

**Rocky Linux**や**AlmaLinux**などの**RHEL系OS**では､**Asteriskのパッケージが用意されていない**

そのため､RHEL系OSでAsteriskを利用する場合は､ソースコードからビルドする必要がある

Rocky 10のasteriskのインストールガイド: 
https://docs.rockylinux.org/10/ja/guides/communications/asterisk_installation/

---

## 理由3: カスタマイズ性

Asteriskの設定をDBで管理する方式を採用する場合
**ARA(Asterisk Realtime Architecture)** を利用する必要がある

パッケージインストールでもARAを利用するためのモジュールは読み込まれるが､**ARAを利用するためのテーブルは自動で作成されない**

公式のtarballには**alembic**というSQLAlchemyベースのマイグレーションツールのための設定ファイルが同梱されており､ARA用のテーブルを自動で作成できる

基本的にパッケージインストールの場合､ほとんどのものは用意されているが､**細かいカスタマイズを行う場合はソースコードからビルドする必要がある**ケースが多い

---

## 理由4: 塩漬け

基本的に**電話系のシステムは長期間稼働し続けることが多い**ため､OSのサポート期間が終了(EOL: End Of Life)した後もシステムを稼働し続けるケースが多い｡

そのためEOLになったOSで稼働しているシステムのリプレースを行うという場合開発環境の再現が必要になるケースでパッケージマネージャ経由でのインストールが難しい場合がある


