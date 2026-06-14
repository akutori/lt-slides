# Faxの「アレ」について

FAX のあの音（ピッピッ / ブーー / ヒョロロロ / ジャーーー）が  
なぜ鳴るのかを ITU-T T.30 プロトコルに沿って解説する LT スライド。

## 発表情報

- **イベント**: [Engineer Cafe LT](https://engineercafe.connpass.com/event/394925/)
- **発表動画**: [YouTube](https://youtu.be/8UmAlLTZgSU?list=PLbPtLKRucHw7Dm30-YJll91ojoivGhXLa&t=4833)

## ファイル構成

```
.
├── Faxの「アレ」について.md   # Marp スライド本体
├── script.md                  # 発表セリフ全文
├── contents/
│   ├── cng.wav                # CNG トーン（1100 Hz 断続音）
│   ├── ced.wav                # CED トーン（2100 Hz 連続音）
│   ├── dis.wav                # DIS 近似（V.21 ch.2 FSK）
│   ├── dcs.wav                # DCS 近似（V.21 ch.2 FSK）
│   ├── modem-training.wav     # モデムトレーニング近似（周波数スイープ）
│   ├── message.wav            # 画像データ近似（帯域制限ノイズ）
│   └── full-sequence.wav      # Phase A〜C 全体シーケンス
└── fax-sounds/
    └── generate.py            # 上記 WAV ファイルの生成スクリプト
```

## スライドのビルド

```bash
npx @marp-team/marp-cli "Faxの「アレ」について.md" --html
```

## 音声ファイルの再生成

```bash
cd fax-sounds
uv run python generate.py
```

依存: `numpy`, `scipy`（`uv` が自動インストール）

## 参考仕様書

| 仕様 | 内容 |
|------|------|
| ITU-T T.30 (09/2005) | FAX プロトコル（フェーズ A〜E、制御信号） |
| ITU-T T.4 (2003) | 画像フォーマット・圧縮方式（MH / MR / MMR） |
| TTC JT-T30 | T.30 の日本語版（情報通信技術委員会） |
| ITU-T V.21 | 制御信号の変調方式（FSK 300 bps） |
| ITU-T V.25 | CED 2100 Hz トーンの規定 |
| ITU-T G.164 / G.165 | エコーサプレッサ / エコーキャンセラ |
