# 既存 PPTX 編集ガイドライン

`output/` に保存済みの .pptx ファイルを開いて追加・修正するための手順書です。

---

## テンプレートファイルの扱い

編集対象のファイルが `output/` にない場合、または新たにブランド統一された資料を作り直す場合は **`template/` ディレクトリを確認すること**。

`template/*.pptx` が存在する場合は、そのファイルをベースに使用することでスライドマスター（フォント・カラー・レイアウト・背景）が引き継がれる。

> **注意**: `template/` 内のファイルは絶対に上書き保存しないこと。編集結果は必ず `output/` に保存する。

---

## 参考資料

テンプレート以外の素材（ブランドロゴ・カラーガイドライン・過去資料サンプル等）は `references/` ディレクトリに格納されています。

---

## 編集フロー

```
1. 対象ファイルをユーザーに確認
        ↓
2. open_presentation で開く → presentation_id を取得
        ↓
3. get_presentation_info / extract_presentation_text で現状を把握
        ↓
4. 編集内容をユーザーに確認
        ↓
5. 編集を実行
        ↓
6. extract_presentation_text で差分を確認（QA）
        ↓
7. output/ に保存（元ファイルを上書き、または別名で保存）
```

---

## ステップ 1: ファイルを開いて現状把握

```python
# ファイルを開く
result = mcp_ppt.open_presentation(file_path="output/ファイル名.pptx")
pid = result["presentation_id"]

# スライド数・サイズを確認
mcp_ppt.get_presentation_info(presentation_id=pid)

# 全テキストを抽出して内容を把握
mcp_ppt.extract_presentation_text(presentation_id=pid)
```

特定スライドだけ確認する場合：

```python
mcp_ppt.get_slide_info(slide_index=0, presentation_id=pid)
mcp_ppt.extract_slide_text(slide_index=0, presentation_id=pid)
```

---

## 編集パターン

### パターン A: テキストを修正する

```python
# プレースホルダーのテキストを上書き
mcp_ppt.populate_placeholder(
    slide_index=2,
    placeholder_idx=1,
    text="修正後のテキスト",
    presentation_id=pid
)

# テキストボックスのテキストを管理（追加・編集・削除）
mcp_ppt.manage_text(
    slide_index=2,
    action="edit",       # add | edit | delete
    text="修正後のテキスト",
    presentation_id=pid
)
```

### パターン B: スライドを追加する

```python
# 末尾にスライドを追加
mcp_ppt.add_slide(
    layout_index=1,
    title="追加スライドのタイトル",
    presentation_id=pid
)

# テンプレートから追加（推奨）
mcp_ppt.create_slide_from_template(
    template_name="bullet_points",
    content={
        "title": "追加スライドのタイトル",
        "bullets": ["ポイント A", "ポイント B", "ポイント C"]
    },
    presentation_id=pid
)
```

### パターン C: グラフのデータを更新する

```python
mcp_ppt.update_chart_data(
    slide_index=6,
    chart_index=0,
    categories=["Q1", "Q2", "Q3", "Q4"],
    series=[
        {"name": "2025年", "values": [150, 180, 170, 210]}
    ],
    presentation_id=pid
)
```

### パターン D: 表のセルを修正する

```python
mcp_ppt.format_table_cell(
    slide_index=8,
    table_index=0,
    row=1, col=2,
    text="修正後の値",
    presentation_id=pid
)
```

### パターン E: 画像を差し替える

```python
mcp_ppt.manage_image(
    slide_index=5,
    action="replace",    # add | replace | delete
    image_path="path/to/new-image.png",
    presentation_id=pid
)
```

---

## 保存方法

### 元ファイルを上書き保存

```python
mcp_ppt.save_presentation(
    file_path="output/ファイル名.pptx",
    presentation_id=pid
)
```

### 別名で保存（元ファイルを残す）

編集前のバージョンを保持したい場合は別名を付ける。

```python
mcp_ppt.save_presentation(
    file_path="output/ファイル名_v2.pptx",
    presentation_id=pid
)
```

> **注意**: 保存先は必ず `output/` ディレクトリにすること。

---

## QA チェックリスト（編集後）

- [ ] 編集箇所のテキストが正しく反映されているか
- [ ] 意図しないスライドが変更・削除されていないか
- [ ] 追加スライドのタイトルが設定されているか
- [ ] グラフ・表のデータが正しく更新されているか
- [ ] スライド枚数が意図通りか（追加した場合）
- [ ] ファイルが `output/` に正常に保存されているか

---

## よくある編集ミスと対処

| ミス | 原因 | 対処 |
|------|------|------|
| 編集が反映されない | `presentation_id` が古い／セッション切れ | `open_presentation` でファイルを再度開く |
| 意図しないスライドを編集 | `slide_index` の指定ミス（0 始まり） | `get_presentation_info` でスライド番号を確認してから実行 |
| 元ファイルが壊れた | 上書き保存後に問題が発覚 | 事前に別名保存（`_v2` 等）しておく |
| `placeholder_idx not found` | レイアウトにそのプレースホルダーがない | `get_slide_info` でプレースホルダー一覧を確認し、`add_text_box` を代用 |
