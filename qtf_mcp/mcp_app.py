from io import StringIO

from mcp.server.fastmcp import Context, FastMCP
from starlette.applications import Starlette
from starlette.middleware.cors import CORSMiddleware
from . import research


class QtfMCP(FastMCP):

  def streamable_http_app(self) -> Starlette:
    super_app = super().streamable_http_app()
    super_app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])
    return super_app

# Create an MCP server
mcp_app = QtfMCP(
  "CnStock",
  sse_path="/cnstock/sse",
  message_path="/cnstock/messages/",
  streamable_http_path="/cnstock/mcp",
  stateless_http=True,
)


@mcp_app.tool()
async def brief(symbol: str, ctx: Context) -> str:
  """Get brief information for a given stock symbol, including
  - basic data
  - trading data
  Args:
    symbol (str): Stock symbol, must be in the format of "SH000001" or "SZ000001", you should infer user inputs like stock name to stock symbol
  """
  who = ctx.request_context.request.client.host  # type: ignore
  raw_data = await research.load_raw_data(symbol, None, who)
  buf = StringIO()
  if len(raw_data) == 0:
    return "No data found for symbol: " + symbol
  research.build_basic_data(buf, symbol, raw_data)
  research.build_trading_data(buf, symbol, raw_data)
  """Get brief information for a given stock symbol"""
  return buf.getvalue()


@mcp_app.tool()
async def medium(symbol: str, ctx: Context) -> str:
  """Get medium information for a given stock symbol, including
  - basic data
  - trading data
  - financial data
  Args:
    symbol (str): Stock symbol, must be in the format of "SH000001" or "SZ000001", you infer convert user inputs like stock name to stock symbol
  """
  who = ctx.request_context.request.client.host  # type: ignore
  raw_data = await research.load_raw_data(symbol, None, who)
  buf = StringIO()
  if len(raw_data) == 0:
    return "No data found for symbol: " + symbol
  research.build_basic_data(buf, symbol, raw_data)
  research.build_trading_data(buf, symbol, raw_data)
  research.build_financial_data(buf, symbol, raw_data)
  return buf.getvalue()


@mcp_app.tool()
async def full(symbol: str, ctx: Context) -> str:
  """Get full information for a given stock symbol, including
  - basic data
  - trading data
  - financial data
  - technical analysis data
  Args:
    symbol (str): Stock symbol, must be in the format of "SH000001" or "SZ000001", you should infer user inputs like stock name to stock symbol
  """
  who = ctx.request_context.request.client.host  # type: ignore
  raw_data = await research.load_raw_data(symbol, None, who)
  buf = StringIO()
  if len(raw_data) == 0:
    return "No data found for symbol: " + symbol
  research.build_basic_data(buf, symbol, raw_data)
  research.build_trading_data(buf, symbol, raw_data)
  research.build_financial_data(buf, symbol, raw_data)
  research.build_technical_data(buf, symbol, raw_data)
  return buf.getvalue()
