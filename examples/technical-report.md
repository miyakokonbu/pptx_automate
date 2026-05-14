# 使用例: 技術報告資料

> `template/` に .pptx ファイルがある場合は、そのスライドマスターが引き継がれます。ない場合は `color_scheme` でデザインを指定してください。
> その他の参考素材（ロゴ・カラーガイドライン等）は `references/` を参照してください。


## Claude Code へのプロンプト例

```
以下の要件で PowerPoint 資料を作成してください。

【要件】
- 目的: マイクロサービス移行の技術報告（社内エンジニア向け）
- 対象読者: バックエンドエンジニア（上級者）
- スライド枚数: 15 枚
- トーン: 技術的
- 出力パス: ./output/tech-report.pptx
- カラースキーム: Corporate Gray

【コンテンツ】
- モノリスからマイクロサービスへの移行背景
- アーキテクチャ概要（API Gateway, 各サービス, DB 分離）
- 移行フェーズ（Strangler Fig パターン）
- 直面した課題と解決策（分散トレーシング, サーキットブレーカー）
- パフォーマンス計測結果（レイテンシ、スループット）
- 今後の課題と Next Step
```

## 生成されるスライド構成

| # | テンプレート | タイトル |
|---|------------|--------|
| 1 | `title_slide` | マイクロサービス移行 技術報告 |
| 2 | `agenda` | アジェンダ |
| 3 | `chapter_intro` | 01. 移行の背景 |
| 4 | `bullet_points` | モノリスの課題 |
| 5 | `chapter_intro` | 02. アーキテクチャ |
| 6 | `text_with_image` | 全体構成図 |
| 7 | `two_column_text` | 主要コンポーネント |
| 8 | `chapter_intro` | 03. 移行アプローチ |
| 9 | `process_flow` | Strangler Fig パターン |
| 10 | `chapter_intro` | 04. 課題と解決策 |
| 11 | `comparison` | 分散トレーシングの比較 |
| 12 | `chapter_intro` | 05. 計測結果 |
| 13 | `stats_highlight` | パフォーマンス改善数値 |
| 14 | `bullet_points` | 今後の課題 |
| 15 | `thank_you_slide` | まとめ・Q&A |

## テクニカルなポイント

技術報告では以下の MCP ツールが特に有効です：

```python
# グラフ（before/after の数値比較）
create_chart(
    chart_type="bar",
    title="レイテンシ改善",
    categories=["P50", "P95", "P99"],
    series=[
        {"name": "移行前", "values": [120, 450, 980]},
        {"name": "移行後", "values": [45, 180, 350]}
    ]
)

# 表（比較・一覧）
add_table(
    data=[
        ["ツール", "用途", "採用理由"],
        ["Jaeger", "分散トレーシング", "OSS・実績豊富"],
        ["Hystrix", "サーキットブレーカー", "Spring Cloud 統合"],
        ["Prometheus", "メトリクス収集", "Grafana 連携"]
    ]
)
```
