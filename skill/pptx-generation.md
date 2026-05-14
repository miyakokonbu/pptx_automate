# スライド生成ガイドライン

MCP サーバー（サーバー名: `ppt`）を使って PowerPoint ファイルを生成するための手順書です。

---

## テンプレートファイルの扱い

**スライド生成前に必ず `template/` ディレクトリを確認すること。**

`template/*.pptx` が存在する場合は、そのファイルを `open_presentation` で開いてベースとして使用する。
こうすることでスライドマスター（フォント・カラー・レイアウト・背景デザイン）が引き継がれ、ブランドに統一された資料が作れる。

```python
# template/ にファイルがある場合の生成フロー
result = mcp_ppt.open_presentation(file_path="template/company-template.pptx")
pid = result["presentation_id"]

# スライドを追加・編集（スライドマスターは自動継承）
mcp_ppt.add_slide(layout_index=1, title="スライドタイトル", presentation_id=pid)

# output/ に保存（テンプレートファイル自体は絶対に上書きしない）
mcp_ppt.save_presentation(file_path="output/ファイル名.pptx", presentation_id=pid)
```

`template/` が空の場合は `create_presentation` で新規作成し、`color_scheme` でデザインを適用する。

---

## 参考資料

テンプレート以外の素材（ブランドロゴ・カラーガイドライン・過去資料サンプル等）は `references/` ディレクトリに格納されています。

---

## 保存先ルール

生成した .pptx ファイルは必ず **`output/` ディレクトリ**に保存すること。

```
save_presentation(file_path="output/ファイル名.pptx", ...)
```

---

## ツール一覧（32 ツール・11 モジュール）

### 基本フロー（最低限使うツール）

| 順序 | ツール名 | 用途 |
|------|---------|------|
| 1 | `create_presentation` | 新規プレゼン作成・`presentation_id` 取得 |
| 2 | `add_slide` | スライドを追加 |
| 3 | `populate_placeholder` | タイトル・本文プレースホルダーに入力 |
| 4 | `add_text_box` | 任意位置にテキスト追加 |
| 5 | `save_presentation` | ファイルを保存 |

### モジュール別ツール詳細

#### presentation_tools（プレゼン管理・7 ツール）

| ツール名 | 説明 |
|---------|------|
| `create_presentation` | 新規プレゼンを作成。`presentation_id` を返す |
| `open_presentation` | 既存 .pptx を開く |
| `save_presentation` | 指定パスに保存 |
| `close_presentation` | プレゼンをメモリから解放 |
| `list_presentations` | 開いているプレゼン一覧 |
| `get_presentation_info` | スライド数・サイズ等の情報取得 |
| `set_document_properties` | タイトル・著者・キーワード等を設定 |

#### content_tools（コンテンツ・6 ツール）

| ツール名 | 説明 |
|---------|------|
| `add_slide` | スライドを追加（`layout_index` でレイアウト選択） |
| `populate_placeholder` | プレースホルダーにテキストを入力 |
| `add_text_box` | 任意位置にテキストボックスを追加 |
| `manage_text` | テキストの追加・編集・削除 |
| `extract_slide_text` | スライドのテキストを抽出 |
| `extract_presentation_text` | 全スライドのテキストを抽出 |

#### template_tools（テンプレート・7 ツール）

| ツール名 | 説明 |
|---------|------|
| `list_templates` | 利用可能なテンプレート一覧（25 種類） |
| `apply_template` | スライドにテンプレートを適用 |
| `create_slide_from_template` | テンプレートから新規スライドを作成 |
| `create_from_template_sequence` | テンプレートの連続適用でプレゼン全体を生成 |
| `get_template_info` | テンプレートの詳細情報を取得 |
| `auto_generate_presentation` | トピック名だけで自動生成（簡易用途向け） |
| `optimize_text_elements` | テキスト要素の読みやすさを最適化 |

#### structural_tools（構造・4 ツール）

