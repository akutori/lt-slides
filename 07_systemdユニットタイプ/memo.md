# memo: systemdユニットタイプ

## 前提(想定時間・枚数・ツール・作成日)

- イベント: AkarengaLT 第50回(福岡 Engineer Cafe、2026年10月後半の日曜)
- 持ち時間: 10分
- 枚数: 10枚(タイトル1 / 見出し3 / 本文5 / まとめ1)
- ツール: Marp(フロントマターで Noto Sans CJK JP を明示)
- 作成日・出典確認日: 2026-10-09
- スライド: `systemdユニットタイプ.md`(セリフは HTML コメントで同梱)
- セリフ文字数: 2325字(差し込みのセリフ2行 79字を除く。含めると 2404字)
  - 内訳: 1枚目 139 / 2枚目 40 / 3枚目 338 / 4枚目 350 / 5枚目 40 / 6枚目 344 / 7枚目 349 / 8枚目 38 / 9枚目 349 / 10枚目 338
  - 本文スライドは各 350字以内(SKILL.md の目安 200〜350字)
- 画像/・mermaid/ は、画像・図を使っていないため作っていない
- preview/ は PNG 確認用(統括が確認後に削除)

## 構成メモ(スライド番号 / 種別 / 要旨)

| # | 種別 | 要旨 |
|---|---|---|
| 1 | タイトル | systemdユニットタイプ(タイトルのみ。セリフでテーマ・ユニットの意味・流れを話す) |
| 2 | 見出し | serviceだけではない(発表者の思い込みの話。シードの経験のみ使用) |
| 3 | 本文 | ユニットのタイプは11種類(`systemctl -t help` の実出力)。service の `WantedBy=multi-user.target` も target の指定。差し込み① |
| 4 | 本文 | クラウドのたとえ表(timer / socket / path / slice・scope)。「同じものではない」を表の見出しとセリフで明記。socket は service を起動するだけで関数の実行環境は用意しない、をセリフで1か所触れる |
| 5 | 見出し | 起動のきっかけを変える |
| 6 | 本文 | timer。fstrim.timer の実ファイル抜粋。同名の service を起動 / `Persistent=true` / `OnCalendar=` のタイマーのみ有効 / cron は常時稼働が前提(anacron の man page) |
| 7 | 本文 | socket と path。socket の条件(systemd からソケットを受け取れること)、path の制約(NFS の他マシンの変更は見えない、起動回数の上限超過で監視停止)。docker.socket の実ファイル抜粋 |
| 8 | 見出し | 新しい機能: IMDS |
| 9 | 本文 | IMDS。v261(2026年6月)で追加、SMBIOS の情報から全9種のクラウドを判別、systemd-imdsd の入口は socket ユニット(v261 のソース抜粋)。2026年10月時点の最新は v262。IMDS は未実行と明記 |
| 10 | まとめ | 4項目(11種類 / timer・socket・path / slice・scope / IMDS)。差し込み② |

シードからの変更点:
- シードの「v261 が最新」は誤り。2026年10月時点の最新は v262(2026/09/22)
- シードの path ユニットの制約のうち、「サブディレクトリを再帰的に監視できない」「更新が高頻度だと取りこぼす可能性」は man page に記載がないため削除(下記 ⚠️ 参照)
- シードの target / mount / automount のクラウドのたとえ(デプロイのステージ分けなど)は、根拠が弱いため表から外した。target は「ユニットをまとめる種類」として3枚目で扱う
- v260(SysV スクリプト削除)・v258(cgroup v1 削除)は NEWS で確認できたが、10分に収まらないためスライドには使っていない(質問用に下記へ記載)

## 出典一覧(URL | 確認日 | 何の裏付けか)

freedesktop.org のページは、この環境から取得できなかった(curl は proxy が 403、WebFetch もエラー)。同じページの元 XML を GitHub の systemd/systemd v262 タグで読んで内容を確認した(`https://github.com/systemd/systemd/blob/v262/man/<名前>.xml`)。footer の freedesktop.org の URL は、公式 man page の latest の URL。

