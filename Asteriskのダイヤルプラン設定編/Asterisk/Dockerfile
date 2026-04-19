FROM rockylinux:9

# 1. 最小限のプラグインとリポジトリ設定
RUN dnf -y update && \
    dnf -y install dnf-plugins-core epel-release && \
    dnf config-manager --set-enabled crb

# 2. 開発ツールと依存パッケージのインストール
# CRBリポジトリは上で有効化していますが、念の為明示もしつつ必要なパッケージを入れます
RUN dnf -y groupinstall "Development Tools" && \
    dnf -y --enablerepo=crb install \
        wget \
        vim \
        net-tools \
        sqlite-devel \
        libedit-devel \
        libxml2-devel \
        jansson-devel \
        openssl-devel \
        ncurses-devel \
        libuuid-devel \
        newt-devel \
        libsrtp-devel \
        opus-devel \
        libtool \
        make \
        patch \
        subversion \
        bzip2 \
        python3-devel && \
    dnf clean all

# 3. Asteriskソースの取得とビルド
WORKDIR /usr/src
RUN wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-23-current.tar.gz && \
    tar zxvf asterisk-23-current.tar.gz && \
    cd asterisk-23.*/ && \
    # 足りない依存関係を自動解決するスクリプト(64bit指定)
    # ※ 事前にdnf installしているので、ここは不足分だけの補完として安全に動作します
    ./contrib/scripts/install_prereq install --libdir=/usr/lib64 && \
    ./configure \
        --with-jansson-bundled \
        --with-pjproject-bundled \
        --with-ssl=ssl \
        --with-srtp \
        --with-opus \
        --libdir=/usr/lib64 \
    && \
    make menuselect.makeopts && \
    menuselect/menuselect \ 
        --disable BUILD_NATIVE \ 
        --enable CORE-SOUNDS-JA-WAV \
        --enable MOH-OPSOUND-WAV \
        --enable codec_opus \
        --enable res_srtp \
        --enable func_curl \
        --enable func_rand \
    menuselect.makeopts && \
    make && \
    make install && \
    make basic-pbx && \
    ldconfig && \
    # 生成された設定フォルダをバックアップとしてリネーム保存
    mv /etc/asterisk /etc/asterisk.dist && \
    # マウントポイント用に空のディレクトリを作っておく
    mkdir /etc/asterisk

# entrypointスクリプトをコピーして権限付与
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# ENTRYPOINTを設定
ENTRYPOINT ["/docker-entrypoint.sh"]

# CMDはそのまま引数として entrypoint.sh の "$@" に渡される
CMD ["/usr/sbin/asterisk", "-f", "-vvvg"]