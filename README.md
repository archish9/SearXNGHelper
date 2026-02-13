# SearXNGHelper & Search MCP Backend

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy)

A deployable, pre-configured **SearXNG** instance optimized for **Agentic AI** use cases. This repository provides the backend infrastructure to give AI agents (Claude, Cursor, Windsurf, etc.) **unlimited, free, and private web search** capabilities via the Model Context Protocol (MCP).

## 🚀 Why This Exists

Commercial search APIs (Brave, Tavily, Bing) have rate limits and costs. Standard SearXNG Docker images come with rate limiting enabled and conservative settings that can block AI agents.

**This repository solves that by providing:**
*   **Zero Rate Limits**: `limiter: false` is baked into the config.
*   **Maximized Engine Support**: 150+ engines enabled out-of-the-box (Google, Bing, DuckDuckGo, Reddit, Arxiv, Genius, etc.).
*   **JSON API Ready**: Formats enabled for easy machine parsing (`json`, `csv`, `rss`).
*   **Stateless Deployment**: `settings.yml` is baked into the Docker image, making it perfect for ephemeral hosting like **Render Free Tier**.

## 🛠️ Project Structure

*   `Dockerfile`: Creates a custom image based on `searxng/searxng` with our config injected.
*   `settings.yml`: The "magic" configuration file with:
    *   No rate limiting.
    *   JSON enabled.
    *   Hundreds of search engines enabled.
*   `chat.md`: Contextual guide on setting up the full MCP pipeline.

---

## 📦 Deployment Guide

### Option 1: Deploy on Render (Free Tier Recommended)

This is the easiest way to get a public HTTPS URL for your agent.

1.  **Fork/Clone** this repository.
2.  Go to [Render Dashboard](https://dashboard.render.com/) → **New Web Service**.
3.  Connect your repository.
4.  **Runtime**: `Docker`.
5.  **Instance Type**: `Free`.
6.  **Environment Variables**:
    *   `BASE_URL`: `https://your-service-name.onrender.com/` (Update this after the first deploy provides your URL).
7.  **Deploy**.

**Pro Tip**: Use [UptimeRobot](https://uptimerobot.com/) to ping your Render URL every 5 minutes to prevent the free tier instance from sleeping.

### Option 2: Run Locally (Docker)

```bash
# Build the image
docker build -t my-searxng .

# Run it
docker run -d \
  -p 8080:8080 \
  -e BASE_URL=http://localhost:8080/ \
  -e INSTANCE_NAME=MyPrivateSearch \
  my-searxng
```

Access at: `http://localhost:8080`

---

## 🔌 How to Connect to AI Agents (MCP)

Once deployed, this server acts as the **backend**. You need an **MCP Server** to bridge the gap between your AI Client (Claude/Cursor) and this backend.

### Recommended MCP Servers

You can use any standard SearXNG MCP server. Point it to your deployed URL.

**Example Configuration (`claude_desktop_config.json`):**

```json
{
  "mcpServers": {
    "searxng": {
      "command": "uvx",
      "args": [
        "mcp-searxng",
        "--searxng-url", "https://your-render-app.onrender.com"
      ]
    }
  }
}
```

*Note: The specific MCP implementation you choose (e.g., `mcp-searxng` or `searxng-mcp`) handles the actual tool registration (Search, news, etc.). This repo provides the raw search engine power.*

## ✨ Features

*   **Privacy**: No tracking, no profiling. Proxies requests to Google/Bing so they don't see your IP.
*   **Unlimited**: Hammer it with requests from your agent loop; it won't 429 you (dependent on your hardware/VPS bandwidth).
*   **Broad Coverage**: specialized engines for:
    *   **Code**: GitHub, StackOverflow, Bitbucket.
    *   **Science**: Arxiv, PubMed, Google Scholar.
    *   **Media**: Youtube, Vimeo, SoundCloud.
    *   **Files**: Torrents, Magnet links (1337x, PirateBay).

## ⚠️ Disclaimer

This project uses public search engines. While SearXNG rotates user agents and tries to prevent blocking, aggressive scraping from a single IP (like a VPS) *can* lead to temporary CAPTCHAs from upstream providers (Google/Bing). Rotating proxies configured in `settings.yml` (not included by default) can mitigate this.