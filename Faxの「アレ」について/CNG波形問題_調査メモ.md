# CNG は正弦波か矩形波か — 調査メモ

> 発表後に質問を受けて調査。科学者への回答として一次ソースを徹底検証した記録。

---

## 結論

**CNG（1100 Hz）は実装上は正弦波だが、ITU-T T.30 は波形を明示していない。**

---

## ① 規格は波形を規定していない

ITU-T T.30 (09/2005) §4.2 / Figure 9 は以下のみ定義：

> "1100 Hz, ON for 0.5 second, OFF for 3 seconds."  
> NOTE – Tolerances: timing, ±15%; frequency, 1100 Hz ±38 Hz.

- 正弦波とも矩形波とも書いていない
- Figure 9 の矩形は**波形図ではなく ON/OFF の包絡線（タイミング図）**
- 「1100 Hz」がキャリア周波数を指す

一次ソース: **ITU-T T.30 (09/2005) §4.2**  
https://www.itu.int/rec/T-REC-T.30

---

## ② なぜ実装は正弦波か

### 理由A — PSTN の帯域制限（G.712）

PSTN は約 300〜3400 Hz の帯域フィルタ特性を持つ（ITU-T G.712）。

- 1100 Hz 矩形波のフーリエ展開：1100 / **3300** / 5500 / 7700 Hz…
- 3300 Hz は帯域内（通過）、5500 Hz 以上は帯域外で減衰
- トーン検出器（CNG 検出）は 1100 Hz ±38 Hz のナローバンドフィルタ → 3300 Hz 成分は無視される

一次ソース: **ITU-T G.712 (2001)** — Transmission performance characteristics of PCM channels  
https://www.itu.int/rec/T-REC-G.712

### 理由B — トーン生成は「合成＋フィルタ整形」

当時のトーン生成が「発振器の出力がそのまま正弦波」という単純な話ではない証拠：

**着信音生成 (Analog Devices Design Note 134)**:
> "A lowpass filter converts the **square wave output of the oscillator** to a **sine wave** by filtering out unwanted harmonics."  
> 20 Hz 矩形波 → ローパスフィルタ → 87 VRMS 正弦波 → 回線へ

一次ソース: [Analog Devices Design Note 134: Telephone Ring-Tone Generation](https://www.analog.com/jp/resources/design-notes/telephone-ring-tone-generation.html)

**DTMF 生成 IC（1980年代: AMI S25089、Mostek MK5089 等）**:
> "counters to sequence ratioed-capacitor D/A converters through **28 equal duration steps per sine-wave cycle** … switched-capacitor filter circuits … generating DTMF signals formed by **superposition of two sine waves**"

→ 階段波 D/A を合成し、フィルタで正弦波に整形していた。**フィルタが必要な時点で、生の出力は正弦波ではない。**

### 理由C — 水晶発振器の出力は矩形波が標準

「LC/水晶発振器は構造上正弦波しか出力しない」は誤り。

> "Unlike previous transistor-based crystal oscillators which produced a sinusoidal output waveform, as the CMOS inverter oscillator uses digital logic gates, **the output is a square wave**. **Usual crystal oscillator devices have square wave output** except for some special high frequency oscillators."

一次ソース: [electronics-tutorials.ws: Quartz Crystal Oscillator](https://www.electronics-tutorials.ws/oscillator/crystal.html)  
参考: [ECS Inc.: Guide To Oscillator Output Types](https://ecsxtal.com/guide-to-oscillator-output-types-sine-wave-and-square-wave/)

### 正弦波になる物理的根拠（LC 共振回路）

トランジスタ型 LC 発振器は二階線形微分方程式の解が正弦波：

$$L\frac{d^2q}{dt^2} + \frac{q}{C} = 0 \quad \Rightarrow \quad q(t) = Q_0\cos(\omega_0 t + \phi), \quad \omega_0 = \frac{1}{\sqrt{LC}}$$

持続発振の条件はバルクハウゼン条件（ループゲイン = 1、位相シフト = 2πn）。  
ただしこれは**LC タンク型**限定。デジタル CMOS 型は矩形波出力。

---

## ③ 矩形波が電話技術で使われる場所

**パルスダイヤル（黒電話）**：

> "the direct current flowing in the telephone local loop circuit is **interrupted** in a pattern … **ten pulses per second** … **66% break ratio**"

- AC トーンではなく **DC ループ電流の断続**
- 周波数の概念ではなく pps（pulses per second）と break/make 比で規定

一次ソース: [Wikipedia: Pulse dialing](https://en.wikipedia.org/wiki/Pulse_dialing)

---

## まとめ

| 主張 | 正否 |
|------|------|
| T.30 Figure 9 は波形を規定していない | ✅ |
| Figure 9 の矩形は ON/OFF の包絡線 | ✅ |
| LC（トランジスタ型）発振器は正弦波出力 | ✅（LC共振の解） |
| 水晶発振器は構造上正弦波のみ | ❌（CMOS型は矩形波が標準） |
| 1980年代のトーン生成は正弦波を「整形」していた | ✅（D/A合成＋フィルタ） |
| パルスダイヤルで矩形波を使用 | ✅（ただしDC断続、ACトーンではない） |
| 着信音（リング）生成に矩形波を使用 | 半分✅（矩形波→フィルタ→正弦波として回線へ） |
