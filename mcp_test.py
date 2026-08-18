import asyncio
import os
import logging

from mcp import ClientSession
from mcp.client.streamable_http import streamablehttp_client
from mcp.shared.metadata_utils import get_display_name

from qtf import msd_fetch_once


MCP_URL = 'http://localhost:50510/mcp'
logger = logging.getLogger(__name__)


async def main():
  async with streamablehttp_client(MCP_URL) as (read_stream, write_stream, _):
    async with ClientSession(read_stream, write_stream) as session:
      logger.debug("Session initializing...")
      await session.initialize()
      logger.debug("Session initialized")

      tools = await session.list_tools()
      for tool in tools:
        logger.info(f'{tool}')
      
      prompts = await session.list_prompts()
      for prompt in prompts:
        logger.info(f'{prompt}')


if __name__ == "__main__":
  logging.basicConfig(level=logging.INFO, format="%(asctime)s %(name)s %(levelname)s %(message)s")
  asyncio.run(main())
