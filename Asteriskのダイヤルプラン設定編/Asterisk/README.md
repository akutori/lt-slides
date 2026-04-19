# Docker

初回ビルド時にconfigファイルがないため起動に失敗するのを防止するための初回起動方法

1. `docker-compose.yaml`の`volume`セクションをコメントアウト
2. 設定ファイルをコンテナからホストにコピーする
```bash
# ホスト側にディレクトリ作成
mkdir -p ./config

# コンテナ(asterisk-temp)の /etc/asterisk の中身を、ホストの ./config にコピー
docker cp [コンテナ名]:/etc/asterisk/. ./config/
```

# asterisk 

Asterisk CLIに入る
```bash
asterisk -vvvvvvvvvvr
```

設定反映
```bash
core reload
```

Asterisk 完全再起動
PJSIPの transport（IPアドレスやポートの紐付け設定）は、core reload では完全に書き換えられない
```bash
asterisk -rx "core restart now"
```

ダイヤルプラン一覧表示
```bash
dialplan show
```

内線接続状態一覧
```bash
pjsip show endpoints
```

一時的にtcpdumpで接続を確認する(windows)
```bash
dnf install -y tcpdump
tcpdump -nni any udp port 5060
```

pjsip接続デバッグ有効化
```bash
pjsip set logger on
```

個別の内線の設定を確認
```bash
pjsip show endpoint 内線
```

全通話をすべて切断
```bash
channel request hangup all
```

1つのSessionを切断
`channel request hangup` で Tab を押せば all + 通話中のSession一覧が出てくる

```bash
channel request hangup PJSIP/101-00000022
```

完全なるリセット
```bash
docker compose down -v && docker compose up -d --build
```