import numpy as np
import scipy.io.wavfile as wav
from pathlib import Path

RATE = 44100
OUT = Path(__file__).parent.parent / "contents"

def sine(freq, duration):
    t = np.linspace(0, duration, int(RATE * duration), endpoint=False)
    return np.sin(2 * np.pi * freq * t)

def write(name, signal):
    wav.write(OUT / name, RATE, (signal * 32767).astype(np.int16))

# CNG: 1100 Hz, 0.5s ON / 3s OFF x 3 cycles (TTC JT-T30 §4.2)
cycle = np.concatenate([sine(1100, 0.5), np.zeros(int(RATE * 3.0))])
write("cng.wav", np.tile(cycle, 3))

# CED: 2100 Hz, 3.2s continuous (TTC JT-T30 §4.1.1, 許容範囲 2.6〜4.0s)
write("ced.wav", sine(2100, 3.2))

# DIS/DCS近似: V.21 ch.2 FSK (mark=1650Hz / space=1850Hz, 300bps)
def fsk_v21(seed, duration=1.5):
    bps = 300
    bit_samples = int(RATE / bps)
    rng = np.random.default_rng(seed)
    bits = rng.integers(0, 2, int(duration * bps))
    chunks = []
    for bit in bits:
        freq = 1650 if bit == 1 else 1850
        t = np.arange(bit_samples) / RATE
        chunks.append(np.sin(2 * np.pi * freq * t))
    return np.concatenate(chunks)

write("dis.wav", fsk_v21(seed=42))
write("dcs.wav", fsk_v21(seed=99))

# モデムトレーニング信号近似: 周波数スイープ（ヒョロロロ効果）
from scipy.signal import chirp
t = np.linspace(0, 1.5, int(RATE * 1.5), endpoint=False)
training = chirp(t, f0=300, f1=3000, t1=1.5, method='linear')
write("modem-training.wav", training)

# TCF: 1.5秒間ゼロデータ（実際は無音に近い定常キャリア）
write("tcf.wav", np.zeros(int(RATE * 1.5)))

# FAXメッセージ近似: 帯域制限ノイズ（300〜3400Hz）= 「ジャーーー」
from scipy.signal import butter, filtfilt
rng2 = np.random.default_rng(7)
noise = rng2.standard_normal(int(RATE * 3.0))
b, a = butter(4, [300 / (RATE / 2), 3400 / (RATE / 2)], btype='band')
msg = filtfilt(b, a, noise)
write("message.wav", msg / np.max(np.abs(msg)))

print("Generated: cng.wav, ced.wav, tcf.wav, modem-training.wav, dis.wav, dcs.wav, message.wav ->", OUT)

# ── 全体シーケンス ──────────────────────────────────────────────────────────
# T.30 で規定される変調方式切替前後の 75ms インターバルを挟みながら連結
gap  = np.zeros(int(RATE * 0.075))   # 75ms（T.30 §5.3.2 NOTE 3）
gap2 = np.zeros(int(RATE * 0.200))   # 200ms（CED後の無音 §4.1.1）

cng_short   = np.tile(np.concatenate([sine(1100, 0.5), np.zeros(int(RATE * 3.0))]), 2)  # 2サイクル
ced_sig     = sine(2100, 3.2)
dis_sig     = fsk_v21(seed=42, duration=1.0)
dcs_sig     = fsk_v21(seed=99, duration=0.8)
training1   = chirp(np.linspace(0, 1.5, int(RATE * 1.5), endpoint=False), f0=300, f1=3000, t1=1.5, method='linear')
tcf_sig     = np.zeros(int(RATE * 1.5))
cfr_sig     = fsk_v21(seed=7,  duration=0.5)
training2   = chirp(np.linspace(0, 1.0, int(RATE * 1.0), endpoint=False), f0=300, f1=3000, t1=1.0, method='linear')

sequence = np.concatenate([
    cng_short,          # Phase A: CNG
    gap2,
    ced_sig,            # Phase A: CED
    gap2,
    dis_sig,            # Phase B: DIS
    gap,
    dcs_sig,            # Phase B: DCS
    gap,
    training1,          # Phase B: モデムトレーニング
    tcf_sig,            # Phase B: TCF（無音に近い）
    gap,
    cfr_sig,            # Phase B: CFR
    gap,
    training2,          # Phase C: 2回目のモデムトレーニング
    msg / np.max(np.abs(msg)) * 0.9,  # Phase C: 画像データ
])

write("full-sequence.wav", sequence / np.max(np.abs(sequence)))
print("Generated: full-sequence.wav ->", OUT)
