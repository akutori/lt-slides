# memo: Kamailio

## 前提(想定時間・枚数・ツール・作成日)

- イベント: AkarengaLT 第50回(2026年10月後半の日曜、福岡 Engineer Cafe)
- 持ち時間: 10分。セリフは約300字/分で、2200〜3000字に収める方針
- 枚数: 10枚(タイトル1 / 見出し3 / 本文5 / まとめ1)
- ツール: Marp。セリフはスライドMarkdown内のHTMLコメント
- スライドの作成日: 2026-10-09。この memo.md は、独立点検の担当が 2026-10-10 に作成した(作成時点で memo.md が無かったため)。出典の確認日も 2026-10-10
- セリフ字数: 2245字(差し込み行を除く)。差し込み行を含めると2312字。差し込みの実体験を話す分は、この外に加算される(2245字は約7.5分)
- 言い詰まり配慮: 1文は最長でも60字以内(40字を超える文はない)、1文の読点は2つまで、文頭は「さて/で、/まず/次に/つまり/ここ」など言い出しやすい語、各スライドの最後は短い「です/ます」文、短い息継ぎの行を本文スライドに1〜2行
- 画像: Mermaid(mermaid/operator.mmd)から作成した 画像/operator.png のみ。キャラクター・ロゴ類は使っていない
- 聴衆はSIPを知らない前提で、用語は SIP / プロキシ / レジストラ / ロードバランサ に絞った
- 顧客名・日付・数値・個別のインシデントは書いていない。スライド上のIPは 127.0.0.1(ローカル)だけ
- 「2026年10月時点」と明記した情報: スライド7(Kamailio 6.1.4 が6.1系の最新版)

## 構成メモ(スライド番号 / 種別 / 要旨)

| # | 種別 | 要旨 |
| --- | --- | --- |
| 1 | タイトル | 「Kamailio」のみ。電話がつながる裏側のソフトの話。名前はハワイ語で「話す」の意味、ライセンスはGPL。流れは役割・設定・注意点 |
| 2 | 見出し | SIPプロキシとは |
| 3 | 本文 | 交換手のたとえの図。SIP(通話の開始・変更・終了を制御する取り決め)、プロキシ(SIPの要求を代理で取り次ぐ役)。音声は一般にSIPとは別の経路(たとえ話は厳密でない)。通話の中身は別のソフト(FreeSWITCH など)の役目 |
| 4 | 見出し | kamailio.cfgで動きを書く |
| 5 | 本文 | 動きは設定ファイル kamailio.cfg に書く。中身は全体設定・モジュール読み込み・処理の流れ。処理は request_route から始まる。機能はモジュールで足す(registrar / dispatcher)。差し込み1 |
| 6 | 本文 | ごく小さな設定の例(dispatcher の公式サンプルを最小化した動作確認用)。tm・sl・dispatcher を読み込み、ds_select_dst("1", "4") で宛先を選び、t_relay() で取り次ぐ。実運用には入力の検査や認証が必要 |
| 7 | 本文 | 宛先の一覧(dispatcher.list)と、テスト用スクリプトで要求を4回送った結果(宛先が交互になる)。Kamailio 6.1.4(2026年10月時点の6.1系最新版)で実行。宛先の停止時に次へ回す仕組みは試していない |
| 8 | 見出し | つまずきやすい点 |
| 9 | 本文 | 発表者の学び(設定関数は、実機に入れる前に公式ドキュメントで確認するほうが、デプロイ待ちを考えると全体で安い)。ドキュメントは使う版のものを開く。`kamailio -c` は構文と読み込み漏れを検出する(引数の意味は対象外)。差し込み2 |
| 10 | まとめ | 取り次ぎ役のSIPプロキシ。通話の中身は別のソフト。動きは kamailio.cfg、機能はモジュール。役割は広い(振り分け・登録・入口の守り)。設定の関数は実機の前に公式ドキュメントで確認 |

## 出典一覧(URL | 確認日 | 何の裏付けか)

スライドのfooterに載せたURLは、第3欄に「スライド」の番号を書いた。それ以外は、タイトルスライド(footerなし)・セリフ・質疑・読みの裏取り。

