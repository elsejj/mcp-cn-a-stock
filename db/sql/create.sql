-- 日线表
-- 此表会在 stock_snapshot 更新时自动更新
-- 亦可直接更新此表
-- 由于其指定了 round='1d', 所以在更新时, 如果插入的数据的 ts 属于同一天, 则会覆盖
create table stock_kline_1d (
  ts datetime,
  open decimal,
  high decimal,
  low decimal,
  close decimal ,
  volume double,
  amount double
) with (
  chunkSize = 250,
  round='1d'
);

-- 分钟线表
-- 此表会在 stock_snapshot 更新时自动更新
-- 自动更新时, 会根据 AGG_ 标识进行相关聚合
-- 由于其指定了 round='1m', 所以在更新时, 如果插入的数据的 ts 属于同一分钟, 则会进行聚合更新
-- 聚会更新依赖 stock_snapshot 的变动频次, 越频繁则结果越接近事实
-- 亦可直接更新此表
create table stock_kline_1m (
  ts datetime,
  open decimal AGG_FIRST,
  high decimal AGG_MAX,
  low decimal AGG_MIN,
  close decimal,
  volume double AGG_DIFF_FIRST,
  amount double AGG_DIFF_FIRST
) with (
  chunkSize = 250,
  round='1m'
);

-- 快照表
-- 由于没有指定 round, 所以当 ts 不相同时即插入新的一行
-- 该表指定了 `chan`, 所以当 stock_snapshot 更新时, 会自动更新 stock_kline_1m 和 stock_kline_1d
create table stock_snapshot (
  ts datetime,
  open decimal,
  high decimal,
  low decimal,
  close decimal,
  volume double,
  amount double,
  pre_close decimal
) with (
  chunkSize = 500,
  chan = '
  stock_kline_1m:ts,changed_if(open, close),changed_if(high, close),changed_if(low, close),close,volume,amount
  stock_kline_1d:ts,open,high,low,close,volume,amount
  '
);

-- 除权除息表
create table stock_dividend (
  ts datetime,
  dividend decimal,
  transfer_shares decimal,
  right_price decimal,
  right_shares decimal
) with (
  chunkSize = 100
);

-- 股本表
create table stock_shares (
  ts datetime,
  total_shares double,
  tradable_shares double,
  tradable_a_shares double,
  tradable_b_shares double,
  tradable_h_shares double
) with (
  chunkSize = 20
);

-- 资金流向表
create table stock_capital_flow (
  ts datetime,
  main_amount d64,
  main_prop d64,
  super_amount d64,
  super_prop d64,
  large_amount d64,
  large_prop d64,
  middle_amount d64,
  middle_prop d64,
  small_amount d64,
  small_prop d64
) with (
  chunkSize = 20,
  round='1d'
);

-- f10 表, 使用 kv 存储
-- kv 表仅包含2列, 其中第一列为主键, 第二列为JSON
create table stock_f10 (
  obj string,
  val string
) WITH (
  engine = 'kv'
);

