FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    locales python3 neovim openssh-client git sudo curl \
    && locale-gen ja_JP.UTF-8 \
    && update-locale LANG=ja_JP.UTF-8

# 環境変数で指定
ENV LANG=ja_JP.UTF-8


# uv インストール
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    uv tool install pyinfra