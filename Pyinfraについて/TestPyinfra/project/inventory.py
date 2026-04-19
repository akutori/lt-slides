

# デプロイ対象のサーバーリスト
# pyinfra.host.name から参照可能
target_servers = [
    # dockerコンテナ内のsshサーバーに接続する例
    ("target-server",{
        "_sudo": True ,
        "ssh_hostname": "localhost",
        "ssh_user": "root",
        "ssh_password": "root",
        "ssh_port": 2222,
    }),
]

