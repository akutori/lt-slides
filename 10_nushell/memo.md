# memo: nushell

## 前提(想定時間・枚数・ツール・作成日)

- 想定時間: 10分(AkarengaLT 第50回、福岡 Engineer Cafe、2026年10月後半の日曜。発表者 akutori)
- 枚数: 10枚(タイトル1 / 見出し3 / 本文5 / まとめ1)。「ご清聴」スライドなし
- ツール: Marp(コードスライドを使う)。`lt-marp-png` で全10枚をPNG化し、すべて目視した
- 作成日・出典の確認日: 2026-10-09
- 対象バージョン: nushell 0.116.1(2026年10月時点の最新の安定版。2026-10-04公開)
- セリフ: 合計 2296字(スライド別 134 / 39 / 349 / 40 / 341 / 338 / 324 / 38 / 348 / 345)。検査スクリプトで、1文60字以内、読点2つ以内、本文200〜350字、最終行の語尾、行末の「。」、見出しの字数、コードと実行結果の一致を確認した(違反なし)
- 画像・Mermaid: 使っていない(`画像/` と `mermaid/` は空)。キャラクター・ロゴ・既存作品の画像なし
- フロントマターの変更点: コード用フォントの先頭に `DejaVu Sans Mono` を追加した(日本語フォントの明示 `Noto Sans CJK JP` は維持)。理由は、nuの表の罫線文字が `Noto Sans Mono CJK JP` だと幅が合わず、枠がずれたため(作業用の比較PNGで確認)
- ページローカルスタイル `<!-- _style: ... -->`(marp.md の例外2)は使っていない。Marp CLI 4.5.1 / Marp Core 4.4.0 では、この指定がCSSに反映されず、文字列がセリフ(ノート)の先頭行に混入することを、ブラウザなしで確認した。`<style scoped>` はCSSに反映され、ノートにも混入しない。コードがはみ出す担当者への共有事項
- 使った実行ファイルと取得経路: 公式のGitHub Releasesから `nu-0.116.1-x86_64-unknown-linux-gnu.tar.gz` を取得し、専用の新しい空ディレクトリに展開した。github.com のHTML・APIはBashのcurlでは403だった(許可リスト外)。リリース資産は release-download のURLで取得でき、リポジトリの中身は `add_repo`(読み取り)経由のgitで取得した。ほかの経路での回避はしていない

## 構成メモ(スライド番号 / 種別 / 要旨)

| 番号 | 種別 | 要旨 |
| --- | --- | --- |
| 1 | タイトル | 「nushell」のみ。何の話か、前半(公式の説明と実行結果)と後半(向き不向き)の流れ、画面の出力は実行結果そのままであることを伝える |
| 2 | 見出し | nushellとは |
| 3 | 本文(表) | 公式の説明、特徴、実装 / ライセンス、対応OS、最新の安定版(2026年10月時点)、起動コマンド。「構造化データ」を言い換える。読み方は公式記載が見つからなかったと明言する |
| 4 | 見出し | 構造化データとして扱う |
| 5 | 本文(コード) | `ls \| where \| sort-by` の実行結果。`ls \| describe` で、サイズ列が専用の型(filesize)であることを見せる |
| 6 | 本文(コード+箇条書き) | `ps \| where` の実行結果。ls と同じ操作で絞り込める。組み込みと外部(`^`)の違い。優劣ではなくデータの形の違い |
| 7 | 本文(コード) | `open` / `get` / `select` / `to json -r` の実行結果(JSONとCSV)。【差し込み】触ってみた感想 |
| 8 | 見出し | 向き不向き |
| 9 | 本文(箇条書き) | 向き2点と注意4点(POSIX準拠は意図されていない、bash構文、ログインシェル、設計は変わりうる)。【差し込み】実際に使った感想 |
| 10 | まとめ | 5項目(構造化データ、絞り込み・並べ替え、open / get / to json、別の構文、最新の安定版と設計の変化) |

## 出典一覧(URL | 確認日 | 何の裏付けか)

確認日はすべて 2026-10-09。英語の引用は1出典につき1か所・15語未満にとどめ、ほかは言い換え。