| URL | 確認日 | 何の裏付けか |
|---|---|---|
| https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html | 2026-10-09 | ユニットタイプは service / socket / device / mount / automount / swap / target / path / timer / slice / scope の11種類(冒頭の書式一覧と Description)。2026年10月時点の最新は v262 の元XMLで確認 |
| https://www.freedesktop.org/software/systemd/man/latest/systemctl.html | 2026-10-09 | `-t` / `--type=` に `help` を渡すと、指定できる値の一覧を出して終了する |
| https://www.freedesktop.org/software/systemd/man/latest/systemd.special.html | 2026-10-09 | multi-user.target は、マルチユーザー用のシステム(非グラフィカル)を立ち上げるための特別な target。ユニットの [Install] セクションの `WantedBy=multi-user.target` で設定するのが良い、との記載(スライド3の2つ目の箇条書き) |
| https://www.freedesktop.org/software/systemd/man/latest/systemd.target.html | 2026-10-09 | target はユニットをまとめ、順序依存の同期点を作るためのもの |
| https://www.freedesktop.org/software/systemd/man/latest/systemd.resource-control.html | 2026-10-09 | slice / scope などのリソース制御は、Linux の cgroups を内部で使う |
| https://www.freedesktop.org/software/systemd/man/latest/systemd.slice.html | 2026-10-09 | (footer 外・補足)slice はプロセス群のリソースを階層的に管理する。cgroup のツリーにノードを作る |
| https://www.freedesktop.org/software/systemd/man/latest/systemd.scope.html | 2026-10-09 | (footer 外・補足)scope は外部で作られたプロセスの集合を管理する。プログラムから作る |
| https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html | 2026-10-09 | timer は同名の service を既定で起動する。`Persistent=`(停止中に逃した実行を取り戻す。`OnCalendar=` のタイマーにのみ効く。既定は false)。`AccuracySec=`(既定 1min)、`RandomizedDelaySec=` |
| https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html | 2026-10-09 | `weekly` は `Mon *-*-* 00:00:00` と等価 |
| https://www.freedesktop.org/software/systemd/man/latest/systemd.socket.html | 2026-10-09 | socket ユニットに対応する service は、ソケットへの通信(incoming traffic)が来たときに起動する(スライドでは「接続が来たとき」と簡略化)。オンデマンド起動に使える。起動される側は systemd からソケットを受け取れる必要がある(sd_listen_fds または inetd 形式) |
| https://www.freedesktop.org/software/systemd/man/latest/systemd.path.html | 2026-10-09 | path は inotify を使う。NFS 上で他のマシンが行った変更は監視できない。`TriggerLimitIntervalSec=`(既定 2s)と `TriggerLimitBurst=`(既定 200)を超えると失敗状態になり、再起動まで監視しない |
| https://github.com/systemd/systemd/blob/v262/NEWS | 2026-10-09 | IMDS の新サブシステム(v261)。hwdb の9クラウド、systemd-imdsd、systemd-imds-generator、「truly generic images」の文。v260 の SysV 削除、v258 の cgroup v1 削除、IMDS ネットワークの locked と cloud-init の競合 |
| https://github.com/systemd/systemd/blob/v262/hwdb.d/40-imds.hwdb | 2026-10-09 | 認識するクラウドは9社(Amazon EC2 / Azure / Google Compute Engine / Hetzner / Oracle Cloud / Scaleway / Tencent Cloud / Alibaba / Vultr)。v261 と v262 でファイルは同一(diff で確認)。IMDS_KEY_HOSTNAME / IMDS_KEY_REGION などのキー定義 |
| https://github.com/systemd/systemd/blob/v261/units/systemd-imdsd.socket | 2026-10-09 | `ListenStream=/run/systemd/io.systemd.InstanceMetadata`(スライドの抜粋。v262 も同じ行) |
| https://github.com/systemd/systemd/blob/v262/man/systemd-imdsd@.service.xml | 2026-10-09 | (footer 外・補足)systemd-imdsd.socket が man に載っていること。`systemd.imds.network=` は unlocked が既定 |
| https://github.com/systemd/systemd/releases/tag/v261 | 2026-10-09 | v261 は 2026/06/19 |
| https://github.com/systemd/systemd/releases/tag/v262 | 2026-10-09 | v262 は 2026/09/22。Latest 表示 |
| https://github.com/systemd/systemd/releases/tag/v260 | 2026-10-09 | (スライド未使用)v260 は 2026/03/17 |
| https://github.com/systemd/systemd/releases/tag/v258 | 2026-10-09 | (スライド未使用)v258 は 2025/09/17 |
| https://manpages.debian.org/unstable/anacron/anacron.8.en.html | 2026-10-09 | anacron(8)(2.3-50)に、cron と違い常時稼働を前提にしない、との記載(原文 "Unlike cron(8), it does not assume that the machine is running continuously.") |
| https://docs.aws.amazon.com/scheduler/latest/UserGuide/what-is-scheduler.html | 2026-10-09 | Amazon EventBridge Scheduler は、タスクを作成・実行・管理できるサーバーレスのスケジューラー |
| https://docs.cloud.google.com/scheduler/docs | 2026-10-09 | Cloud Scheduler は、ジョブをスケジュールするフルマネージドの cron サービス |
| https://docs.cloud.google.com/run/docs/about-instance-autoscaling | 2026-10-09 | Cloud Run は受信リクエストに合わせてインスタンス数を自動で調整し、トラフィックがなければ既定でゼロにする |
| https://docs.aws.amazon.com/AmazonS3/latest/userguide/EventNotifications.html | 2026-10-09 | S3 のバケットでイベントが起きたときに通知を受け取れる |
| https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ | 2026-10-09 | コンテナのリソース上限は kubelet が適用し、Linux では最終的にカーネルが cgroups で強制する(kubernetes/website の元 Markdown で確認) |
| https://brand.systemd.io/ | 2026-10-09 | 表記は小文字の `systemd`。読み方の記載はない |
| https://www.dmtf.org/standards/smbios | 2026-10-09 | (footer 外・補足)SMBIOS はシステムのファームウェアが管理情報を渡すための標準 |

