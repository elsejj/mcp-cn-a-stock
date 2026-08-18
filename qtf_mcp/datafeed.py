import json
import logging
import os
from typing import Dict, List

import numpy as np
from pymsd import create_msd_polars, MsdClient
import polars as pl
import alpha as al

logger = logging.getLogger("qtf_mcp")

msd_host = os.environ.get("MSD_HOST", "")
stock_sector_data = os.environ.get("STOCK_TO_SECTOR_DATA", "confs/stock_sector.json")

if msd_host == "":
  logger.error("MSD_HOST is not set")
  raise ValueError("MSD_HOST is not set")


STOCK_SECTOR: Dict[str, List[str]] | None = None


def get_stock_sector() -> Dict[str, List[str]]:
  global STOCK_SECTOR
  if STOCK_SECTOR is None:
    with open(stock_sector_data, "r", encoding="utf-8") as f:
      STOCK_SECTOR = json.load(f)
  return STOCK_SECTOR if STOCK_SECTOR is not None else {}


def load_data_msd(
  symbol: str, n: int = 200, who: str = ""
) -> Dict[str, np.ndarray]:
  # logger.info(f"align data {symbol} cost {t3 - t2} seconds")
  msd_client: MsdClient[pl.DataFrame] = create_msd_polars(msd_host)


  day = msd_client.load(
    objs=symbol,
    tables=["stock_kline_1d", "stock_dividend", "stock_shares"],
    join={"stock_dividend": "zero", "*": "backward"},
    start=[n, (n//20)+1, (n//20)+1],
    end=None,
  )
  day_np = msd_client.adaptor.to_numpy(day[symbol])

  fin = msd_client.load(
    objs=symbol,
    tables="stock_financial",
    start=20,
    end=None,
  )
  fin_np = msd_client.adaptor.to_numpy(fin[symbol]['stock_financial'])

  capital_flow = msd_client.load(
    objs=symbol,
    tables="stock_capital_flow",
    start=20,
    end=None,
  )
  capital_flow_np = msd_client.adaptor.to_numpy(capital_flow[symbol]['stock_capital_flow'])


  data = {}
  al.set_ctx(groups=1,  flags=al.FLAG_SKIP_NAN)  

  data["DATE"] = day_np["ts"]
  data["OPEN"] =  al.FW_SPLIT(day_np["open"], day_np["dividend"], day_np["transfer_shares"], day_np["right_shares"], day_np["right_price"])
  data["HIGH"] =  al.FW_SPLIT(day_np["high"], day_np["dividend"], day_np["transfer_shares"], day_np["right_shares"], day_np["right_price"])
  data["LOW"] =  al.FW_SPLIT(day_np["low"], day_np["dividend"], day_np["transfer_shares"], day_np["right_shares"], day_np["right_price"])
  data["CLOSE"] =  al.FW_SPLIT(day_np["close"], day_np["dividend"], day_np["transfer_shares"], day_np["right_shares"], day_np["right_price"])
  data["CLOSE2"] = day_np["close"]   # raw price without adjustment
  data["VOLUME"] = day_np["volume"].copy()
  data["AMOUNT"] = day_np["amount"].copy()
  data["TCAP"] = day_np["total_shares"]
  data["TCAP_A"] = day_np["tradable_a_shares"]
  data["NP"] = fin_np["f097"]
  data["MR"] = fin_np["f075"]
  data["EPS"] = fin_np["f000"]
  data["ROE"] = fin_np["f001"]
  data["NAVPS"] = fin_np["f003"]
  data["_DS_FINANCE"] = fin_np
  data["SECTOR"] = get_stock_sector().get(symbol, [])

  del(capital_flow_np['ts'])
  data.update(capital_flow_np)


  return data








if __name__ == "__main__":
  load_data_msd("SH600000", 200, "test")