-- 专业财务数据
CREATE TABLE stock_financial (
  ts datetime,
  f001 double,
  f007 double,
  f075 double,
  f088 double,
  f108 double,
  f194 double,
  f205 double,
  f207 double,
  f213 double,
  f234 double,
  f002 double,
  f008 double,
  f080 double,
  f087 double,
  f092 double,
  f097 double,
  f099 double,
  f115 double,
  f169 double,
  f178 double,
  f180 double,
  f181 double,
  f184 double,
  f185 double,
  f195 double,
  f197 double,
  f204 double,
  f209 double,
  f222 double,
  f223 double,
  f232 double,
  f242 double,
  f000 double,
  f011 double,
  f016 double,
  f017 double,
  f041 double,
  f052 double,
  f063 double,
  f071 double,
  f076 double,
  f093 double,
  f096 double,
  f102 double,
  f120 double,
  f127 double,
  f134 double,
  f160 double,
  f161 double,
  f163 double,
  f166 double,
  f174 double,
  f175 double,
  f179 double,
  f188 double,
  f192 double,
  f193 double,
  f196 double,
  f202 double,
  f206 double,
  f211 double,
  f212 double,
  f219 double,
  f220 double,
  f221 double,
  f233 double,
  f235 double,
  f236 double,
  f237 double,
  f241 double,
  f006 double,
  f021 double,
  f025 double,
  f027 double,
  f028 double,
  f035 double,
  f040 double,
  f044 double,
  f045 double,
  f054 double,
  f055 double,
  f056 double,
  f068 double,
  f073 double,
  f078 double,
  f079 double,
  f082 double,
  f095 double,
  f103 double,
  f107 double,
  f123 double,
  f126 double,
  f131 double,
  f136 double,
  f137 double,
  f139 double,
  f149 double,
  f150 double,
  f151 double,
  f162 double,
  f164 double,
  f165 double,
  f172 double,
  f182 double,
  f183 double,
  f186 double,
  f187 double,
  f189 double,
  f190 double,
  f191 double,
  f198 double,
  f208 double,
  f210 double,
  f214 double,
  f215 double,
  f216 double,
  f218 double,
  f224 double,
  f227 double,
  f240 double,
  f003 double,
  f005 double,
  f009 double,
  f010 double,
  f015 double,
  f026 double,
  f033 double,
  f034 double,
  f039 double,
  f043 double,
  f051 double,
  f059 double,
  f062 double,
  f066 double,
  f074 double,
  f081 double,
  f084 double,
  f085 double,
  f104 double,
  f114 double,
  f116 double,
  f117 double,
  f119 double,
  f121 double,
  f125 double,
  f130 double,
  f138 double,
  f140 double,
  f156 double,
  f158 double,
  f167 double,
  f168 double,
  f170 double,
  f177 double,
  f199 double,
  f200 double,
  f201 double,
  f203 double,
  f217 double,
  f225 double,
  f226 double,
  f228 double,
  f229 double,
  f231 double,
  f238 double,
  f239 double
) with (
  chunkSize = 20
);

