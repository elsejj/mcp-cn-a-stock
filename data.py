from dotenv import load_dotenv
load_dotenv(override=True)

from io import StringIO


from qtf_mcp import research

import logging

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")


async def load_data(symbol: str, start_date: str, end_date: str) -> str:
  raw_data = await research.load_raw_data(symbol)
  buf = StringIO()
  if len(raw_data) == 0:
    return "No data found for symbol: " + symbol
  research.build_basic_data(buf, symbol, raw_data)
  research.build_trading_data(buf, symbol, raw_data)
  research.build_financial_data(buf, symbol, raw_data)
  research.build_technical_data(buf, symbol, raw_data)
  return buf.getvalue()


if __name__ == "__main__":
  import asyncio

  symbol = "SH600537"
  start_date = "2025-01-01"
  end_date = "2026-01-01"
  result = asyncio.run(load_data(symbol, start_date, end_date))
  print(result)
