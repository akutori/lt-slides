# 概要
ここではpyinfraを使用したubuntu上での環境構築をコンテナー内で行う

[pyinfra getting started](https://docs.pyinfra.com/en/3.x/getting-started.html)

# 詳細

単体のターゲットサーバーに対して次のタスクを行う

1. 日本語環境設定
   1. 言語、タイムゾーンの指定を含む
2. asteriskインストール
   1. ユーザ:asteriskでのasteriskプロセス実行
   2. wgetでソースコードをダウンロードしてからビルド -> インストールまでのすべての作業を実行する
3. postgresqlのインストールとinit
   1. ホストPCからポート`5433`、ユーザ名、パスワード: `postgres`で接続できるまでを確認する
   2. `jdbc:postgresql://localhost:5433/postgres`

# 備考