| ツール名 | 説明 |
|---------|------|
| `add_table` | 表を追加（セルの書式設定あり） |
| `format_table_cell` | 表のセルを個別書式設定 |
| `add_shape` | 図形を追加 |
| `create_chart` | グラフを追加（棒・折れ線・円・横棒） |

#### professional_tools（デザイン・3 ツール）

| ツール名 | 説明 |
|---------|------|
| `apply_professional_design` | プロ品質のデザインを一括適用 |
| `manage_picture_effects` | 画像エフェクトを設定 |
| `manage_fonts` | フォント解析・最適化・推奨 |

---

## 実装パターン

### パターン 1: シンプルな新規作成

```python
# Step 1: プレゼン作成
result = mcp_ppt.create_presentation()
pid = result["presentation_id"]

# Step 2: タイトルスライド
mcp_ppt.add_slide(layout_index=0, title="タイトル", presentation_id=pid)
mcp_ppt.populate_placeholder(slide_index=0, placeholder_idx=1,
    text="サブタイトル", presentation_id=pid)

# Step 3: コンテンツスライド（箇条書き）
mcp_ppt.add_slide(layout_index=1, title="課題・背景", presentation_id=pid)
mcp_ppt.populate_placeholder(slide_index=1, placeholder_idx=1,
    text="• 課題 A\n• 課題 B\n• 課題 C", presentation_id=pid)

# Step 4: 保存
mcp_ppt.save_presentation(file_path="output/ファイル名.pptx", presentation_id=pid)
```

### パターン 2: テンプレートから生成（推奨）

25 種類の組み込みテンプレートを使うと、プロ品質のスライドを素早く作れます。

```python
# 利用可能なテンプレートを確認
mcp_ppt.list_templates()

# テンプレートシーケンスでプレゼン全体を生成
mcp_ppt.create_from_template_sequence(
    template_sequence=[
        {
            "template_name": "title_slide",
            "content": {
                "title": "新サービス提案",
                "subtitle": "2025年度 事業計画"
            }
        },
        {
            "template_name": "chapter_intro",
            "content": {
                "chapter_number": "01",
                "title": "課題・背景"
            }
        },
        {
            "template_name": "two_column_text",
            "content": {
                "title": "現状の課題",
                "left_content": "課題 A の詳細説明",
                "right_content": "課題 B の詳細説明"
            }
        },
        {
            "template_name": "thank_you_slide",
            "content": {
                "message": "ご清聴ありがとうございました",
                "contact": "担当: 山田 太郎 / yamada@example.com"
            }
        }
    ],
    output_path="output/ファイル名.pptx"
)
```

### パターン 3: 既存テンプレートファイルをベースに生成

```python
# 既存 .pptx を開く
result = mcp_ppt.open_presentation(file_path="template.pptx")
pid = result["presentation_id"]

# スライドを追加・編集
mcp_ppt.add_slide(layout_index=1, title="新しいスライド", presentation_id=pid)

# 別名で保存（元テンプレートを保持）
mcp_ppt.save_presentation(file_path="output/ファイル名.pptx", presentation_id=pid)
```

### パターン 4: データを含む資料（表・グラフ）

```python
pid = mcp_ppt.create_presentation()["presentation_id"]

# グラフスライド
mcp_ppt.add_slide(layout_index=5, title="売上推移", presentation_id=pid)
mcp_ppt.create_chart(
    slide_index=1,
    chart_type="line",  # bar | line | pie | bar_stacked
    title="月次売上推移",
    categories=["1月", "2月", "3月", "4月"],
    series=[
        {"name": "2024年", "values": [100, 120, 110, 140]},
        {"name": "2025年", "values": [130, 150, 145, 180]}
    ],
    presentation_id=pid
)

# 表スライド
mcp_ppt.add_slide(layout_index=5, title="コスト比較", presentation_id=pid)
mcp_ppt.add_table(
    slide_index=2,
    rows=4, cols=3,
    data=[
        ["項目", "現状", "提案後"],
        ["人件費", "500万", "400万"],
        ["システム費", "200万", "150万"],
        ["合計", "700万", "550万"]
    ],
    presentation_id=pid
)

mcp_ppt.save_presentation(file_path="output/ファイル名.pptx", presentation_id=pid)
```

