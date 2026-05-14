# pptx-mcp-skill

Claude Code から MCP（Model Context Protocol）を通じて、要件テキストをもとに PowerPoint 資料を自動生成するためのスキル・設定リポジトリです。

## 概要

```
要件テキスト
    ↓
Claude Code（要件を解釈・スライド構成を立案）
    ↓ MCP 呼び出し
Office-PowerPoint-MCP-Server（python-pptx で .pptx 生成）
    ↓
.pptx ファイル出力
```

**使用する MCP サーバー**: [GongRzhe/Office-PowerPoint-MCP-Server](https://github.com/GongRzhe/Office-PowerPoint-MCP-Server)
- python-pptx ベースのローカル MCP サーバー
- 32 ツール・11 モジュール構成
- MIT ライセンス・OSSで改変自由

---

## リポジトリ構成

```
pptx-mcp-skill/
├── README.md                  # このファイル
├── .mcp.json                  # Claude Code 用 MCP 設定
│
├── skill/
│   ├── SKILL.md               # Claude が読むエントリポイント（必須）
│   ├── setup.md               # MCP サーバーの起動・設定手順
│   ├── requirements.md        # 要件整理テンプレート・質問項目
│   └── pptx-generation.md    # スライド生成ガイドライン・ツール一覧
│
├── examples/
│   ├── business-proposal.md   # 使用例：事業提案資料
│   └── technical-report.md    # 使用例：技術報告資料
│
├── output/                    # 生成した .pptx ファイルの保存先
│
├── template/                  # スライドマスター用 .pptx テンプレート置き場
│
├── references/                # 参考資料置き場（ロゴ・カラーガイドライン・サンプルなど）
│
└── scripts/
    └── verify-mcp.ps1         # MCP サーバー動作確認スクリプト（Windows）
```

---

## クイックスタート

### 1. 前提条件

| ツール | バージョン | 確認コマンド |
|--------|-----------|-------------|
| Python | 3.8 以上 | `python --version` |
| uvx | 最新 | `uvx --version` |
| Claude Code | 最新 | `claude --version` |

`uvx` が未インストールの場合：

```bash
pip install uv
```

### 2. MCP サーバーを Claude Code に追加

```bash
claude mcp add ppt -- uvx --from office-powerpoint-mcp-server ppt_mcp_server
```

追加確認：

```bash
claude mcp list
```

`ppt` が表示されれば OK です。

### 3. スキルを有効化

このリポジトリを Claude Code のプロジェクトに配置し、`skill/SKILL.md` を参照させます。詳細は [skill/setup.md](skill/setup.md) を参照してください。

### 4. 資料を生成する

Claude Code で以下のように依頼します：

```
要件：
- 目的：新サービスの社内提案
- 対象：経営層（非技術者）
- 枚数：8〜10 枚
- トーン：フォーマル

この要件をもとに PowerPoint 資料を作成してください。
```

> 生成された .pptx ファイルは `output/` ディレクトリに保存されます。

---

## 詳細ドキュメント

| ドキュメント | 内容 |
|-------------|------|
| [skill/setup.md](skill/setup.md) | MCP サーバーの起動・設定・トラブルシューティング |
| [skill/requirements.md](skill/requirements.md) | 要件整理の手順・テンプレート |
| [skill/pptx-generation.md](skill/pptx-generation.md) | スライド新規生成のガイドライン・ツール使用方法 |
| [skill/pptx-editing.md](skill/pptx-editing.md) | 既存 PPTX への追加・編集のガイドライン |
| [skill/SKILL.md](skill/SKILL.md) | Claude Code 用スキル定義（変更不要） |

---

## 参考資料

`references/` ディレクトリに、資料作成時に参照できる素材を格納しています。

- ブランドガイドライン・カラーパレット
- 既存のテンプレートファイル（.pptx）
- ロゴ・アイコン等の画像素材
- 過去の資料サンプル

> 資料生成・編集時に `references/` 内のファイルを参考として利用してください。

---

## テンプレート（スライドマスター）

`template/` に .pptx ファイルを配置すると、資料生成・編集時にそのファイルのスライドマスターが自動的に引き継がれます。

```
template/
└── company-template.pptx  ← 社内ブランドのフォント・カラー・背景が定義されたファイル
```

- `template/` に .pptx がある場合：`open_presentation` でベースとして開き、スライドマスターを継承した上でスライドを追加・編集する
- `template/` が空の場合：`create_presentation` で新規作成し、`color_scheme` でデザインを適用する
- 生成・編集結果は必ず `output/` に保存し、`template/` 内のファイルは上書きしない

---

## ライセンス

MIT
