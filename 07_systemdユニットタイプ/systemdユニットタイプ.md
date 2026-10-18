---
marp: true
paginate: true
style: |
  section {
    font-family: "Noto Sans CJK JP", "Noto Sans JP", sans-serif;
  }
  section pre, section code {
    font-family: "Noto Sans Mono CJK JP", monospace;
  }
---

# systemdユニットタイプ

<!-- では、始めます。 -->
<!-- 今日のテーマは、systemd のユニットタイプです。 -->
<!-- ユニットとは、systemd が管理する一つ一つの対象のことです。 -->
<!-- 今回は、service 以外の種類を、順に見ていきます。 -->
<!-- 流れは、種類の一覧と、起動のきっかけの変え方です。 -->
<!-- 最後に、新しい機能も一つ紹介します。 -->

---

<!-- header: "" -->
<!-- footer: "" -->

# serviceだけではない

<!-- さて、まずは、systemd について自分が持っていた思い込みの話から始めます。 -->

---

<!-- header: serviceだけではない -->
<!-- footer: "https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html<br>https://www.freedesktop.org/software/systemd/man/latest/systemctl.html<br>https://www.freedesktop.org/software/systemd/man/latest/systemd.special.html<br>https://www.freedesktop.org/software/systemd/man/latest/systemd.target.html" -->

- ユニットのタイプは11種類(2026年10月時点の最新 man page)

```
$ systemctl -t help | tail -n +2 | xargs    # Ubuntu 24.04 / systemd 255
service mount swap socket target device automount timer path slice scope
```

- service の [Install] でよく書く `WantedBy=multi-user.target` も target の指定

【差し込み: これまで systemd で書いてきたユニットの種類と、調べて分かったこと】

<!-- さて、画面のコマンドを見てください。 -->
<!-- ユニットのタイプを、一覧で出したものです。 -->
<!-- これは、Ubuntu の実行結果を、一行にしたものです。 -->
<!-- 最新のマニュアルでも、種類は同じです。 -->
<!-- この名前が、ファイル名の末尾になります。 -->
<!-- つまり、service は、その一つにすぎません。 -->
<!-- 実は、service を動かすだけの仕組みだと思っていました。 -->
<!-- でも、調べると、想像以上にいろいろできました。 -->
<!-- ここがポイントです。 -->
<!-- (※ここで実体験を話す: これまで systemd で書いてきたユニットの種類と、調べて分かったこと) -->
<!-- ほかには、マウントや、スワップなどがあります。 -->
<!-- 主なものだけ、見ていきます。 -->
<!-- で、二つ目の箇条書きを見てください。 -->
<!-- これは、service のファイルで、よく見る行です。 -->
<!-- この行が指すのは、target という種類です。 -->
<!-- つまり、ユニットをまとめる種類のことです。 -->
<!-- すでに、別の種類を使っています。 -->

---

<!-- header: serviceだけではない -->
<!-- footer: "https://www.freedesktop.org/software/systemd/man/latest/systemd.resource-control.html<br>https://docs.aws.amazon.com/scheduler/latest/UserGuide/what-is-scheduler.html<br>https://docs.cloud.google.com/scheduler/docs<br>https://docs.cloud.google.com/run/docs/about-instance-autoscaling<br>https://docs.aws.amazon.com/AmazonS3/latest/userguide/EventNotifications.html<br>https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/" -->

| タイプ | systemd での役割 | クラウドのたとえ(同じものではない) |
|---|---|---|
| timer | 時刻や間隔で起動 | EventBridge Scheduler / Cloud Scheduler |
| socket | 接続が来たら起動 | サーバーレス(Cloud Run など) |
| path | ファイルの変化で起動 | ストレージのイベント通知(S3 など) |
| slice / scope | cgroup でリソース管理 | コンテナのリソース上限(Kubernetes) |

