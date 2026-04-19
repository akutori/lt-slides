了解です。ここまであなたが構築した **Ansible で target コンテナに ping が通るまでの流れ**を、  
誰が読んでも再現できるように **ドキュメント形式で整理**します。  
このまま README として使えるレベルでまとめますね。

---

# 📘 Ansible × Docker 練習環境構築手順（ping 成功まで）

このドキュメントは、Windows 上の Docker Desktop を使い、  
**Ansible コントローラ用コンテナ**と **ターゲット用コンテナ**を構築し、  
Ansible の `ping` モジュールが成功するまでの手順をまとめたものです。

---

# 1. プロジェクト構成

```
project/
├── docker-compose.yml
└── target/
    └── Dockerfile
```

---

# 2. target コンテナ用 Dockerfile を作成

`project/target/Dockerfile`

```Dockerfile
FROM ubuntu:22.04

RUN apt update && \
    apt install -y openssh-server python3 && \
    mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
```

ポイント：
- SSH サーバーをインストール
- root パスワードを `root` に設定
- sshd をフォアグラウンドで起動

---

# 3. docker-compose.yml を作成

`project/docker-compose.yml`

```yaml
version: "3"

services:
  controller:
    image: python:3.11
    container_name: ansible-controller
    volumes:
      - ./project:/project
    working_dir: /project
    command: sleep infinity

  target:
    build: ./target
    container_name: target-server
    ports:
      - "2222:22"
```

ポイント：
- controller は Python ベースで Ansible を後からインストール
- target は SSH で接続できる Ubuntu

---

# 4. コンテナを起動

```
docker compose up -d --build
```

---

# 5. controller コンテナに Ansible をインストール

```
docker exec -it ansible-controller bash
pip install ansible
```

---

# 6. target コンテナに SSH で接続して fingerprint を登録

controller 内で：

```
ssh root@target-server
```

または Windows から：

```
ssh root@localhost -p 2222
```

初回接続時に `yes` を入力して fingerprint を known_hosts に登録。

---

# 7. Ansible の inventory を作成

`project/inventory`

```
[target]
target-server ansible_host=target-server ansible_user=root ansible_password=root
```

yamlの場合

```yaml
all:
  children:
    target:
      hosts:
        target-server:
          ansible_host: target-server
          ansible_user: root
          ansible_password: root
          ansible_python_interpreter: /usr/bin/python3
```

---

# 8. Ansible の接続テスト（ping）

controller 内で：

```bash
ansible -i inventory target -m ping
```

yamlの場合は
```bash
ansible -i inventory.yaml target -m ping
```

成功例：

```
target-server | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

---

# 9. これで Ansible の基本接続が完了

ここまでで、Ansible が target コンテナに SSH 経由で接続し、  
モジュールを実行できる状態になりました。

---

# 📌 補足：よく出る警告

```
[WARNING]: Host 'target-server' is using the discovered Python interpreter...
```

これはターゲット側の Python 自動検出に関する通知で、  
動作には問題ありません。

消したい場合は inventory に追加：

```
ansible_python_interpreter=/usr/bin/python3
```
