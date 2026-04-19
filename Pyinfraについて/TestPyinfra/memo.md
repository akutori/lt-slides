# pyinfra用語解説

- デプロイ
  - Pythonファイルで定義されたインベントリと操作の集合体
  - AnsibleのプレイブックやChefのクックブックのようなもの
- インベントリ
  - ホスト、グループ、データが含まれる構造化されたpythonファイル
  - ホスト: pyinfraが変更を加える対象
    - SSH経由のサーバー
    - Dockerコンテナー
    - ローカルマシン
  - グループ: 1つ以上のホストの集合
    - `_`で始まってはならない
  - データ: グループとホストの両方に割り当てられる変数

# pyinfra インストール

[Installation](https://docs.pyinfra.com/en/3.x/install.html)

```powershell
uv tool pyinfra
```

コード補完を行う

```powershell
uv venv
.\.venv\Scripts\Activate
uv pip install pyinfra
pyinfra --version
```

## アップデート

uvを使う場合

```powershell
.\.venv\Scripts\Activate
uv pip install --upgrade pyinfra
```

# pyinfraデプロイ作成までの流れ

- [Getting Started](https://docs.pyinfra.com/en/3.x/getting-started.html)
- https://acro-engineer.hatenablog.com/entry/2022/12/25/100000

## 1. inventory.py の作成

pyinfraの`inventory.py`はansibleの`inventory.yml`と役割は同じ

カレントディレクトリに配置する

## 2. deploy.py の作成

pyinfraの`deploy.py`はansibleの`playbook.yml`と役割は同じ

これもカレントディレクトリに配置する。(基本的に`deploy.py`と同じ位置にあればOK)

sshで接続する場合は次のページを参照

- https://docs.pyinfra.com/en/3.x/connectors/ssh.html#available-data

### `pyinfra` 実行時の `ModuleNotFoundError` の解決

#### 問題：
プロジェクトのルートディレクトリで `pyinfra project/inventory.py project/deploy.py` を実行すると、`project/deploy.py` 内の `from tasks.asterisk ...` という行で `ModuleNotFoundError` が発生する。

#### 原因：
pyinfra をルートで実行すると、Pythonのモジュール検索パスに project ディレクトリが含まれないため、`project/tasks` のようなサブディレクトリ内のモジュールを直接インポートできない。

#### 解決策：
`project/deploy.py` の先頭に、そのファイル自身の親ディレクトリ (project ディレクトリ) をPythonの検索パスに動的に追加する処理を記述した。

```py
# project/deploy.py の先頭
import sys
import os
sys.path.insert(0, os.path.dirname(__file__))
```

> 補足:
この対応は、本プロジェクトのディレクトリ構造に依存したものです。このコードを削除するとデプロイが失敗するため、変更には注意が必要です。

# 実行

```powershell
pyinfra インベントリファイル デプロイファイル
```

このプロジェクトの場合は

```powershell
pyinfra project/inventory.py project/deploy.py
```

`-vvv`とすることでansible同様に実行状況を確認できる

- `-v`: 失敗した操作の *stdout/stderr* を表示します。
- `-vv`: すべての操作の *stdout/stderr* を表示します。
- `-vvv`: すべての操作の *stdout/stderr* をリアルタイムでストリーミング表示します。これにより、実行中のシェルコマンドの出力が逐一コンソールに表示

実行すると以下のようにインタラクトする必要があるのでスキップする場合は`-y`を指定する

```
pyinfra project/inventory.py project/deploy.py                                                       
--> Loading config...
--> Loading inventory...
--> Connecting to hosts...
    [target-server] Connected

--> Preparing operation files...
    Loading: project/deploy.py
    [target-server] Ready: project/deploy.py

--> Detected changes:
    Operation                                Change              Conditional Change
    Asteriskのソースコードをダウンロード                   1 (target-server)   -
    Asterisk用のグループを作成                        1 (target-server)   -
    Asterisk用のユーザーを作成                        1 (target-server)   -
    tar.gzの展開先ディレクトリを作成                      1 (target-server)   -
    Asteriskのソースコードを展開                       1 (target-server)   -
    Asteriskのinstall_prereqを実行               1 (target-server)   -
    Asteriskのビルドとインストール                      1 (target-server)   -
    Asteriskのサンプル設定ファイルとsystemdサービスファイルを配置   1 (target-server)   -
    Asteriskのディレクトリの所有権を変更                   1 (target-server)   -
    Asteriskのディレクトリの所有権を変更                   1 (target-server)   -
    Asteriskサービスを有効化して起動                     1 (target-server)   -

    Detected changes may not include every change pyinfra will execute.
    Hidden side effects of operations may alter behaviour of future operations,
    this will be shown in the results. The remote state will always be updated
    to reflect the state defined by the input operations.

    Detected changes displayed above, skip this step with -y
    Press enter to execute...
```

## 初回SSH接続

この例では変更ターゲットのサーバーにdockerコンテナーを使用しているので少し勝手が違う

```powershell
ssh root@localhost -p 2222
```

