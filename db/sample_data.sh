#!/bin/bash

OBJ='SZ002594'

msd shell -o sample/stock_kline_1d.csv "select * from stock_kline_1d where obj='$OBJ' limit -2000"
msd shell -o sample/stock_shares.csv "select * from stock_shares where obj='$OBJ'"
msd shell -o sample/stock_financial.csv "select * from stock_financial where obj='$OBJ'"
msd shell -o sample/stock_dividend.csv "select * from stock_dividend where obj='$OBJ'"
msd shell -o sample/stock_capital_flow.csv "select * from stock_capital_flow where obj='$OBJ'"