<!-- さて、クラウドにたとえます。 -->
<!-- 先に言うと、あくまでたとえです。 -->
<!-- 次に、timer です。 -->
<!-- 時刻や間隔で起動する種類です。 -->
<!-- クラウドのスケジューラーに近いです。 -->
<!-- 続いて、socket です。 -->
<!-- 接続が来ると起動する種類です。 -->
<!-- 接続が来るまで動かない点は、サーバーレスに近いです。 -->
<!-- さらに、path です。 -->
<!-- ファイルの変化で起動する種類です。 -->
<!-- 近いのは、ストレージのイベント通知です。 -->
<!-- 最後は、slice と scope です。 -->
<!-- ここは、プロセスをまとめて管理する種類です。 -->
<!-- その土台は、cgroup です。 -->
<!-- つまり、Linux のリソース管理機能です。 -->
<!-- 実は、Kubernetes の上限も、同じ機能で制限されます。 -->
<!-- ただし、socket は、service を起動するだけです。 -->
<!-- つまり、関数の実行環境は、用意しません。 -->
<!-- ここは大事です。 -->

---

<!-- header: "" -->
<!-- footer: "" -->

# 起動のきっかけを変える

<!-- 次は、service を起動するきっかけを、時刻や接続に変えられるという話です。 -->

---

<!-- header: 起動のきっかけを変える -->
<!-- footer: "https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html<br>https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html<br>https://manpages.debian.org/unstable/anacron/anacron.8.en.html" -->

```
$ cat /usr/lib/systemd/system/fstrim.timer    # Ubuntu 24.04
...
[Timer]
OnCalendar=weekly
AccuracySec=1h
Persistent=true
RandomizedDelaySec=100min
...
```

- timer は、既定で同じ名前の service を起動する
- `Persistent=true`: 停止中に逃した実行を、起動後に実行する
- 効くのは `OnCalendar=` のタイマーのみ
- cron は常時稼働が前提(anacron の man page)

<!-- さて、まず timer を見ます。 -->
<!-- これは、Ubuntu に入っているファイルです。 -->
<!-- 最初の指定は、週に一回です。 -->
<!-- 毎週月曜の、午前零時を表します。 -->
<!-- この timer は、同名の service を起動します。 -->
<!-- 時刻の指定には、カレンダー形式と、経過時間の形式があります。 -->
<!-- で、ここからが本題です。 -->
<!-- 電源が切れていた間に、逃した実行があるとします。 -->
<!-- その分を、起動後に取り戻す設定があります。 -->
<!-- それが、画面の二つ目の箇条書きです。 -->
<!-- ここがポイントです。 -->
<!-- ところで、cron は、定期実行の仕組みです。 -->
<!-- こちらは、マシンが動き続ける前提です。 -->
<!-- 出典は、anacron のマニュアルです。 -->
<!-- この設定は、その前提がない場面で役立ちます。 -->
<!-- ただし、効くのは、カレンダー指定だけです。 -->
<!-- ほかの行は、実行時刻に幅を持たせる設定です。 -->

---

<!-- header: 起動のきっかけを変える -->
<!-- footer: "https://www.freedesktop.org/software/systemd/man/latest/systemd.socket.html<br>https://www.freedesktop.org/software/systemd/man/latest/systemd.path.html" -->

- socket: 接続が来たときに service を起動する
- socket の条件: 起動される側が systemd からソケットを受け取れること
- path: ファイルやディレクトリの変化で service を起動する
- path の制約: NFS 上で他のマシンが行った変更は見えない
- path の制約: 起動回数が上限を超えると、監視を止める

```
$ cat /usr/lib/systemd/system/docker.socket    # Ubuntu 24.04 + docker-ce
...
[Socket]
...
ListenStream=/run/docker.sock
...
```

<!-- 次は、socket と path です。 -->
<!-- まず、socket は、接続が来ると service を起動します。 -->
<!-- で、下は、Docker のファイルの抜粋です。 -->
<!-- ただし、条件が一つあります。 -->
<!-- 起動される側が、systemd からソケットを受け取れる必要があります。 -->
<!-- つまり、どんなプログラムでもよい、とは限りません。 -->
<!-- 次に、path です。 -->
<!-- ファイルやディレクトリの変化で、service を起動します。 -->
<!-- 内部では、Linux のファイル変更通知を使います。 -->
<!-- そのため、通知機能と同じ制約があります。 -->
<!-- 制約の例は、NFS です。 -->
<!-- つまり、ネットワーク越しの共有ディスクです。 -->
<!-- そこでの、他のマシンの変更は、見えません。 -->
<!-- もう一つ、起動回数に上限があります。 -->
<!-- 上限を超えると、path は失敗して、監視を止めます。 -->
<!-- ここが要点です。 -->

