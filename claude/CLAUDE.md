# Global Instructions

## BigQuery スケジュールドクエリの取得

BigQueryのスケジュールドクエリのURLや、スケジュールされたクエリについて聞かれた場合、以下の手順で取得する。

### URLの形式
```
https://console.cloud.google.com/bigquery/scheduled-queries/locations/{LOCATION}/configs/{CONFIG_ID}/details?...&project={PROJECT_ID}
```

### コマンド

詳細取得:
```bash
bq show --format=prettyjson --transfer_config 'projects/{PROJECT_ID}/locations/{LOCATION}/transferConfigs/{CONFIG_ID}'
```

一覧表示:
```bash
bq ls --transfer_config --transfer_location={LOCATION} --project_id={PROJECT_ID}
```

実行履歴:
```bash
bq ls --transfer_run --transfer_location={LOCATION} 'projects/{PROJECT_ID}/locations/{LOCATION}/transferConfigs/{CONFIG_ID}'
```

- デフォルトロケーションは `asia-northeast1`
- 取得したSQLは整形して表示し、処理の流れを日本語で解説すること

## Cloud SQL レプリカの読み取り（BigQuery 経由）

本番 Cloud SQL のデータを分析したい場合、BigQuery の `EXTERNAL_QUERY()` を使って読み取り専用レプリカに接続する。

```bash
bq query --project_id=palmu-prod --use_legacy_sql=false '
  SELECT * FROM EXTERNAL_QUERY(
    "palmu-prod.asia-northeast1.replica-for-analytics",
    "SELECT * FROM users LIMIT 10"
  )
'
```

- **接続リソース**: `palmu-prod.asia-northeast1.replica-for-analytics`
- `EXTERNAL_QUERY` の第2引数には **MySQL 構文の SQL** を文字列で渡す（BigQuery SQL ではない）
- 結果は BigQuery のテーブルとして返るため、外側で BigQuery SQL の JOIN や集計と組み合わせ可能
- テーブル一覧の確認: `EXTERNAL_QUERY("palmu-prod.asia-northeast1.replica-for-analytics", "SHOW TABLES")`

## Cloud SQL palmu-report の読み取り（BigQuery 経由）

管理画面専用DB（palmu-report）のデータを読み取る場合も、BigQuery の `EXTERNAL_QUERY()` を使う。

```bash
bq query --project_id=palmu-prod --use_legacy_sql=false '
  SELECT * FROM EXTERNAL_QUERY(
    "palmu-prod.asia-northeast1.palmu-report",
    "SELECT id, memo, rank_int FROM ranks LIMIT 10"
  )
'
```

- **接続リソース**: `palmu-prod.asia-northeast1.palmu-report`
- `EXTERNAL_QUERY` の第2引数には **MySQL 構文の SQL** を文字列で渡す（BigQuery SQL ではない）
- **注意**: TIMESTAMP カラム（`created_at`, `updated_at`, `deleted_at`）にゼロ日付 `0000-00-00 00:00:00` が含まれると BigQuery 変換エラーになる。TIMESTAMP カラムを取得する場合は `CAST(IF(col = 0, NULL, col) AS CHAR)` でキャストする:
  ```bash
  bq query --project_id=palmu-prod --use_legacy_sql=false '
    SELECT * FROM EXTERNAL_QUERY(
      "palmu-prod.asia-northeast1.palmu-report",
      "SELECT id, CAST(IF(created_at = 0, NULL, created_at) AS CHAR) as created_at, memo, rank_int FROM ranks LIMIT 10"
    )
  '
  ```
- テーブル一覧の確認: `EXTERNAL_QUERY("palmu-prod.asia-northeast1.palmu-report", "SHOW TABLES")`
