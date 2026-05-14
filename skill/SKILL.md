---
name: pptx-mcp
description: >
  PowerPoint 資料の自動生成・編集スキル。
  【新規生成】ユーザーが「資料を作って」「プレゼンを作成して」「スライドを生成して」「pptx にまとめて」
  と言ったとき、または要件・仕様・提案内容を渡されたときに使う。
  【既存編集】ユーザーが「スライドを追加して」「テキストを修正して」「グラフを更新して」「編集して」
  「変更して」と言ったとき、または既存の .pptx ファイルへの変更を求めたときに使う。
  Office-PowerPoint-MCP-Server（MCP サーバー名: ppt）を通じて python-pptx で .pptx ファイルを操作する。
  MCP サーバーが未起動の場合は setup.md を参照して起動してから実行すること。
---

# pptx-mcp スキル

## タスク別クイックリファレンス

| タスク | 参照先 |
|--------|--------|
| MCP サーバーの起動・設定 | [setup.md](setup.md) |
| 要件をユーザーから引き出す | [requirements.md](requirements.md) |
| スライドを新規生成する | [pptx-generation.md](pptx-generation.md) |
| 既存ファイルを編集する | [pptx-editing.md](pptx-editing.md) |
| スライドマスター用テンプレート | `template/` ディレクトリ |
| その他の参考素材を参照する | `references/` ディレクトリ |

---

## フロー判定

ユーザーの依頼が「新規作成」か「既存編集」かを最初に判断する。

| 依頼の特徴 | 使うフロー |
|-----------|-----------|
| ファイル名の指定なし、内容をゼロから作る | **新規生成フロー** |
| 既存の .pptx ファイル名を指定している | **編集フロー** |
| 「追加して」「修正して」「変更して」「更新して」 | **編集フロー** |

---

## 新規生成フロー

```
1. MCP サーバーが起動しているか確認
        ↓
2. template/*.pptx の有無を確認
   ある → open_presentation でベースとして開く（スライドマスター継承）
   ない → create_presentation で新規作成
        ↓
3. ユーザーの要件を requirements.md のテンプレートで整理
        ↓
4. スライド構成（アウトライン）を立案・ユーザーに確認
        ↓
5. pptx-generation.md のガイドラインに従ってスライドを生成
        ↓
6. QA チェック → output/ に保存して提示
```

## 編集フロー

```
1. MCP サーバーが起動しているか確認
        ↓
2. 対象ファイルと編集内容をユーザーに確認
   ※ ブランド統一が必要な場合は template/*.pptx も確認
        ↓
3. pptx-editing.md の手順に従って既存ファイルを開き編集
        ↓
4. QA チェック → output/ に保存して提示
```

---

## ステップ 1: MCP サーバー確認

```bash
# サーバーが登録されているか確認
claude mcp list | grep ppt
```

`ppt` が表示されない場合は [setup.md](setup.md) を参照して追加する。

---

## ステップ 2: 要件整理

[requirements.md](requirements.md) の質問テンプレートをもとに、不足している情報をユーザーに確認する。

**最低限必要な情報：**
- 資料の目的・ゴール
- 対象読者
- スライド枚数の目安
- 出力ファイル名（保存先は `output/` ディレクトリ固定）

---

## ステップ 3: スライド生成

[pptx-generation.md](pptx-generation.md) を参照して MCP ツールを呼び出す。

**最小構成の生成例：**

```python
# 1. プレゼンテーション作成
create_presentation()  # → presentation_id を取得

# 2. スライドを追加
add_slide(layout_index=0, title="タイトル", presentation_id=...)

# 3. コンテンツを追加
add_text_box(slide_index=0, text="...", presentation_id=...)

# 4. 保存（output/ ディレクトリに保存する）
save_presentation(file_path="output/ファイル名.pptx", presentation_id=...)
```

---

## QA チェックリスト

生成後に以下を確認する：

- [ ] ファイルが正常に保存されているか
- [ ] 全スライドのタイトルが設定されているか
- [ ] テキストが枠からはみ出していないか
- [ ] スライド枚数が要件と一致しているか
- [ ] プレースホルダーテキスト（例：「ここに入力」）が残っていないか
