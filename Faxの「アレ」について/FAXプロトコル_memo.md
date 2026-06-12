# メモ — FAXプロトコル_ドラフト

## 参考リンク

- [ファクシミリ - Wikipedia](https://ja.wikipedia.org/wiki/%E3%83%95%E3%82%A1%E3%82%AF%E3%82%B7%E3%83%9F%E3%83%AA)
- [FAXは電話より先に発明された - 毎日が発見ネット](https://mainichigahakken.net/life/article/post-174.php)
- [ITU-T T.30 規格](https://www.itu.int/rec/T-REC-T.30/en)
- [PSTN FAX CALL PHASES (VoIP)](https://what-when-how.com/voip/pstn-fax-call-phases-voip/)
- [Training Check Frame (TCF) - Dialogic](https://www.dialogic.com/webhelp/NaturalAccess/Release9.0/NaturalFax_API_Dev_Manual/training_check_frame_tcf.html)
- [Analyzing a Basic Fax Call - Cisco CCExpert](https://www.ccexpert.us/voice-gateways/analyzing-a-basic-fax-call.html)
- [CNG信号 - 通信用語の基礎知識](https://www.wdic.org/w/WDIC/CNG%E4%BF%A1%E5%8F%B7)
- [CED信号 - 通信用語の基礎知識](https://www.wdic.org/w/WDIC/CED%E4%BF%A1%E5%8F%B7)

## 構成メモ

- スライド枚数：10枚（タイトル＋まとめ含む）
- 想定時間：10分（1枚約1分）
- 技術的な深さ：フェーズ概要まで（T.30の全フレームは扱わない）

## 出典なし情報について

スライド 3（FAXの仕組み）の図解的な流れは一般的な技術知識として扱っています。
FAX の動作原理は公知の事実のため出典は省略していますが、
詳細を確認する場合は上記 Wikipedia や NTT の技術資料が参考になります。

## 改善候補

- スライド 9（全体の流れ）は ASCII シーケンス図を使用。
  Mermaid を使う場合は `--html` フラグでの出力時に以下をフロントマターに追加:
  ```yaml
  html: true
  ```
  または Mermaid JS をテンプレートで読み込む必要あり。

- Phase B のトレーニング（スライド 7）でモデムの周波数変化をもう少し具体的に説明できると
  「ヒョロロロ」との対応がより伝わりやすい。
