from pyinfra import host
from pyinfra.operations import files, server, apt , dnf, postgres
from pyinfra.facts.files import Directory
from pyinfra.facts.server import LinuxDistribution

def deploy():

    # PostgreSQLのバージョン
    POSTGRESQL_VERSION = "16"
    
    # postgresql.conf の設定値
    LISTEN_ADDRESSES = "'*'"  # すべてのアドレスからの接続を許可する例

    # pg_hba.conf の設定値
    LOCAL_NETWORK_CIDER = "0.0.0.0/0"
    
    POSTGRES_PASSWORD = "postgres"
    
    POSTGRESQL_CONF_TEMPLATE = "project/tasks/postgres/templates/postgresql.conf.j2"

    DEBIAN_POSTGRESQL_CONF_PATH = f"/etc/postgresql/{POSTGRESQL_VERSION}/main"
    DEBIAN_POSTGRESQL_DATA_PATH = f"/var/lib/postgresql/{POSTGRESQL_VERSION}/main"
    REDHAT_POSTGRESQL_DATA_PATH = "/var/lib/pgsql/data"
    
    # postgresのインストール
    distro = host.get_fact(LinuxDistribution)
    id_like = distro.get('release_meta', {}).get('ID_LIKE', '')
    is_debian = 'debian' in id_like
    is_redhat = 'rhel' in id_like
    
    if is_debian:
        apt.packages(
            name="PostgreSQLをインストール (debian系)",
            packages=["postgresql"],
            update=True,
        )
            
    elif is_redhat:
        dnf.packages(
            name="PostgreSQLをインストール (redhat系)",
            packages=["postgresql-server"],
            update=True,
        )

        # クラスタがまだ存在していない場合のみ初期化を実行
        if not host.get_fact(Directory, path=REDHAT_POSTGRESQL_DATA_PATH):
        
            # postgresのdb 初期化 (redhat系)
            server.shell(
                name="PostgreSQLのDBを初期化 (redhat系)",
                commands=["postgresql-setup --initdb"],
                _sudo=True,
            )


    # テンプレートから postgresql.conf を配置
    postgresql_conf_path = DEBIAN_POSTGRESQL_CONF_PATH + "/postgresql.conf" if is_debian else REDHAT_POSTGRESQL_DATA_PATH + "/postgresql.conf"
    
    # テンプレートに変数を渡すために実際のデータディレクトリパスを定義
    actual_data_dir = f"'{DEBIAN_POSTGRESQL_DATA_PATH}'" if is_debian else f"'{REDHAT_POSTGRESQL_DATA_PATH}'"

    files.template(
        name="postgresql.conf を配置",
        src=POSTGRESQL_CONF_TEMPLATE,
        dest=postgresql_conf_path,
        user="postgres",
        group="postgres",
        _sudo=True,
        listen_addresses=LISTEN_ADDRESSES,
        data_directory=actual_data_dir,
    )
    
    # テンプレートから pg_hba.conf を配置
    pg_hba_conf_path = DEBIAN_POSTGRESQL_CONF_PATH + "/pg_hba.conf" if is_debian else REDHAT_POSTGRESQL_DATA_PATH + "/pg_hba.conf"
    
    files.template(
        name="pg_hba.conf を配置",
        src="project/tasks/postgres/templates/pg_hba.conf.j2",
        dest=pg_hba_conf_path,
        user="postgres",
        group="postgres",
        _sudo=True,
        local_network_cidr=LOCAL_NETWORK_CIDER,
    )
    
    # PostgreSQLサービスを起動・有効化
    server.service(
        name="PostgreSQLサービスを起動・有効化",
        service="postgresql",   
        enabled=True,
        running=True,
        restarted=True,
        _sudo=True,
    )

    # `restarted`がサービスの完全な起動を待たないため、pg_isreadyで接続準備ができるまで待機する
    server.shell(
        name="PostgreSQLが接続準備完了になるまで待機",
        commands=["until pg_isready -U postgres; do sleep 1; done"],
        _sudo_user="postgres",
    )

    
    # PostgreSQLのデフォルトのpostgresユーザーのパスワードを設定
    postgres.role(
        name="PostgreSQLのpostgresユーザーのパスワードを設定",
        role="postgres",
        password=POSTGRES_PASSWORD,
        _sudo_user="postgres",
    )

    """
    # 以下は postgres.role を使用しない場合のコード。普通にpsqlコマンドを実行するだけ
    
    # OSに基づいてpsqlコマンドを構築する
    if is_debian:
        psql_command = f"psql --cluster {POSTGRESQL_VERSION}/main -U postgres -c \"ALTER USER postgres WITH PASSWORD '{POSTGRES_PASSWORD}';\""
    else: # is_redhat or other
        psql_command = f"psql -U postgres -c \"ALTER USER postgres WITH PASSWORD '{POSTGRES_PASSWORD}';\""    
    
    server.shell(
        name="PostgreSQLのpostgresユーザーのパスワードを設定 (psqlコマンド実行)",
        commands=[psql_command],
        _sudo_user="postgres",
    )
    """