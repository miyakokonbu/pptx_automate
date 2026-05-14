# MCP サーバー セットアップ手順

Office-PowerPoint-MCP-Server を Claude Code で使えるようにするための手順書です。

---

## 前提条件

| ツール | 最低バージョン | インストール方法 |
|--------|--------------|----------------|
| Python | 3.8 以上 | [python.org](https://www.python.org/) |
| uv / uvx | 最新 | `pip install uv` |
| Claude Code | 最新 | `npm install -g @anthropic-ai/claude-code` |

### バージョン確認

```bash
python --version
uvx --version
claude --version
```

---

## インストール方法（推奨: uvx）

uvx を使う方法はローカルへのインストールが不要で最もシンプルです。

### Claude Code への MCP サーバー追加

```bash
claude mcp add ppt -- uvx --from office-powerpoint-mcp-server ppt_mcp_server
```

### 追加確認

```bash
claude mcp list
```

以下のような出力が表示されれば成功です：

```
ppt: uvx --from office-powerpoint-mcp-server ppt_mcp_server
```

---

## インストール方法（代替: git clone）

uvx が使えない環境向けの手順です。

```bash
# リポジトリをクローン
git clone https://github.com/GongRzhe/Office-PowerPoint-MCP-Server.git
cd Office-PowerPoint-MCP-Server

# 依存関係をインストール
pip install -r requirements.txt

# Claude Code に登録
claude mcp add ppt -- python /absolute/path/to/ppt_mcp_server.py
```

> **注意**: `/absolute/path/to/` は実際のパスに置き換えてください。

---

## .mcp.json による設定（プロジェクト単位）

リポジトリルートに `.mcp.json` を置くと、プロジェクト単位で MCP サーバーを自動登録できます。
このリポジトリの `.mcp.json` は以下の内容です：

```json
{
  "mcpServers": {
    "ppt": {
      "command": "uvx",
      "args": [
        "--from",
        "office-powerpoint-mcp-server",
        "ppt_mcp_server"
      ],
      "env": {}
    }
  }
}
```

Claude Code でこのリポジトリを開くと、`.mcp.json` が自動的に読み込まれます。

---

## 動作確認

以下のコマンドで MCP サーバーが正常に動作しているか確認します：

```bash
bash scripts/verify-mcp.sh
```

または Claude Code 上で直接確認：

```
MCP ツール "ppt" を使って空のプレゼンテーションを作成して、output/test.pptx として保存してください。
```

`output/test.pptx` が生成されれば正常に動作しています。

---

## HTTP サーバーモード（チーム共有用）

チームで MCP サーバーを共有する場合は HTTP モードで起動します。

```bash
# HTTP サーバーとして起動（ポート 8000）
uvx --from office-powerpoint-mcp-server ppt_mcp_server --transport http --port 8000
```

Claude Code からリモート接続する場合：

```bash
claude mcp add ppt --transport http http://your-server:8000
```

> **セキュリティ注意**: 社内ネットワーク内でのみ使用してください。外部公開する場合は認証を追加してください。

---

## Docker で起動する場合

```bash
# イメージをビルド（Office-PowerPoint-MCP-Server リポジトリ内で実行）
docker build -t ppt-mcp-server .

# HTTP モードで起動
docker run -d --rm -p 8000:8000 ppt-mcp-server -t http
```

---

## トラブルシューティング

### `uvx: command not found`

```bash
pip install uv
# PATH を更新して再試行
export PATH="$HOME/.local/bin:$PATH"
```

### `ppt` が `claude mcp list` に表示されない

```bash
# 一度削除して再追加
claude mcp remove ppt
claude mcp add ppt -- uvx --from office-powerpoint-mcp-server ppt_mcp_server
```

### `ModuleNotFoundError: No module named 'pptx'`

git clone 方式の場合、依存関係が不足しています：

```bash
pip install python-pptx
# または
pip install -r requirements.txt
```

### タイムアウトエラー

初回起動時に uvx がパッケージをダウンロードするため時間がかかります。
ネットワーク環境が良い状態で再試行してください。

---

## テンプレート・参考資料

| ディレクトリ | 用途 |
|------------|------|
| `template/` | スライドマスター用 .pptx テンプレート。ここに .pptx があれば生成・編集のベースとして使用し、スライドマスターを引き継ぐ |
| `references/` | ブランドロゴ・カラーガイドライン・過去資料サンプル等の参考素材 |

> `template/` 内のファイルは読み取り専用として扱い、上書き保存しないこと。

---

## アップデート方法

uvx 方式の場合、常に最新版が使用されます（キャッシュをクリアする場合）：

```bash
uvx cache clean
```

git clone 方式の場合：

```bash
cd Office-PowerPoint-MCP-Server
git pull
pip install -r requirements.txt
```