---

<!-- header: "" -->
<!-- footer: "" -->

# 新しい機能: IMDS

<!-- 最後は、今年のリリースで追加された、クラウドに関する新しい機能を紹介します。 -->

---

<!-- header: "新しい機能: IMDS" -->
<!-- footer: "https://github.com/systemd/systemd/blob/v262/NEWS<br>https://github.com/systemd/systemd/blob/v262/hwdb.d/40-imds.hwdb<br>https://github.com/systemd/systemd/blob/v261/units/systemd-imdsd.socket<br>https://github.com/systemd/systemd/releases/tag/v261<br>https://github.com/systemd/systemd/releases/tag/v262" -->

- IMDS(Instance Metadata Service)の仕組みが v261(2026年6月)で追加
- v261 は SMBIOS の情報から、Amazon EC2・Azure など全9種のクラウドを判別
- 取得を担当する `systemd-imdsd` の入口は socket ユニット(v261 のソースの抜粋)

```
[Socket]
ListenStream=/run/systemd/io.systemd.InstanceMetadata
...
```

- 2026年10月時点の最新は v262。IMDS は未実行(確認環境は systemd 255)

<!-- さて、今日の最後は、IMDS の話です。 -->
<!-- これは、クラウドの仮想マシンが、自分の情報を取る仕組みです。 -->
<!-- たとえば、ホスト名や、リージョンです。 -->
<!-- 今年のリリースで、systemd が対応しました。 -->
<!-- マシンの機器情報から、動いているクラウドを判別します。 -->
<!-- 判別できるクラウドは、画面のとおり、複数です。 -->
<!-- ここが新しい点です。 -->
<!-- 取得を担当する、専用の service が追加されました。 -->
<!-- その入口が、socket ユニットです。 -->
<!-- つまり、今日の種類が、新機能の中でも使われています。 -->
<!-- 取得した情報は、あとから起動する service が使えます。 -->
<!-- 公式の説明では、共通のイメージを作れる、とされています。 -->
<!-- つまり、IMDS があれば使い、なければ使わずに動きます。 -->
<!-- ただし、動作は未確認です。 -->
<!-- 公式の説明と、ソースを読んだだけです。 -->

---

<!-- header: "" -->
<!-- footer: "" -->

# まとめ

- ユニットのタイプは11種類。service はその1つ
- timer・socket・path は起動のきっかけを変える
- slice・scope は cgroup でプロセスをまとめて管理する
- IMDS は v261(2026年6月)で追加。入口は socket ユニット

【差し込み: 試してみたい種類と、その理由】

<!-- さて、まとめます。 -->
<!-- 調べる前は、service のためのものだと思っていました。 -->
<!-- 調べると、想像以上にいろいろできると分かりました。 -->
<!-- ユニットのタイプは、service のほかにもあります。 -->
<!-- 起動のきっかけを変えるのが、timer と socket と path です。 -->
<!-- そして、プロセスをまとめて管理するのが、slice と scope です。 -->
<!-- なお、クラウドのたとえは、理解の助けです。 -->
<!-- ただし、同じものではありません。 -->
<!-- 最後の IMDS も、入口は socket でした。 -->
<!-- つまり、service 以外の種類も、実際に使われています。 -->
<!-- 種類を知ると、選択肢が増えます。 -->
<!-- 出典は、各スライドの下です。 -->
<!-- また、バージョンの話は、今月時点の情報です。 -->
<!-- (※ここで実体験を話す: 試してみたい種類と、その理由) -->
<!-- 気になった種類から、試してみてください。 -->
<!-- 以上です。 -->