## ⚠️ 出典なし・未確認の情報

1. freedesktop.org の man page(HTML)は、この環境から取得できなかった。内容は GitHub の元 XML(v262)で確認した。footer の URL はブラウザで開いて確認していない。本番前に、発表者がブラウザで1度開いて記述を確認してほしい
2. シードの path ユニットの制約「サブディレクトリを再帰的に監視できない」「更新が高頻度だと取りこぼす可能性」は、systemd.path(v262)に記載がないため、スライドから外した。inotify(7) 側の記述は未確認。man page にある制約(NFS、起動回数の上限)のみ使った
3. 「cron は常時稼働が前提」は、cron 自身の man page ではなく、anacron(8) の対比表現(cron と違い、常時稼働を前提にしない)からの読み取り。cron の man page は未確認
4. IMDS の実動作は未実行。この環境は systemd 255 で、v261 以降の systemd-imdsd / systemd-imds が無く、クラウドの仮想マシンでもない。スライドとセリフに「未実行」と明記してある。NEWS・man page・ソース(unit ファイル、hwdb)の記載だけを根拠にしている
5. クラウドとのたとえ(timer ≒ EventBridge Scheduler / Cloud Scheduler、socket ≒ サーバーレス、path ≒ ストレージのイベント通知、slice・scope ≒ コンテナのリソース上限)は、発表者側のたとえであり、公式の対応表ではない。出典は各製品が何であるかの説明のみ。「たとえであり同じものではない」をスライドとセリフに明記した
6. 「socket は関数の実行環境を用意しない」は、systemd.socket の記載(オンデマンドで service を起動する)と、Cloud Run のドキュメント(インスタンスの自動調整)を比べた説明。両方を比較した公式の資料はない
7. 読み方(systemd、cgroup、IMDS など)は、公式に記載がない(systemd は brand.systemd.io で確認済み。他は未確認)。慣用として下記に記録した。セリフでは英字のまま書いてあり、読みは断定していない
8. github.com/systemd/systemd/releases の一覧ページは、取得結果が古く(v262-rc1 が先頭に出る)、最新の判断に使えなかった。リリース日と Latest 表示は、タグごとのページ(v261 / v262 / v260 / v258)で確認した
9. docker.socket は Ubuntu 標準ではなく、この環境に入っている docker-ce パッケージ(5:29.8.2-1~ubuntu.24.04~noble)のファイル。スライドのコメントに「+ docker-ce」と書いた

## 差し込み欄(スライド番号 | 何を入れるか)

| スライド | スライドの行 | セリフの行 |
|---|---|---|
| 3 | `【差し込み: これまで systemd で書いてきたユニットの種類と、調べて分かったこと】` | `(※ここで実体験を話す: これまで systemd で書いてきたユニットの種類と、調べて分かったこと)`(「ここがポイントです。」の次) |
| 10 | `【差し込み: 試してみたい種類と、その理由】` | `(※ここで実体験を話す: 試してみたい種類と、その理由)`(「気になった種類から、…」の前) |