| URL | 確認日 | 裏付け |
| --- | --- | --- |
| https://www.nushell.sh/ | 2026-10-09 | スライド3: 見出し「A new type of shell」、対応OS("Nu works on Linux, macOS, BSD, and Windows.")、パイプラインが構造化データを使う旨。スライド9: JSON・YAML・SQLite・Excelなどを扱える旨(公式サイトの記載) |
| https://www.nushell.sh/book/ | 2026-10-09 | スライド3: 序文が、シェルとプログラミング言語を1つにまとめると説明している。実装言語は "Nushell itself is written in Rust."。序文に「1.0に近づく」趣旨の記述(時期の記載なし) |
| https://www.nushell.sh/book/installation.html | 2026-10-09 | スライド3: 実行ファイルは `nu`(Windowsでは `nu.exe`)で、`nu` と入力して起動する。バイナリはLinux・macOS・Windows向けに各リリースで公開される。Homebrewは `brew install nushell` |
| https://github.com/nushell/nushell | 2026-10-09 | README: 説明文 "A new type of shell."、ライセンスはMIT、Statusは "Nu's design is subject to change as it matures."(MVP水準の品質、日常利用者は多いが一部コマンドは不安定の可能性)。スライド3・9・10 |
| https://github.com/nushell/nushell/blob/main/LICENSE | 2026-10-09 | MIT License(Copyright (c) 2019 - 2025 The Nushell Project Developers)。リポジトリのmain(コミット 8ca22347、2026-10-09)で確認 |
| https://github.com/nushell/nushell/blob/main/Cargo.toml | 2026-10-09 | `license = "MIT"`、`description = "A new type of shell"`、バイナリ名 `name = "nu"`。mainの `version` は 0.116.2(未リリースの開発中。スライドでは使わない) |
| https://github.com/nushell/nushell/releases/tag/0.116.1 | 2026-10-09 | 0.116.1が "Latest" で、10月4日公開。`git ls-remote --tags` でも、最新のタグは 0.116.1(その次は0.116.0)。スライド3・10の「最新の安定版」 |
| https://www.nushell.sh/blog/2026-10-04-nushell_v0_116_1.html | 2026-10-09 | "Today, we're releasing version 0.116.1 of Nu." パッチリリースである旨(リリース日の裏付け) |
| https://github.com/nushell/nushell/releases/download/0.116.1/nu-0.116.1-x86_64-unknown-linux-gnu.tar.gz と同じ場所の SHA256SUMS | 2026-10-09 | 動作確認に使った公式バイナリ。SHA256 `d6d8ace4be491ed8abba4026e73b60c0470b4671d7039307e7d772282ef863da` が公式の SHA256SUMS と一致 |
| https://www.nushell.sh/book/quick_tour.html | 2026-10-09 | スライド5・6: `ls` が構造化テーブルを返す("instead of a block of text coming back, you get a structured table")、`sort-by`、`where`、`describe`、`ps` が組み込みで構造化データを返す、`^` を付けると外部の `ps` を実行できる(Unix/Linux)。`ps \| describe` の例の型が、今回の実行結果と同じ |
| https://www.nushell.sh/book/types_of_data.html | 2026-10-09 | スライド5・6: ファイルサイズの専用の型(filesize)。"Specialized numeric type to represent the size of files or a number of bytes" |
| https://www.nushell.sh/book/operators.html | 2026-10-09 | スライド6: `=~` は正規表現の一致 / 文字列の部分一致("regex match / string contains another")。`>` は greater than(より大きい) |
| https://www.nushell.sh/book/loading_data.html | 2026-10-09 | スライド7: `open` はファイルの拡張子に合う `from ...` を使って読み込む。SQLiteは拡張子に関係なく自動判別。対応形式はほかにもある |
| https://www.nushell.sh/book/navigating_structured_data.html | 2026-10-09 | スライド7: セルパス(`server.port` のようなドット区切り)、`get`、`select` |
| https://www.nushell.sh/commands/docs/to_json.html | 2026-10-09 | スライド7: `--raw, -r` は "Remove all of the whitespace and trailing line ending." |
| https://www.nushell.sh/commands/docs/ls.html / ps.html / where.html / sort-by.html / open.html / get.html / select.html / describe.html | 2026-10-09 | コマンドリファレンス。nushell.github.io(HEAD 995f2986、2026-10-05)の `commands/docs/*.md` で各コマンドの存在を確認し、すべて実機でも実行した |
| https://www.nushell.sh/book/thinking_in_nu.html | 2026-10-09 | スライド9: "some Bash (and POSIX in general) style constructs just won't work in Nushell"。bashのリダイレクト `>` はNushellでは比較演算子で、ファイルへの保存は `save`。多くの外部コマンドを、組み込みのクロスプラットフォームなコマンドとして提供する旨 |
| https://www.nushell.sh/book/default_shell.html | 2026-10-09 | スライド9: "Nu is not intended to be POSIX compliant."。ログインシェルにすると、POSIX準拠を前提とするプログラムで予期しない問題が起きうる(警告) |
| https://www.nushell.sh/book/configuration.html | 2026-10-09 | スライド9(補足): ログインシェルの項。NushellはPOSIXシェルではなく、POSIX用のプロファイルは処理できない。`login.nu` に設定する |
| https://www.nushell.sh/book/running_externals.html | 2026-10-09 | スライド6・9: 組み込み("internal")コマンドは、OSをまたいで使える。同名の外部コマンドは `^` を付けて呼ぶ。Windowsでは `ls` がPowerShellのエイリアスなので `^ls` は見つからない |
| https://github.com/nushell/nushell/blob/main/devdocs/PLATFORM_SUPPORT.md | 2026-10-09 | 補足(Q&A用): CIの対象は macOS・Windows(10と11)・Linux。OpenBSD・FreeBSD・Android(Termux)は「passively supported」でCI対象外、`ps` が無い例がある |
| https://www.nushell.sh/book/coming_from_bash.html | 2026-10-09 | 補足(Q&A用): bashからの移行の対応表。スライドでは未使用 |
| https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap01.html | 2026-10-09 | スライド9のセリフ「OSやシェルの標準規格にポジックスがある」の語釈。POSIX.1-2024は、標準のOSインタフェースと環境(コマンドインタプリタ=シェルを含む)を定義する。Nushell公式ではない一次情報 |
| https://man7.org/linux/man-pages/man5/passwd.5.html | 2026-10-09 | スライド9のセリフ「ログイン時に起動するシェル」の語釈。passwd(5)の最終フィールドは "the program to run at login"。Nushell公式ではない |

