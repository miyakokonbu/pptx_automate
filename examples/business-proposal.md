# 使用例: 事業提案資料

> `template/` に .pptx ファイルがある場合は、そのスライドマスターが引き継がれます。ない場合は `color_scheme` でデザインを指定してください。
> その他の参考素材（ロゴ・カラーガイドライン等）は `references/` を参照してください。


## Claude Code へのプロンプト例

```
以下の要件で PowerPoint 資料を作成してください。

【要件】
- 目的: 新規 SaaS サービスの経営層への事業提案
- 対象読者: 取締役・経営層（非技術者）
- スライド枚数: 10 枚
- トーン: フォーマル
- 出力パス: ./output/business-proposal.pptx
- カラースキーム: Modern Blue

【コンテンツ】
1. タイトル: 「顧客管理 SaaS 導入提案」
2. 課題: 既存の Excel 管理の限界（属人化・リアルタイム性の欠如）
3. 解決策: クラウド型 CRM の導入
4. 期待効果: 営業効率 30% 向上、顧客対応時間 50% 削減
5. 導入スケジュール: 3 フェーズ、6 ヶ月
6. コスト: 初期費用 200 万、月額 30 万
7. まとめ: 承認をお願いしたい
```

## 期待される出力

Claude Code が以下の手順で自動実行します：

1. 要件を `requirements.md` のテンプレートで整理
2. スライドアウトラインを提示・確認
3. `create_from_template_sequence` でスライドを生成
4. `apply_professional_design(scheme="Modern Blue")` でデザイン適用
5. `extract_presentation_text` で QA チェック
6. `business-proposal.pptx` として保存

## 生成されるスライド構成

| # | テンプレート | タイトル |
|---|------------|--------|
| 1 | `title_slide` | 顧客管理 SaaS 導入提案 |
| 2 | `agenda` | 本日のアジェンダ |
| 3 | `chapter_intro` | 01. 現状の課題 |
| 4 | `two_column_text` | 課題の詳細 |
| 5 | `chapter_intro` | 02. 提案内容 |
| 6 | `text_with_image` | ソリューション概要 |
| 7 | `stats_highlight` | 期待効果 |
| 8 | `timeline` | 導入スケジュール |
| 9 | `comparison` | コスト比較 |
| 10 | `thank_you_slide` | まとめ・Next Action |
