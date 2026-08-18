import alpha as al
import numpy as np


def KDJ(close: np.ndarray, high: np.ndarray, low: np.ndarray, n=9, m=3, p=3) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
  """
  计算 KDJ 指标。

  Args:
    close: 收盘价序列。
    high: 最高价序列。
    low: 最低价序列。
    n: 短期移动平均线周期。
    m: 长期移动平均线周期。
    k: K 值周期。

  Returns:
    KDJ 指标序列。
  """
  
  RSV = (close - al.LLV(low, n)) / (al.HHV(high, n) - al.LLV(low, n)) * 100
  alpha = 1.0 / m
  K = al.DMA(RSV, alpha)
  D = al.DMA(K, alpha)
  J = 3 * K - 2 * D
  return K, D, J


def MACD(close: np.ndarray, fast: int = 12, slow: int = 26, signal: int = 9) -> tuple[np.ndarray, np.ndarray]:
  """
  计算 MACD 指标。

  Args:
    close: 收盘价序列。
    n_fast: 快速移动平均线周期。
    n_slow: 慢速移动平均线周期。
    n_signal: 信号线周期。

  Returns:
    MACD 指标序列。
  """

  # 计算快速移动平均线。
  fast_ema = al.DMA(close, (2.0 / (fast + 1)))

  # 计算慢速移动平均线。
  slow_ema = al.DMA(close, (2.0 / (slow + 1)))

  # 计算差分值。
  difference = fast_ema - slow_ema

  # 计算信号线。
  signal_line = al.DMA(difference, (2.0 / (signal + 1)))

  return difference, signal_line
  
def RSI(close: np.ndarray, n: int = 14) -> np.ndarray:
  """
  计算 RSI 指标。

  Args:
    close: 收盘价序列。
    n: 移动平均线周期。

  Returns:
    RSI 指标序列。
  """
  last = al.REF(close, 1)
  diff = close - last
  up = np.where(diff > 0, diff, 0)
  down = np.where(diff < 0, -diff, 0)
  rs = al.SMA(up, n, 1) / al.SMA(down, n, 1)
  return 100 - 100 / (1 + rs)


def BBANDS(close: np.ndarray, n: int = 20, k: float = 2.0) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
  """
  计算布林带指标。

  Args:
    close: 收盘价序列。
    n: 移动平均线周期。
    k: 标准差倍数。

  Returns:
    布林带指标序列。
  """
  mid = al.MA(close, n)
  std = al.STDDEV(close, n)
  upper = mid + k * std
  lower = mid - k * std
  return upper, mid, lower


def OBV(close: np.ndarray, volume: np.ndarray) -> np.ndarray:
  """
  计算OBV指标。

  Args:
    close: 收盘价序列。
    volume: 成交量序列。

  Returns:
    OBV指标序列。
  """
  return al.SUM(np.where(close > al.REF(close, 1), volume, np.where(close < al.REF(close, 1), -volume, 0)), len(close))


def ATR(close: np.ndarray, high: np.ndarray, low: np.ndarray, n: int = 14) -> np.ndarray:
  """
  计算ATR指标。

  Args:
    close: 收盘价序列。
    high: 最高价序列。
    low: 最低价序列。
    n: 移动平均线周期。

  Returns:
    ATR指标序列。
  """
  tr = np.maximum(high - low, np.maximum(np.abs(close - al.REF(close, 1)), np.abs(high - al.REF(close, 1))))
  return al.MA(tr, n)