## ⚠️ 出典なし・未確認の情報

- 読み方(発音): The Nushell Book、READMEの全文、公式サイト、ブログのいずれにも、発音の記載が見つからなかった(Web検索でも見つからず)。セリフでは断定せず、「公式に記載が見つかりませんでした。この発表では、ニューシェルと読みます。」と言う
- BSDの扱いに温度差がある: 公式サイトは "BSD" で動くと書くが、PLATFORM_SUPPORT.md ではOpenBSD・FreeBSDは「passively supported」(CI対象外。`ps` が無い例あり)。スライド3は公式サイトの記載どおり。スライド9は、個別コマンドを挙げず「組み込みコマンドは、OSをまたいで使える(公式の説明)」と、公式の説明であることを明示した
- スライド5の最初のコマンド `ls | where type == file and size > 1kb | sort-by size` は、公式のクイックツアー(`ls | where size > 10kb`、`ls | sort-by size`)を参考に、ダミー環境用に条件を足した自作の例。公式の例そのものではない
- `modified` 列の相対表記(「a day ago」など)は、実行日(2026-10-09)基準。更新日時はダミーファイルに `touch` で設定した値。発表日に再実行すると表示が変わる
- `ps` の pid(357、358)、ppid(347)、メモリ量(1.6 MB など)は、実行環境の固有値。再実行すると変わる
- 「まだ1.0より前」は、バージョン番号(0.116.1)、READMEのStatus、Book序文の「1.0に近づく」記述からの読み取り。公式が1.0の時期を述べた記載は見つからなかった
- mainブランチのCargo.tomlは version 0.116.2(未リリースの開発中)。発表日までに0.116.2が出る可能性があるため、発表前にReleasesを再確認する
- 「ログイン時に起動するシェル」(ログインシェルの言い換え)と「OSやシェルの標準規格」(POSIXの言い換え)は、Nushell公式ではなく、passwd(5)とThe Open Groupの記述に基づく補足
- YAML・SQLite・Excelの読み込みは未実行。スライド9には「(公式サイトの記載)」と明示した
- macOS・Windows・BSDでの実行は未実行(実行環境はLinuxのみ)
- 発表者の使用経験は不明のため、感想は差し込み欄にした(経験の創作なし)

## 差し込み欄(スライド番号 | 何を入れるか)

| スライド | スライド上の表記 | セリフ上の表記 | 何を入れるか |
| --- | --- | --- | --- |
| 7 | 【差し込み: 触ってみた感想(試した場面、困った点など)】 | (※ここで実体験を話す: 触ってみた感想について) | 実際に触ってみた感想。試した場面や、困った点 |
| 9 | 【差し込み: 実際に使った感想(使っていなければ、試していない旨)】 | (※ここで実体験を話す: 実際に使った感想について) | 実際に使った感想。使っていなければ「試していない」と言う |