---

## 組み込みテンプレート一覧（25 種類）

| テンプレート名 | 用途 |
|--------------|------|
| `title_slide` | タイトルスライド（グラデーション背景） |
| `chapter_intro` | 章区切り・セクション区切り |
| `thank_you_slide` | 終了スライド（連絡先付き） |
| `text_with_image` | テキスト＋画像の 2 カラム |
| `two_column_text` | テキストの 2 カラム |
| `bullet_points` | 箇条書きスライド |
| `quote_slide` | 引用・強調メッセージ |
| `stats_highlight` | 数値・KPI の強調表示 |
| `timeline` | タイムライン・ロードマップ |
| `comparison` | 比較スライド（左右対比） |
| `process_flow` | プロセス・フロー図 |
| `icon_grid` | アイコン＋テキストのグリッド |
| `team_slide` | チームメンバー紹介 |
| `agenda` | アジェンダ・目次 |
| その他 11 種 | `list_templates` で確認 |

---

## カラースキーム

`apply_professional_design` で適用できるカラースキーム：

| 名前 | 特徴 | 適した用途 |
|------|------|-----------|
| `Modern Blue` | 清潔感・信頼感 | ビジネス全般 |
| `Corporate Gray` | シンプル・ニュートラル | 社内資料 |
| `Elegant Green` | 自然・成長 | ESG・環境系 |
| `Warm Red` | エネルギー・情熱 | 営業・マーケ |

---

## スライドレイアウト index 対応表

`add_slide(layout_index=N)` の N と対応するレイアウト（PowerPoint 標準）：

| index | レイアウト名 | 用途 |
|-------|-------------|------|
| 0 | Title Slide | タイトルスライド |
| 1 | Title and Content | タイトル＋本文 |
| 2 | Title and Two Content | タイトル＋2カラム |
| 3 | Title Only | タイトルのみ |
| 4 | Blank | 白紙 |
| 5 | Title, Content and Caption | タイトル＋コンテンツ＋キャプション |
| 6 | Centered Text | 中央テキスト |

---

## QA チェック手順

### 1. テキスト確認

```python
# 全スライドのテキストを抽出して確認
mcp_ppt.extract_presentation_text(presentation_id=pid)
```

プレースホルダー文字列（「ここに入力」「Click to add」等）が残っていないか確認する。

### 2. ファイル確認

```bash
# ファイルが存在するか確認
ls -la output/
```

### 3. スライド情報確認

```python
# スライド数・サイズ等を確認
mcp_ppt.get_presentation_info(presentation_id=pid)
```

---

## よくあるエラーと対処

| エラー | 原因 | 対処 |
|--------|------|------|
| `presentation_id not found` | セッションが切れた | `create_presentation` または `open_presentation` を再実行 |
| `slide_index out of range` | 存在しないスライド番号を指定 | `get_presentation_info` でスライド数を確認 |
| `placeholder_idx not found` | レイアウトにそのプレースホルダーがない | `layout_index` を変えるか `add_text_box` を使う |
| `FileNotFoundError` | 保存先ディレクトリが存在しない | `mkdir -p` でディレクトリを作成してから再実行 |

---

## 設計原則

### やること

- **テンプレートシーケンスを優先**: `create_from_template_sequence` を使うと品質が安定する
- **1スライド1メッセージ**: 1枚に詰め込まず、メッセージを絞る
- **数値で語る**: 「大幅に改善」より「30% 削減」
- **スライド順序**: タイトル → アジェンダ → 本論 → まとめ → Next Action

### やってはいけないこと

- 1スライドにテキストを詰め込みすぎる（箇条書きは 3〜5 点まで）
- プレースホルダーテキストを残したまま保存する
- `presentation_id` を確認せずに操作する（セッション切れ注意）
- ファイルパスに日本語ディレクトリを使う（文字化け回避）