- どちらも、削除しても話が通るようにしてある(前後は事実の説明のみ)
- 発表者の経験として使ったのは、シードにある「systemd は service のためのものだと思っていた。調べて、想像以上にいろいろできると分かった」だけ(2枚目・3枚目・10枚目のセリフ)
- 本番前に、スライドの `【差し込み: …】` の行は、実際に話す内容に置き換えるか、削除する

## 動作確認(実行したもの / 未実行とその理由 / バージョン / 環境)

環境: Ubuntu 24.04.5 LTS / systemd 255 (255.4-1ubuntu8.17) / util-linux 2.39.3-9ubuntu6.6 / docker-ce 5:29.8.2。この環境の PID 1 は systemd ではない(サンドボックス)ため、`systemctl status` や `start` は使えない

実行したもの:
1. `systemctl -t help` → 11種類(service mount swap socket target device automount timer path slice scope)。素の出力は12行(1行目が `Available unit types:`)。スライド3は `| tail -n +2 | xargs` で1行にした実出力
2. `cat /usr/lib/systemd/system/fstrim.timer` → `OnCalendar=weekly` / `AccuracySec=1h` / `Persistent=true` / `RandomizedDelaySec=100min`(スライド6。前後は `...` で省略)
3. `cat /usr/lib/systemd/system/docker.socket` → `ListenStream=/run/docker.sock`(スライド7。前後は `...` で省略)
4. `systemd-analyze calendar weekly` → `Normalized form: Mon *-*-* 00:00:00`(systemd.time の記載と一致。スライドには未掲載)
5. `systemd-analyze verify`(自作の backup.timer / backup.service、実ファイルの fstrim.timer / docker.socket)→ 自作の正しい unit と実ファイルはエラーなし。タイプミスの `Persistant=true` は `Unknown key name 'Persistant' in section 'Timer', ignoring.` と検出(スライドには未掲載)
6. GitHub の systemd/systemd(v261 / v262 タグ)から NEWS、hwdb、unit ファイル、man の元 XML を取得して読んだ。v261 と v262 の hwdb が同一であること、v262 の NEWS(累積)に v258 / v260 / v261 の項目があることを確認
7. `lt-marp-png` で10枚を PNG にして目視確認(はみ出しと日本語フォントを確認し、3・4・9枚目は修正済み)

未実行(理由):
- timer / socket / path ユニットの実際の起動と、`Persistent=true` の挙動(電源断をまたぐ動作): PID 1 が systemd ではないため
- IMDS(systemd-imdsd / systemd-imds / systemd-imds-generator): 環境の systemd が 255 で v261 未満。クラウドの仮想マシンでもない。公式ドキュメントとソースの記載のみ
- v262 の systemd での `systemctl -t help`: 環境に入っているのは 255 のみ。11種類は v262 の man page の元 XML と 255 の実出力が一致
- freedesktop.org の HTML ページを開くこと: 取得不可(上記 ⚠️ 1)

## 読み方メモ(語 | 採用する読み | 根拠)

| 語 | 採用する読み | 根拠 |
|---|---|---|
| systemd | システムディー | 公式に読みの記載なし(brand.systemd.io は表記のみ。小文字で `systemd`)。慣用として。セリフでは断定しない |
| service / timer / socket / path / target / slice / scope | サービス / タイマー / ソケット / パス / ターゲット / スライス / スコープ | 英単語のカタカナ読み。公式の読みの記載は未確認 |
| cgroup | シーグループ | 公式の読みは未確認。慣用として。言い換えは「コントロールグループ」 |
| IMDS | アイエムディーエス | 略語の文字読み。展開は Instance Metadata Service(NEWS)。公式の読みは未確認 |
| NFS | エヌエフエス | 略語の文字読み。公式の読みは未確認 |
| cron / anacron | クーロン / アナクーロン | 公式の読みは未確認。慣用として |
| Linux / Docker / Ubuntu / Kubernetes | リナックス / ドッカー / ウブントゥ / クバネティス | 公式の読みは未確認。慣用として |
| SMBIOS | セリフでは読まない(「マシンの機器情報」と言う) | スライドの表記のみ |

- セリフは、すべて英字表記で統一してある(例: 「systemd」「service」「socket」)
- ユニットのタイプ名は、スライドと同じく小文字の英字で書く

## 言い換え表(言いにくい語 | 言い換え候補)