2か所とも、差し込みがなくても、前後の事実の部分で話は通る。

## 動作確認(実行したもの / 未実行とその理由 / バージョン / 環境)

- バージョン: nu 0.116.1(`nu --version`)。`version` の結果は build_os が linux-x86_64、rust_version が rustc 1.96.1
- 環境: Ubuntu 24.04.5 LTS(Linux 6.18.44、x86_64)のサンドボックス。Marp CLI 4.5.1(Marp Core 4.4.0)
- 実行方法: 公式バイナリを専用の空ディレクトリに展開。`nu --no-config-file -c "<コマンド>"` で1コマンドずつ実行。設定・データ・キャッシュの置き場(XDG)は作業用ディレクトリに隔離し、`NO_COLOR=1`。ダミーのディレクトリ(`config.json`、`servers.csv`、`README.md`、`notes.txt`、`app.log`、`backup.tar.gz`、`build.sh`、`src/`、`logs/`。中身は架空。ホストは文書用予約アドレス 192.0.2.10 でスライドには出さない)で実行した。`ps` は、`/bin/sleep` を `demo-job-a`・`demo-job-b` の名前で2つ起動して絞り込み、取得後に停止した
- スライドに載せたコマンドと出力(すべて実際の出力を、そのまま載せた。検査スクリプトで一致を確認):
  - `ls | where type == file and size > 1kb | sort-by size`(スライド5)
  - `ls | describe` → `table<name: string, type: string, size: filesize, modified: datetime> (stream)`(スライド5)
  - `ps | where name =~ demo-job`(スライド6)
  - `open config.json | get server.port` → `8080`(スライド7)
  - `open servers.csv | where cpu > 70 | select host cpu`(スライド7)
  - `open servers.csv | where cpu > 70 | select host cpu | to json -r` → `[{"host":"web-02","cpu":77},{"host":"batch-01","cpu":91}]`(スライド7)
- スライドに載せていないが実行したもの(セリフや要約の裏付け):
  - `ps | describe` → `table<pid: int, ppid: int, name: string, status: string, cpu: float, mem: filesize, virtual: filesize> (stream)`(セリフ「メモリの列は、サイズと同じ型」。公式クイックツアーの例と同じ型)
  - `open servers.csv | describe` → `table<host: string, role: string, cpu: int> (stream)`(セリフ「CPUの列は、数値として読み込まれている」)
  - `4 > 10` → `false`(bashの `>` との違い。Bookと同じ結果)
  - `which ps`、`which ls` → どちらも `built-in`
  - `ps | sort-by mem | length | $in > 0` → `true`(要約の「ps の出力を並べ替えできる」)
  - `^ps -o pid=,comm= -p 1` → 外部の ps(procps-ng 4.0.4)が実行され、`describe` の結果は `byte stream`(表ではなく文字列)
  - `ls`、`open config.json`、`open servers.csv`、`ls | where type == dir`
- 未実行: macOS・Windows・BSDでの実行(Linuxの実行環境のみ)。YAML・SQLite・Excelの読み込み(公式サイトの記載のみ)。ログインシェルとして使う操作(公式ドキュメントの記載のみ)
- 実行結果の保存先(作業用): SCR/work/10_nushell/out/(c01〜c20)。出力ディレクトリには置いていない

## 読み方メモ(語 | 採用する読み | 根拠)

| 語 | 採用する読み | 根拠 |
| --- | --- | --- |
| nushell | ニューシェル | 公式記載なし。慣用として「ニューシェル」。セリフでは「公式に記載が見つかりませんでした」と明言し、断定しない。別の読みを使う場合は、セリフの「ニューシェル」を置き換える(文頭には置いていない) |
| nu / Nu | ニュー | 公式記載なし。慣用として。セリフは「起動するコマンドは、ニューです」と、カナで統一 |
| JSON | ジェイソン | 一般的な読み。セリフはカナで統一(スライドは「JSON」) |
| CSV | シーエスブイ | 文字読み。セリフは「CSV」と書く |
| POSIX | ポジックス | 一般的な読み。セリフはカナで統一(スライドは「POSIX」) |
| bash | バッシュ | 一般的な読み。セリフは「bash」と書く |
| ^(`^ps` など) | キャレット | Bookが "caret sigil" と呼ぶ。日本語はカナ |
| > | 大なり記号 | 一般的な読み。「より大きい」の記号 |
| =~ | 読まない | セリフは「正規表現の一致」と言い換え |
| ls / ps | ファイル一覧 / プロセス一覧 | コマンド名は読まず、「ファイル一覧のコマンド」と言う。「従来のps」だけ「ピーエス」と読む |
| Rust / MIT / OS / CPU / README | ラスト / エムアイティー / オーエス / シーピーユー / リードミー | 一般的な読み |

