from pyinfra.operations import apt, server

def deploy():
    """
    共通の初期設定タスク
    """
    # 日本語ロケールをインストール
    apt.packages(
        name="日本語ロケールパッケージをインストール",
        packages=["language-pack-ja", "locales"],
        update=True,
    )

    server.shell(
        name="日本語ロケールを生成",
        commands=["locale-gen ja_JP.UTF-8"],
        _sudo=True,
    )