| 言いにくい語 | 言い換え候補 |
|---|---|
| systemd | Linux のサービス管理の仕組み / 起動と管理の仕組み |
| ユニットタイプ | ユニットの種類 |
| cgroup | Linux のリソース管理の機能 / プロセスを分けて上限を決める機能(セリフ採用: 「Linux のリソース管理機能」) |
| IMDS | クラウドの仮想マシンが自分の情報を取る仕組み(セリフ採用) / メタデータの取得サービス |
| SMBIOS | マシンの機器情報(セリフ採用) |
| NFS | ネットワーク越しの共有ディスク(セリフ採用) |
| EventBridge Scheduler / Cloud Scheduler | クラウドのスケジューラー(セリフ採用) |
| Persistent= | 逃した実行を取り戻す設定(セリフ採用) |
| OnCalendar= | カレンダー指定の時刻 / カレンダー形式 |
| socket activation | 接続が来たら起動する仕組み |
| inotify | Linux のファイル変更通知(セリフ採用) |
| anacron | cron と別の定期実行の仕組み / anacron のマニュアル(セリフでは「anacron のマニュアル」) |
| サーバーレス | リクエストが来るまで動かない仕組み |
| Kubernetes | コンテナの管理基盤 |

## 質問されそうな点(3〜5個、答えと出典つき)

1. timer は cron や anacron と何が違うのか
   - 答え: timer には `Persistent=true` があり、停止中に逃した実行を起動後に実行できる(`OnCalendar=` のタイマーのみ有効)。anacron の man page には、cron と違い常時稼働を前提にしない、とある。どちらが良いかは用途次第で、公式資料に優劣の記載はない(スライドでは優劣を言っていない)
   - 出典: systemd.timer、anacron(8)

2. `Persistent=true` は `OnCalendar=` 以外のタイマーでも効くのか。最終実行の時刻はどこに保存されるのか
   - 答え: 効かない。man page は「`OnCalendar=` のタイマーにのみ効果がある」としている。最終実行の時刻はディスクに保存され、`systemctl clean --what=state` で消せる。保存先のパスは man page に記載がなく、この環境でも確認できていない(未確認)
   - 出典: systemd.timer

3. path ユニットは、サブディレクトリの再帰的な監視や、高頻度の更新の取りこぼしに対応できるのか
   - 答え: systemd.path(v262)に、再帰監視と取りこぼしの記載はない(公式に記載なし)。記載があるのは、inotify を使うため NFS 上の他のマシンの変更は見えないこと、起動回数が `TriggerLimitIntervalSec=`(既定 2s)と `TriggerLimitBurst=`(既定 200)を超えると失敗状態になり、再起動まで監視しないこと
   - 出典: systemd.path

4. socket ユニットは、サーバーレス(関数の実行基盤)と同じものか
   - 答え: 同じではない。socket ユニットは、接続が来たときに service を起動する仕組みで、起動される側が systemd からソケットを受け取れる必要がある。スライドでも「たとえ」と明記し、socket が行うのは service の起動までとして触れている。Cloud Run のスケールやインスタンスの管理は、Cloud Run 側の機能
   - 出典: systemd.socket、Cloud Run のオートスケールのドキュメント

5. IMDS に対応すると、cloud-init と競合するのか。v260 の SysV 削除や v258 の cgroup v1 削除は本当か
   - 答え(cloud-init): systemd.imds.network= の既定は unlocked で、一般のプロセスは IMDS に直接つなげる。locked にすると直接アクセスが禁止され、NEWS は「cloud-init のような従来の IMDS クライアントと、通常は競合する」としている。実際の動作は未実行
   - 答え(v260 / v258): NEWS で確認できた。v260(2026/03/17)で System V サービススクリプトのサポートを削除(runlevel*.target は `-Dcompat-sysv-interfaces=yes` で復活)。v258(2025/09/17)で cgroup v1 のサポートを削除。スライドには使っていない
   - 出典: NEWS(v262 に累積)、systemd-imdsd@.service の man(元 XML)、各リリースのタグのページ

## 発表者に確認したい点(補足)

- 差し込み2か所(3枚目・10枚目)に入れる、実際に書いたことのあるユニットの種類と、試してみたい種類
- IMDS(9枚目)を話すかどうか。未実行のため「公式の記載を読んだだけ」と明記してある。本番前にクラウドの仮想マシンで試せるなら、実行結果の差し替えを推奨
- 「cron は常時稼働が前提」(6枚目)の言い回しで良いか(anacron の man page の対比表現が根拠)
- 読み方(systemd、cgroup、IMDS など)の統一
- footer の freedesktop.org の URL を、本番前にブラウザで開いて確認すること
