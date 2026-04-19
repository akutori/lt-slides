from pyinfra import host
from pyinfra.operations import files, server, systemd, apt, dnf
from pyinfra.facts.files import File
from pyinfra.facts.server import LinuxDistribution
from project.Classes.Util import Util

def deploy():
    # asteriskのソースコードインストールからビルド、設定ファイルの配置、サービス起動までを行うスクリプト

    distro = host.get_fact(LinuxDistribution)
    id_like = distro.get('release_meta', {}).get('ID_LIKE', '')
    is_debian = 'debian' in id_like
    is_redhat = 'rhel' in id_like

    # systemd連係を行うために必要なパッケージをインストール
    if is_debian:
        apt.packages(
            name="systemd連係に必要なパッケージをインストール (debian系)",
            packages=["libsystemd-dev"],
            update=True,
        )
    elif is_redhat:
        dnf.packages(
            name="systemd連係に必要なパッケージをインストール (redhat系)",
            packages=["systemd-devel"],
            update=True,
        )
    

    # ここではサンプルとして最新のバージョンをダウンロード
    # https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-23-current.tar.gz
    ASTERISK_VERSION = "23-current"

    ASTERISK_DEST_FILE = "/tmp/asterisk.tar.gz"

    ASTERISK_EXTRACTED_DIR = "/tmp/asterisk"

    # https://docs.pyinfra.com/en/3.x/operations/files.html#operations-files-download
    files.download(
        name="Asteriskのソースコードをダウンロード",
        src=f"https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-{ASTERISK_VERSION}.tar.gz",
        dest=ASTERISK_DEST_FILE,
        # 10秒間隔で3回リトライを試みる
        _retries=3,
        _retry_delay=10,
    )

    # rootでプロセスを実行しないようにasterisk用のユーザーとグループを作成
    server.group(
        name="Asterisk用のグループを作成",
        group="asterisk",
        system=True,
        _sudo=True,
    )

    server.user(
        name="Asterisk用のユーザーを作成",
        user="asterisk",
        group="asterisk",
        system=True,
        shell="/sbin/nologin",
        _sudo=True,
    )


    """
    まだ展開されていなければ展開 -> インストールまでを実行
    https://docs.pyinfra.com/en/3.x/facts/files.html#files-facts
    get_fact(チェックするfactの種類(file,directoryなど), チェックするパス)
    """
    if not host.get_fact(File, f"{ASTERISK_EXTRACTED_DIR}/LICENSE"):
        
        # 展開先のディレクトリ名をバージョン依存にしないため
        files.directory(
            name="tar.gzの展開先ディレクトリを作成",
            path=ASTERISK_EXTRACTED_DIR,
            present=True,
        )

        # ソースコードの展開
        server.shell(
            name="Asteriskのソースコードを展開",
            commands=f"tar -xzf {ASTERISK_DEST_FILE} --strip-components=1",
            _chdir=ASTERISK_EXTRACTED_DIR,
        )

        # asteriskのinstall_prereqを実行
        server.shell(
            name="Asteriskのinstall_prereqを実行",
            commands="./contrib/scripts/install_prereq install",
            _chdir=ASTERISK_EXTRACTED_DIR,
            _sudo=True,
        )
        
        # asteriskのビルドとインストール
        server.shell(
            name="Asteriskのビルドとインストール",
            commands=[
                "./configure \
                    --with-jansson-bundled \
                    --with-ssl=ssl \
                    --with-pjproject-bundled \
                    --with-opus",
                "make menuselect.makeopts",
                "menuselect/menuselect \
                    --enable BUILD_NATIVE \
                    --enable CORE-SOUNDS-JA-WAV \
                    --enable MOH-OPSOUND-WAV \
                    --enable codec_opus \
                    --enable res_srtp \
                maknuselect.makeopts",
                "make",
                "make install",
            ],
            _chdir=ASTERISK_EXTRACTED_DIR,
            _sudo=True,
        )
        
        # make samplesでサンプル設定ファイルを配置 + make configでsystemdのサービスファイルを配置
        # make config で配置されたsystemdのサービスファイルを利用するのでユーザーはAsteriskが指定される
        server.shell(
            name="Asteriskのサンプル設定ファイルとsystemdサービスファイルを配置",
            commands=[
                "make samples",
                "make config",
            ],
            _chdir=ASTERISK_EXTRACTED_DIR,
            _sudo=True,
        )
        
        # asteriskが使用するディレクトリの所有権をasteriskユーザーに変更
        
        Util.chown_directories(
            task_name="Asteriskのディレクトリの所有権を変更", 
            user="asterisk", 
            group="asterisk", 
            paths=[
                "/var/lib/asterisk",
                "/var/spool/asterisk",
            ]
        )
        
        
    # asteriskサービスを有効化して起動
    systemd.service(
        name="Asteriskサービスを有効化して起動",
        service="asterisk",
        enabled=True,
        running=True,
        _sudo=True,
    )