## 言い換え表(言いにくい語 | 言い換え候補)

| 言いにくい語 | 言い換え候補 |
| --- | --- |
| ニューシェル(nushell) | このシェル / 新しい種類のシェル |
| 構造化データ | 表のようなデータ / 列や項目を持つデータ |
| 組み込みコマンド | シェルに入っているコマンド / 標準のコマンド |
| 外部コマンド・従来のコマンド | 別のプログラムのコマンド / これまでのコマンド |
| 正規表現の一致 | 文字のパターンの一致 / 含まれているか |
| プロセス | 動いているプログラム |
| ポジックス(POSIX) | 標準規格 / UNIX系の標準 |
| 準拠 | 合わせる / そろえる |
| ログイン時に起動するシェル(ログインシェル) | 最初に動くシェル |
| 演算子 / 大なり記号 | 比べる記号 / 「より大きい」の記号 |
| キャレット(^) | 山形の記号 / 頭に付ける記号 |
| 拡張子 | ファイル名の末尾 |
| ライセンス | 利用条件 |
| 安定版 | 正式なリリース / 最新のリリース |
| リリースページ | 配布ページ |
| 実行ファイル | プログラム本体 |
| ジェイソン(JSON) | データの形式 / データのファイル |

## 質問されそうな点(3〜5個、答えと出典つき)

1. bashやzshの代わりに常用できるか
   - 答え: 公式は「POSIX準拠を意図していない」と明記し、bashの構文の一部は動かない。ログインシェルにすると、POSIX前提のプログラムで予期しない問題が起きうる。READMEは、日常的に使う人は多いが、一部のコマンドは不安定の可能性があり、設計は変わりうると書く。優劣ではなく用途の違いとして答える
   - 出典: https://www.nushell.sh/book/default_shell.html / https://www.nushell.sh/book/thinking_in_nu.html / https://github.com/nushell/nushell(README の Status)
2. WindowsやmacOSでも動くか
   - 答え: 公式サイトはLinux、macOS、BSD、Windowsで動くと書く。公式のCIの対象はmacOS、Windows、Linux。OpenBSDとFreeBSDはCI対象外で、`ps` が無いなど未提供の機能がある。今回の実行確認はLinux(x86_64)のみ
   - 出典: https://www.nushell.sh/ / https://github.com/nushell/nushell/blob/main/devdocs/PLATFORM_SUPPORT.md
3. どうやって入れるか
   - 答え: 公式のバイナリ(Linux・macOS・Windows)をリリースページから取得して展開するか、パッケージマネージャ、またはソースからのビルド。macOS・LinuxではHomebrewの `brew install nushell` も案内されている。実行ファイルは `nu`。今回は公式バイナリを使い、SHA256を公式のSHA256SUMSと照合した
   - 出典: https://www.nushell.sh/book/installation.html / https://github.com/nushell/nushell/releases/tag/0.116.1
4. JSONを扱うのに、jqやcurlは要らなくなるか
   - 答え: Bookは、ある例で「組み込みの `http get` がJSONをネイティブに扱うため、curlとjqは要らない」と書く。すべてを置き換えるとは書いていない。今回の実行では、`open` でJSONとCSVを開き、`get` と `select` で取り出し、`to json -r` で変換できることを確認した
   - 出典: https://www.nushell.sh/book/thinking_in_nu.html / https://www.nushell.sh/book/loading_data.html
5. 従来の `ps` や `ls`(外部コマンド)は使えなくなるのか
   - 答え: 使える。先頭に `^` を付けると外部コマンドを呼べる。今回、`^ps` で外部のpsが呼ばれ、結果は表ではなく文字列(byte stream)だった。ただしWindowsでは、`ls` がPowerShellのエイリアスのため `^ls` は見つからない
   - 出典: https://www.nushell.sh/book/quick_tour.html / https://www.nushell.sh/book/running_externals.html
