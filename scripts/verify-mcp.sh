#!/usr/bin/env bash
# verify-mcp.sh - MCP サーバーの動作確認スクリプト

set -e

echo "=== pptx-mcp-skill: 動作確認 ==="
echo ""

# 1. uvx の確認
echo "[1/3] uvx の確認..."
if command -v uvx &>/dev/null; then
  echo "  ✓ uvx: $(uvx --version 2>&1 | head -1)"
else
  echo "  ✗ uvx が見つかりません。pip install uv を実行してください。"
  exit 1
fi

# 2. Claude Code の確認
echo "[2/3] Claude Code の確認..."
if command -v claude &>/dev/null; then
  echo "  ✓ claude: $(claude --version 2>&1 | head -1)"
else
  echo "  ✗ claude が見つかりません。Claude Code をインストールしてください。"
  exit 1
fi

# 3. MCP サーバー登録確認
echo "[3/3] MCP サーバー 'ppt' の登録確認..."
if claude mcp list 2>/dev/null | grep -q "^ppt"; then
  echo "  ✓ 'ppt' MCP サーバーが登録されています。"
else
  echo "  ✗ 'ppt' が未登録です。以下のコマンドで追加してください："
  echo ""
  echo "    claude mcp add ppt -- uvx --from office-powerpoint-mcp-server ppt_mcp_server"
  echo ""
  exit 1
fi

echo ""
echo "=== すべての確認が完了しました ✓ ==="
echo ""
echo "Claude Code で以下のように依頼してください："
echo ""
echo "  「要件：目的=新サービス提案、対象=経営層、枚数=8枚"
echo "   この要件をもとに PowerPoint 資料を作成してください。」"