| URL | 確認日 | 何の裏付けか |
| --- | --- | --- |
| https://www.rfc-editor.org/rfc/rfc3261 | 2026-10-10 | スライド3。SIP は、セッションの作成・変更・終了のためのアプリケーション層の制御(シグナリング)プロトコル(Abstract)。プロキシは、サーバーでもクライアントでもある中間者で、他のクライアントに代わって要求を出す(§6)。レジストラは REGISTER 要求を受け付け、情報をそのドメインのロケーションサービスに保存する(§6)。メディアの詳細は SDP など別の形式で運ばれ、エンドツーエンドのメディアパケットはSIPシグナリングとは別の経路を通る |
| https://www.kamailio.org/wikidocs/tutorials/getting-started/main/ | 2026-10-10 | スライド3。Kamailio は中核としては SIP ルーターで、中核としては電話のエンジン(telephony engine)ではない。呼(call)はSIPメッセージの列。元の名前は SIP Express Router(SER)。ライセンスと名前の意味は、このページにはない |
| https://signalwire.com/developers/freeswitch | 2026-10-10 | スライド3。FreeSWITCH は「An open-source framework for real-time voice and video」 |
| https://github.com/kamailio/kamailio/blob/6.1.4/doc/man/kamailio.cfg.5 | 2026-10-10 | スライド5。設定ファイルは、全体の設定パラメータ、モジュール読み込みのコマンド、受信した各要求に対して実行されるスクリプトを含む。このページに request_route という名前とライセンスの記載はない |
| https://www.kamailio.org/wikidocs/cookbooks/devel/core/ | 2026-10-10 | スライド5。「唯一の必須のルーティングブロックは request_route」。loadmodule は、設定スクリプトで後で使うためにモジュールを読み込む。このページは Kamailio 6.1.x(devel)向け |
| https://github.com/kamailio/kamailio/blob/6.1.4/README | 2026-10-10 | スライド5。「Kamailio の機能の大半は、プラグインのモジュールとして実装されている」。役割として、ネットワークのセキュリティ障壁、プレゼンスサーバー、アプリケーションサーバー、PSTNゲートウェイの守り(エッジプロキシ / セッションボーダーコントローラ)を挙げている(セリフの「入口の守り役」の裏付け)。このページにGPLと名前の意味の記載はない |
| https://kamailio.org/docs/modules/stable/modules/dispatcher.html | 2026-10-10 | スライド5・6・7。dispatcher は SIP のロードバランサ / 振り分けの機能。`ds_select_dst(set, alg)` の set は宛先の集合(リストファイルの1列目)、alg の "4" はラウンドロビン。dispatcher.list の書式は「setid 宛先URI」(任意項目あり)。公式サンプル「load balancing of VoIP calls with round robin」が ds_select_dst("1", "4") を使い、宛先が失敗したときは失敗ルートで ds_next_dst() により次の宛先を試す |
| https://github.com/kamailio/kamailio/blob/6.1.4/etc/kamailio.cfg | 2026-10-10 | スライド6。標準の設定は request_route と、tm.so・sl.so の loadmodule を含む。長い設定で、認証(WITH_AUTH / auth_check)、要求の検査(sanity_check)、過負荷対策(pike)なども含む(スライドの「入力の検査や認証などの処理が必要」と整合)。dispatcher のサンプルは含まない |
| https://www.kamailio.org/w/category/releases/ | 2026-10-10 | スライド7。6.1系の最新は v6.1.4(2026-08-20)。6.0系は v6.0.8(2026-09-16) |
| https://kamailio.org/docs/modules/stable/modules/sl.html | 2026-10-10 | スライド9。sl はステートレスな返信のモジュール。`send_reply(code, reason)` は返信を送る。トランザクションがあれば stateful になる(tm との関係) |
| https://github.com/kamailio/kamailio/blob/6.1.4/doc/man/kamailio.8 | 2026-10-10 | スライド9。`-c` は「設定ファイルを確認し、エイリアスと待受インターフェースの一覧を表示する」。`-f` は設定ファイルの指定。構文エラーの検出という記述はない(未確認の項目3) |
| https://www.kamailio.org/wikidocs/cookbooks/ | 2026-10-10 | スライド9。cookbook は版ごとのフォルダ(3.2.x〜5.8.x、6.0.x、6.1.x、devel)に分かれる |
| https://www.kamailio.org/w/ | 2026-10-10 | スライド未使用(タイトルのセリフ「ライセンスはGPL」の裏付け)。「Open Source SIP Server released under GPLv2+」。OpenSER から2008年に改名 |
| https://www.kamailio.org/w/openser-renamed-to-kamailio/ | 2026-10-10 | スライド未使用(タイトルのセリフ「ハワイ語で、『話す』という意味」の裏付け)。2008-07-28 に OpenSER を Kamailio に改名。「Kama'ilio means talk, to converse」(ハワイ語) |
| https://lists.kamailio.org/pipermail/devel/2008-August/015410.html | 2026-10-10 | 読みの確認。2008年のメーリングリストで、ハワイ語では全ての文字を読む、1語か2語か、などの議論。公式の読みの決定ではない |
| https://github.com/sipwise/rtpengine | 2026-10-10 | スライド未使用(スライド3のセリフ「音声の中継が要るときも、別のソフトを足します」の裏付け)。rtpengine は RTP などのメディアトラフィックのプロキシで、Kamailio の SIP プロキシと使う想定 |

