```yaml
- hosts: localhost
  connection: local
  vars:
    app_port: 8080
    mode : "production"
  tasks:
    - name: Place config file from 
      template:
        src: sample.conf.j2
        dest: /tmp/sample.conf
        owner: root
        group: root
        mode: '0644'
```

この Playbook がやっていること
- `hosts: localhost` → 自分自身に適用
- `connection: local` → SSH 不要、ローカル実行
- `vars:` → テンプレートに渡す変数
- `template:` モジュールで /tmp/sample.conf を生成

生成されるファイルはこんな感じになります：

```ini
# sample configuration
port = 8080
mode = production
```


🧪 動作確認
```bash
ansible-playbook playbook.yml
cat /tmp/sample.conf
```

これでテンプレートが正しく展開されていれば成功です。

💡 さらに一歩進めたい場合
- 変数を `vars.yml` に分離
- 環境ごとに値を変える
- テンプレート内で条件分岐（`{% if %}`）を使う
- サーバー自身が `Git pull` → `ansible-playbook` を実行する仕組みを作る
こういった拡張も簡単にできます。

---

# inventory.yamlについて

https://zenn.dev/y_mrok/books/ansible-no-tsukaikata/viewer/chapter5

# 構成例

## 例1: 最小構成（グループなし）
```yaml
all:
  hosts:
    server1:
      ansible_host: 192.168.1.10
      ansible_user: root
```

## 例2: グループを使う（childrenの中にグループ名）

```yaml
all:
  children:
    web:
      hosts:
        web1:
          ansible_host: 192.168.1.11
        web2:
          ansible_host: 192.168.1.12
    db:
      hosts:
        db1:
          ansible_host: 192.168.1.21
```

## 例3: あなたの例（childrenの中にtargetグループ）

```yaml
all:
  children:
    target:
      hosts:
        target-server:
          ansible_host: target-server
          ansible_user: root
```

# キー名法則などのメモ

キー名について

- `all`と`children`はAnsibleの予約語なので必須です。
- `target`や`web`、`db`などは自由に決めてOKです（任意のグループ名）。
- `hosts`の下は実際のホスト名（またはエイリアス）です。


# asteriskユーザーでasteriskを常駐させる

`systemctl enable --now asterisk`を実行したときにユーザーが`asterisk`となっていればOK
変更するには`/etc/systemd/asterisk.service`で以下のように設定しないといけない



```bash
/usr/sbin/asterisk -p -U asterisk -G asterisk
```


# 各コンテナーのbashに入る

```bash
docker exec -it ansible-controller bash
```

```bash
docker exec -it target-server bash
```

# roleを使用するには

https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_reuse_roles.html#roles

呼び出し元のplaybookで次のようにする

```yaml
- hosts: target-server
  roles: 
    - ロール名
```

この時呼び出し元のplaybookからみて次のような構造になっている必要がある(`roles_path`がデフォルトの場合)

```md
roles/
  ロール名/
    main.yaml
playbook.yaml
```

