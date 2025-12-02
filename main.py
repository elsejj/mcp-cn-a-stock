from dotenv import load_dotenv

load_dotenv(override=True)
import logging

logging.basicConfig(level=logging.WARN, format="%(asctime)s %(levelname)s %(message)s")

logger = logging.getLogger("qtf_mcp")
logger.setLevel(logging.DEBUG)

import click

from qtf_mcp import mcp_app
from qtf_mcp.symbols import load_symbols


@click.command()
@click.option("--port", default=8000, help="Port to listen on for SSE")
@click.option(
  "--transport",
  type=click.Choice(["stdio", "sse", "http"], case_sensitive=False),
  default="http",
  help="Transport type",
)
def main(port: int, transport: str) -> int:
  load_symbols()
  if transport == "http":
    transport = "streamable-http"
  mcp_app.settings.port = port
  mcp_app.settings.log_level = "WARNING"
  logger.info(f"Starting MCP app on port {port} with transport {transport}")
  mcp_app.run(transport)  # type: ignore
  return 0


if __name__ == "__main__":
  main()