comment on table stock_financial is "专业财务数据";
comment on column stock_financial.f001 is "每股指标 >> 净资产收益率";
comment on column stock_financial.f007 is "每股指标 >> 扣除非经常损益每股收益";
comment on column stock_financial.f075 is "利润表 >> 营业收入";
comment on column stock_financial.f088 is "利润表 >> 扣非营业利润";
comment on column stock_financial.f108 is "现金流量表 >> 经营活动产生的现金流量净额";
comment on column stock_financial.f194 is "发展能力分析 >> 主营业务收入增长率";
comment on column stock_financial.f205 is "盈利能力分析 >> 年化净资产收益率";
comment on column stock_financial.f207 is "盈利能力分析 >> 投入资本回报率ROIC";
comment on column stock_financial.f213 is "盈利能力分析 >> 销售毛利率";
comment on column stock_financial.f234 is "现金流量分析 >> 经营现金净流量与净利润的比率";
comment on column stock_financial.f002 is "每股指标 >> 每股经营活动现金流量";
comment on column stock_financial.f008 is "资产负债表 >> 货币资金";
comment on column stock_financial.f080 is "利润表 >> 研发费用";
comment on column stock_financial.f087 is "利润表 >> 营业利润";
comment on column stock_financial.f092 is "利润表 >> 营业总收入";
comment on column stock_financial.f097 is "利润表 >> 净利润(不含少数股东损益)";
comment on column stock_financial.f099 is "现金流量表 >> 销售商品、提供劳务收到的现金";
comment on column stock_financial.f115 is "现金流量表 >> 购建固定资产、无形资产和其他长期资产支付的现金";
comment on column stock_financial.f169 is "偿债能力分析 >> 利息支付倍数";
comment on column stock_financial.f178 is "偿债能力分析 >> 债务总额/EBITDA";
comment on column stock_financial.f180 is "经营效率分析 >> 存货周转天数";
comment on column stock_financial.f181 is "经营效率分析 >> 应收账款周转天数";
comment on column stock_financial.f184 is "经营效率分析 >> 存货周转率";
comment on column stock_financial.f185 is "经营效率分析 >> 应收账款周转率";
comment on column stock_financial.f195 is "发展能力分析 >> 营业利润增长率";
comment on column stock_financial.f197 is "发展能力分析 >> 净利润增长率";
comment on column stock_financial.f204 is "发展能力分析 >> 每股经营性现金流量净额增长率";
comment on column stock_financial.f209 is "盈利能力分析 >> 营业利润率";
comment on column stock_financial.f222 is "盈利能力分析 >> EBITDA/营业总收入";
comment on column stock_financial.f223 is "股本结构分析 >> 资产负债率";
comment on column stock_financial.f232 is "现金流量分析 >> 经营现金净流量对销售收入比率";
comment on column stock_financial.f242 is "现金流量分析 >> 现金营运指数";
comment on column stock_financial.f000 is "每股指标 >> 摊薄每股收益";
comment on column stock_financial.f011 is "资产负债表 >> 应收账款";
comment on column stock_financial.f016 is "资产负债表 >> 合同负债";
comment on column stock_financial.f017 is "资产负债表 >> 存货";
comment on column stock_financial.f041 is "资产负债表 >> 短期借款";
comment on column stock_financial.f052 is "资产负债表 >> 一年内到期的非流动负债";
comment on column stock_financial.f063 is "资产负债表 >> 负债合计";
comment on column stock_financial.f071 is "资产负债表 >> 股东权益合计(不含少数股东权益)";
comment on column stock_financial.f076 is "利润表 >> 营业成本";
comment on column stock_financial.f093 is "利润表 >> 利润总额";
comment on column stock_financial.f096 is "利润表 >> 净利润(含少数股东损益)";
comment on column stock_financial.f102 is "现金流量表 >> 经营活动现金流入小计";
comment on column stock_financial.f120 is "现金流量表 >> 投资活动产生的现金流量净额";
comment on column stock_financial.f127 is "现金流量表 >> 分配股利、利润或偿付利息支付的现金";
comment on column stock_financial.f134 is "现金流量表 >> 现金及现金等价物净增加额";
comment on column stock_financial.f160 is "偿债能力分析 >> 流动比率";
comment on column stock_financial.f161 is "偿债能力分析 >> 速动比率";
comment on column stock_financial.f163 is "偿债能力分析 >> 负债权益比率";
comment on column stock_financial.f166 is "偿债能力分析 >> 权益乘数";
comment on column stock_financial.f174 is "偿债能力分析 >> 债务保障率";
comment on column stock_financial.f175 is "偿债能力分析 >> 现金流量比率";
comment on column stock_financial.f179 is "经营效率分析 >> 营业周期";
comment on column stock_financial.f188 is "经营效率分析 >> 总资产周转率";
comment on column stock_financial.f192 is "经营效率分析 >> 存货同比增长率";
comment on column stock_financial.f193 is "经营效率分析 >> 应收账款同比增长率";
comment on column stock_financial.f196 is "发展能力分析 >> 利润总额增长率";
comment on column stock_financial.f202 is "发展能力分析 >> 摊薄每股收益增长率";
comment on column stock_financial.f206 is "盈利能力分析 >> 总资产净利润率";
comment on column stock_financial.f211 is "盈利能力分析 >> 销售净利率";
comment on column stock_financial.f212 is "盈利能力分析 >> 总资产报酬率";
comment on column stock_financial.f219 is "盈利能力分析 >> 营业利润比重";
comment on column stock_financial.f220 is "盈利能力分析 >> 每股息税折旧摊销前利润EBITDA";
comment on column stock_financial.f221 is "盈利能力分析 >> 每股息税前利润EBIT";
comment on column stock_financial.f233 is "现金流量分析 >> 资产的经营现金流量回报率";
comment on column stock_financial.f235 is "现金流量分析 >> 经营现金净流量对负债比率";
comment on column stock_financial.f236 is "现金流量分析 >> 每股营业现金流量";
comment on column stock_financial.f237 is "现金流量分析 >> 每股经营活动现金流量净额";
comment on column stock_financial.f241 is "现金流量分析 >> 现金流量满足率";
comment on column stock_financial.f006 is "每股指标 >> 每股主营收入";
comment on column stock_financial.f021 is "资产负债表 >> 流动资产合计";
comment on column stock_financial.f025 is "资产负债表 >> 长期股权投资";
comment on column stock_financial.f027 is "资产负债表 >> 固定资产";
comment on column stock_financial.f028 is "资产负债表 >> 在建工程";
comment on column stock_financial.f035 is "资产负债表 >> 商誉";
comment on column stock_financial.f040 is "资产负债表 >> 资产总计";
comment on column stock_financial.f044 is "资产负债表 >> 应付账款";
comment on column stock_financial.f045 is "资产负债表 >> 预收账款";
comment on column stock_financial.f054 is "资产负债表 >> 流动负债合计";
comment on column stock_financial.f055 is "资产负债表 >> 长期借款";
comment on column stock_financial.f056 is "资产负债表 >> 应付债券";
comment on column stock_financial.f068 is "资产负债表 >> 未分配利润";
comment on column stock_financial.f073 is "资产负债表 >> 股东权益合计(含少数股东权益)";
comment on column stock_financial.f078 is "利润表 >> 销售费用";
comment on column stock_financial.f079 is "利润表 >> 管理费用";
comment on column stock_financial.f082 is "利润表 >> 资产减值损失";
comment on column stock_financial.f095 is "利润表 >> 营业总成本";
comment on column stock_financial.f103 is "现金流量表 >> 购买商品、接受劳务支付的现金";
comment on column stock_financial.f107 is "现金流量表 >> 经营活动现金流出小计";
comment on column stock_financial.f123 is "现金流量表 >> 取得借款收到的现金";
comment on column stock_financial.f126 is "现金流量表 >> 偿还债务支付的现金";
comment on column stock_financial.f131 is "现金流量表 >> 筹资活动产生的现金流量净额";
comment on column stock_financial.f136 is "现金流量表 >> 期末现金及现金等价物余额";
comment on column stock_financial.f137 is "现金流量表 >> 净利润";
comment on column stock_financial.f139 is "现金流量表 >> 固定资产折旧、油气资产折耗、生产性生物资产折旧";
comment on column stock_financial.f149 is "现金流量表 >> 存货的减少";
comment on column stock_financial.f150 is "现金流量表 >> 经营性应收项目的减少";
comment on column stock_financial.f151 is "现金流量表 >> 经营性应付项目的增加";
comment on column stock_financial.f162 is "偿债能力分析 >> 现金比率";
comment on column stock_financial.f164 is "偿债能力分析 >> 股东权益比率";
comment on column stock_financial.f165 is "偿债能力分析 >> 股东权益对负债比率";
comment on column stock_financial.f172 is "偿债能力分析 >> 有形净值债务率";
comment on column stock_financial.f182 is "经营效率分析 >> 流动资产周转天数";
comment on column stock_financial.f183 is "经营效率分析 >> 总资产周转天数";
comment on column stock_financial.f186 is "经营效率分析 >> 流动资产周转率";
comment on column stock_financial.f187 is "经营效率分析 >> 固定资产周转率";
comment on column stock_financial.f189 is "经营效率分析 >> 净资产周转率";
comment on column stock_financial.f190 is "经营效率分析 >> 股东权益周转率";
comment on column stock_financial.f191 is "经营效率分析 >> 营运资金周转率";
comment on column stock_financial.f198 is "发展能力分析 >> 净资产增长率";
comment on column stock_financial.f208 is "盈利能力分析 >> 成本费用利润率";
comment on column stock_financial.f210 is "盈利能力分析 >> 主营业务成本率";
comment on column stock_financial.f214 is "盈利能力分析 >> 三项费用比重";
comment on column stock_financial.f215 is "盈利能力分析 >> 营业费用率";
comment on column stock_financial.f216 is "盈利能力分析 >> 管理费用率";
comment on column stock_financial.f218 is "盈利能力分析 >> 非主营比重";
comment on column stock_financial.f224 is "股本结构分析 >> 股东权益比率";
comment on column stock_financial.f227 is "股本结构分析 >> 负债与所有者权益比率";
comment on column stock_financial.f240 is "现金流量分析 >> 每股现金及现金等价物净增加额";
comment on column stock_financial.f003 is "每股指标 >> 每股净资产";
comment on column stock_financial.f005 is "每股指标 >> 每股未分配利润";
comment on column stock_financial.f009 is "资产负债表 >> 交易性金融资产";
comment on column stock_financial.f010 is "资产负债表 >> 应收票据";
comment on column stock_financial.f015 is "资产负债表 >> 其他应收款";
comment on column stock_financial.f026 is "资产负债表 >> 投资性房地产";
comment on column stock_financial.f033 is "资产负债表 >> 无形资产";
comment on column stock_financial.f034 is "资产负债表 >> 开发支出";
comment on column stock_financial.f039 is "资产负债表 >> 非流动资产合计";
comment on column stock_financial.f043 is "资产负债表 >> 应付票据";
comment on column stock_financial.f051 is "资产负债表 >> 应付关联公司款";
comment on column stock_financial.f059 is "资产负债表 >> 预计负债";
comment on column stock_financial.f062 is "资产负债表 >> 非流动负债合计";
comment on column stock_financial.f066 is "资产负债表 >> 库存股";
comment on column stock_financial.f074 is "资产负债表 >> 负债和股东权益合计";
comment on column stock_financial.f081 is "利润表 >> 财务费用";
comment on column stock_financial.f084 is "利润表 >> 投资收益";
comment on column stock_financial.f085 is "利润表 >> 其中：对联营企业和合营企业的投资收益";
comment on column stock_financial.f104 is "现金流量表 >> 支付给职工以及为职工支付的现金";
comment on column stock_financial.f114 is "现金流量表 >> 投资活动现金流入小计";
comment on column stock_financial.f116 is "现金流量表 >> 投资所支付的现金";
comment on column stock_financial.f117 is "现金流量表 >> 取得子公司及其他营业单位支付的现金净额";
comment on column stock_financial.f119 is "现金流量表 >> 投资活动现金流出小计";
comment on column stock_financial.f121 is "现金流量表 >> 吸收投资所收到的现金";
comment on column stock_financial.f125 is "现金流量表 >> 筹资活动现金流入小计";
comment on column stock_financial.f130 is "现金流量表 >> 筹资活动现金流出小计";
comment on column stock_financial.f138 is "现金流量表 >> 资产减值准备";
comment on column stock_financial.f140 is "现金流量表 >> 无形资产摊销";
comment on column stock_financial.f156 is "现金流量表 >> 现金的期末余额";
comment on column stock_financial.f158 is "现金流量表 >> 现金等价物的期末余额";
comment on column stock_financial.f167 is "偿债能力分析 >> 长期债务与营运资金比率";
comment on column stock_financial.f168 is "偿债能力分析 >> 长期负债比率";
comment on column stock_financial.f170 is "偿债能力分析 >> 股东权益与固定资产比率";
comment on column stock_financial.f177 is "偿债能力分析 >> 每股营运资金";
comment on column stock_financial.f199 is "发展能力分析 >> 流动资产增长率";
comment on column stock_financial.f200 is "发展能力分析 >> 固定资产增长率";
comment on column stock_financial.f201 is "发展能力分析 >> 总资产增长率";
comment on column stock_financial.f203 is "发展能力分析 >> 每股净资产增长率";
comment on column stock_financial.f217 is "盈利能力分析 >> 财务费用率";
comment on column stock_financial.f225 is "股本结构分析 >> 长期负债比率";
comment on column stock_financial.f226 is "股本结构分析 >> 股东权益与固定资产比率";
comment on column stock_financial.f228 is "股本结构分析 >> 长期资产与长期资金比率";
comment on column stock_financial.f229 is "股本结构分析 >> 资本化比率";
comment on column stock_financial.f231 is "股本结构分析 >> 固定资产比重";
comment on column stock_financial.f238 is "现金流量分析 >> 每股投资活动产生的现金流量净额";
comment on column stock_financial.f239 is "现金流量分析 >> 每股筹资活动产生的现金流量净额";
