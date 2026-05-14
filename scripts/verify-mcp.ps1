# verify-mcp.ps1 - MCP サーバーの動作確認スクリプト

$ErrorActionPreference = "Stop"

Write-Host "=== pptx-mcp-skill: 動作確認 ===" -ForegroundColor Cyan
Write-Host ""

# 1. uvx の確認
Write-Host "[1/3] uvx の確認..."
if (Get-Command uvx -ErrorAction SilentlyContinue) {
    $uvxVersion = uvx --version 2>&1 | Select-Object -First 1
    Write-Host "  OK uvx: $uvxVersion" -ForegroundColor Green
} else {
    Write-Host "  NG uvx が見つかりません。pip install uv を実行してください。" -ForegroundColor Red
    exit 1
}

# 2. Claude Code の確認
Write-Host "[2/3] Claude Code の確認..."
if (Get-Command claude -ErrorAction SilentlyContinue) {
    $claudeVersion = claude --version 2>&1 | Select-Object -First 1
    Write-Host "  OK claude: $claudeVersion" -ForegroundColor Green
} else {
    Write-Host "  NG claude が見つかりません。Claude Code をインストールしてください。" -ForegroundColor Red
    exit 1
}

# 3. MCP サーバー登録確認
Write-Host "[3/3] MCP サーバー 'ppt' の登録確認..."
$mcpList = claude mcp list 2>&1
if ($mcpList -match "^ppt") {
    Write-Host "  OK 'ppt' MCP サーバーが登録されています。" -ForegroundColor Green
} else {
    Write-Host "  NG 'ppt' が未登録です。以下のコマンドで追加してください：" -ForegroundColor Red
    Write-Host ""
    Write-Host "    claude mcp add ppt -- uvx --from office-powerpoint-mcp-server ppt_mcp_server"
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "=== すべての確認が完了しました ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Claude Code で以下のように依頼してください："
Write-Host ""
Write-Host "  「要件：目的=新サービス提案、対象=経営層、枚数=8枚"
Write-Host "   この要件をもとに PowerPoint 資料を作成してください。」"