## ⚠️ 出典なし・未確認の情報

1. タイトルのセリフの「ハワイ語で『話す』」と「ライセンスはGPL」は、タイトルスライドにfooterがないため、スライド上に出典がない。出典は公式サイトの2か所(上の出典一覧: ホームページの GPLv2+、公式ブログの「Kama'ilio means talk, to converse」)。
2. Kamailio の読みは公式に記載なし(下の読み方メモ)。セリフはローマ字表記で、読みは発表者が決める。
3. スライド9の「`kamailio -c` は構文と読み込み漏れを検出する(引数の意味は対象外)」は、man page の説明(設定ファイルを確認し、エイリアスと待受の一覧を表示)だけでは裏付けにならない。根拠は、作成担当の検証環境と、点検担当の再実行(2026-10-10)の結果。スライドの2行の出力と同じ内容を再現でき、dispatcher のアルゴリズムに 99 を指定した設定でも `-c` は通った(実行時にだけ警告が出る)。
4. スライド5のレジストラとロードバランサの説明は、footer(kamailio.cfg.5、cookbook、README)に直接の出典がない。レジストラはRFC 3261(スライド3のfooter)、ロードバランサは dispatcher の文書(スライド6・7のfooter)で裏付けられる。
5. スライド6のfooterの `etc/kamailio.cfg` は、request_route と loadmodule の根拠で、dispatcher のサンプルを含まない。dispatcher の公式サンプルは dispatcher の文書にある。
6. スライド5のfooterの cookbook は devel 版。スライド9は「使う版のものを開く」と話すため、6.1.4 に合わせるなら 6.1.x の cookbook を使う。
7. 「音声の中継が要るときも、別のソフトを足します」(スライド3のセリフ)は、スライドのfooterに出典がない(rtpengine の README が裏付け)。
8. スライド7は「検証環境で動かした結果です」と話している。この実行は作成担当のもので、発表者本人の実行ではない。発表者が手元で同じ手順を再現した場合は、「検証環境で」を「手元で」に直してよい。
9. スライド7の「OKは、受け先が要求を受け入れた、という返事です」「返事の連絡先の欄で、どの宛先か分かります」は、SIPの 200 OK と Contact の一般的な説明。RFC 3261 の該当節(§21.2.1、§12)は、この環境の取得ツールでは本文を読めず、確認していない。
10. スライド7の「宛先が止まったときに、次の宛先へ回す仕組み」は、dispatcher の文書の公式サンプル(ds_next_dst)の記載のみ。試していない(セリフで明記)。
11. 発表者の経験(GCP上の音声システムの開発、Terraformでの構築、FreeSWITCH と Kamailio の使用、学びの一般化)はシード(申告)に基づく。外部の出典はない。顧客名・日付・数値は書いていない。
12. 読み(下の表)は、すべて公式に記載なし。

## 差し込み欄(スライド番号 | 何を入れるか)

| スライド | 何を入れるか |
| --- | --- |
| 5 | Kamailio の設定ファイルを書いてみた感想(スライド側に `【差し込み: 設定ファイルを書いた感想】`、セリフ側に `(※ここで実体験を話す: 設定ファイルを書いてみた感想について)`) |
| 9 | 実際に困った設定(スライド側に `【差し込み: 実際に困った設定】`、セリフ側に `(※ここで実体験を話す: Kamailioで実際に困った設定について)`) |

差し込みは2か所(シードの上限は2か所)。差し込みがなくても、前後の事実部分だけで話は通る。

発表者への確認事項:

- 設定ファイルを書いた感想と、実際に困った設定(あれば。なければ、2つの差し込みは削除する)
- スライド7の動作結果を、発表者の手元で再現するか、「検証環境の結果」と話すか(未確認の項目8)
- Kamailio の読み(カマイリオで良いか)と、SIP の読み(エスアイピー / シップ)

## 動作確認(実行したもの / 未実行とその理由 / バージョン / 環境)

実行したもの(作業記録で確認できたもの):

- Kamailio 6.1.4 をソースからビルドしてローカルにインストール(`kamailio -v`: kamailio 6.1.4 (x86_64/linux) 8ba646、gcc 13.3.0、2026-10-09 にビルド)。ビルドに必要な flex 2.6.4 もソースからローカルにビルド
- スライド6の設定(3つの loadmodule と request_route)を、ローカルのダミー宛先2つ(127.0.0.1:5080 と 127.0.0.1:5090。要求に 200 OK を返す小さなPythonスクリプト)の前で実行
  - `kamailio -f mini.cfg -l udp:127.0.0.1:5060 -DD -E -n 2` で起動。dispatcher.list は、既定の場所(インストール先の etc/kamailio/)に、スライド7と同じ2行で置いた
  - テスト用スクリプトでINVITEを4回送り、5080と5090がそれぞれ2回ずつ受信したことを確認(final_rr_b1.log、final_rr_b2.log)。送信側の出力(スライド7の4行)の保存は確認できず。点検担当が 2026-10-10 に同じ手順で再実行し、5090、5080、5090、5080 の順になることを確認
- アルゴリズムに 99 を指定した設定: 実行時に `ds_manage_routes(): algo 99 not implemented - using first entry...` の警告が出て、すべて最初の宛先(5090)に届いた(final_a99_kamailio.log、final_a99_b2.log)。`kamailio -c` はこの設定でも通る(点検担当が再確認)
- sl.so を外した設定に `kamailio -c -f mini.cfg` を実行した出力(スライド9の2行): 作成担当の出力ログは確認できず。点検担当が 2026-10-10 に final_nosl/mini.cfg で再実行し、スライドと同じ2行(`failed to find command send_reply (params 2)` と `line 6, column 43: unknown command, missing loadmodule?`)を確認

未実行:

- dispatcher の失敗時の切り替え(ds_next_dst): 試していない(セリフで明記)
- registrar(usrloc)など他のモジュール、認証や入力検査を含む本番向けの設定
- 実機(GCP上の環境)での動作、FreeSWITCH や rtpengine との連携、TCP・TLS
- いずれも、スライドには実行結果として載せていない

バージョン・環境:

- Kamailio 6.1.4(id 8ba646)/ gcc 13.3.0 / flex 2.6.4(ローカルビルド)
- Python 3.13.16 / Linux 6.18.44-fc-v80 / UDP 127.0.0.1:5060

## 読み方メモ(語 | 採用する読み | 根拠)

| 語 | 採用する読み | 根拠 |
| --- | --- | --- |
| Kamailio | カマイリオ(セリフはローマ字のまま) | 公式に読みの記載なし。公式ブログはハワイ語 Kama'ilio の意味(talk, to converse)のみ。2008年のメーリングリストで発音が議論された。慣用として |
| SIP | エスアイピー または シップ | RFC 3261 に読みの記載なし。発表者が普段使う読みに合わせる(未確認) |
| GPL | ジーピーエル | 略語の文字読み。公式記載なし |
| FreeSWITCH | フリースイッチ | 公式記載なし。慣用として |
| request_route | リクエストルート | 識別子の英語読み。セリフでは1回だけ言う |
| GCP | ジーシーピー | 略語の文字読み |
| Terraform | テラフォーム | 公式記載なし。慣用として |
| OK | オーケー | 一般的な読み |
| プロキシ・レジストラ・ロードバランサ | プロキシ・レジストラ・ロードバランサ | 表記はスライドと同じ(長音なし)。慣用として |
| 一つ・二つ・三つ・四回 | ひとつ・ふたつ・みっつ・よんかい | 数字を読み上げない規約のため、セリフは漢数字で書いた |

## 言い換え表(言いにくい語 | 言い換え候補)

| 言いにくい語 | 言い換え候補 |
| --- | --- |
| Kamailio | このソフト、SIPのプロキシ、電話をつなぐ交換手になるソフト(セリフで採用) |
| SIP | 通話の取り決め(セリフで採用)、電話をつなぐ信号の決まり |
| プロキシ | 取り次ぎ役(セリフで採用) |
| レジストラ | 名簿に居場所を登録する役(セリフで採用) |
| ロードバランサ | 受け先が複数のとき、振り分ける役(セリフで採用) |
| FreeSWITCH | 通話の中身を扱う別のソフト(セリフで採用) |
| request_route | 処理の入口(セリフで採用) |
| モジュール | 部品(セリフで採用) |
| dispatcher | 宛先を振り分けるモジュール(セリフで採用) |
| tm / sl | 状態を覚えながら取り次ぐモジュール / 返事を返すモジュール(セリフで採用) |
| INVITE | 電話をかける要求(セリフで採用) |
| GPL | 公開されたソースの利用条件 |
| デプロイ | 実機への反映 |
| `kamailio -c` | 画面のコマンド(セリフで採用)、設定の確認コマンド |
| ラウンドロビン | 順番に一つ選ぶ(セリフで採用) |
| Terraform | 構築を自動化するツール |
| GCP | Googleのクラウド |

## 質問されそうな点(3〜5個、答えと出典つき)

1. 音声は Kamailio を通るのか
   - 一般には通らない。SIPは通話の開始・変更・終了の制御で、エンドツーエンドのメディアパケットはSIPシグナリングとは別の経路を通る。音声の中継が必要なときは、rtpengine のような別のソフトを足す(rtpengine は RTP の proxy で、Kamailio と使う想定)
   - 出典: https://www.rfc-editor.org/rfc/rfc3261 / https://github.com/sipwise/rtpengine
2. 宛先が止まったらどうなるのか
   - dispatcher には、宛先が失敗したときに次の宛先へ回す仕組みがある(公式サンプルは、失敗ルートで ds_next_dst() を使う)。スライドの例では試していない
   - 出典: https://kamailio.org/docs/modules/stable/modules/dispatcher.html
3. このスライドの設定を、そのまま本番で使えるのか
   - 使えない。動作確認用の最小の例で、入力の検査や認証などが要る。公式の標準設定は長く、認証(WITH_AUTH)、要求の検査(sanity_check)、過負荷対策(pike)などを含む。README は、役割として入口の守り(エッジプロキシ / SBC)も挙げる
   - 出典: https://github.com/kamailio/kamailio/blob/6.1.4/etc/kamailio.cfg / https://github.com/kamailio/kamailio/blob/6.1.4/README
4. `kamailio -c` で、引数の誤りも見つかるのか
   - 見つからない。モジュールの読み込み漏れ(unknown command, missing loadmodule?)のような、構文・読み込みの問題は見つかる。dispatcher のアルゴリズムに存在しない番号(例: 99)を書いても `-c` は通り、実行時に警告が出て、最初の宛先が使われる。意味は公式ドキュメントで確かめる
   - 出典: https://github.com/kamailio/kamailio/blob/6.1.4/doc/man/kamailio.8(-c の説明)/ https://kamailio.org/docs/modules/stable/modules/dispatcher.html / 作業記録(検証環境)
5. Kamailio の名前の意味と読み方、OpenSER との関係は
   - ハワイ語で「話す、会話する」(Kama'ilio)。2008-07-28 に OpenSER から Kamailio に改名。元は SIP Express Router(SER)。読みは公式に記載なし
   - 出典: https://www.kamailio.org/w/openser-renamed-to-kamailio/ / https://www.kamailio.org/wikidocs/tutorials/getting-started/main/ / https://lists.kamailio.org/pipermail/devel/2008-August/015410.html
