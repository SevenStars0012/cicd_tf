# 🚀 S3ファイルアップロード監視インフラ（Terraform × AWS Lambda）

## 📝 概要

このプロジェクトは、S3にファイルがアップロードされたことを自動で検知し、Lambda関数で処理・ログ出力するインフラ構成を、Terraformでコード化したものです。  
CI/CDには GitHub Actions + Terraform Cloud を使用し、フル自動のデプロイが可能です。

---

## 🛠 使用技術

- Terraform 1.11.2（Infrastructure as Code）
- Terraform Cloud（状態管理・CI/CD統合、`dev` ワークスペース）
- AWS
  - S3（アップロードトリガー）
  - Lambda（サーバーレス処理）
  - IAM（権限管理）
  - CloudWatch Logs（ログ管理）
- Python 3.11（Lambda関数）
- GitHub Actions（CI/CDパイプライン）
- OIDC (OpenID Connect)：セキュアなAWS認証（長期キー不要）

---

## 🏗 システム構成

```
┌──────────────────┐      S3イベント     ┌────────────┐
│   S3バケット│ ─────────────▶      │   Lambda関数│
│ (アップロード)│                        │ (Python実装)│
└──────────────────┘                     └────────────┘
                                        │
                                        ▼
                               ┌────────────────┐
                               │ CloudWatch Logs│
                               └────────────────┘
```

---

## 🔁 CI/CD 自動化の流れ

1. `main` ブランチに `push` すると GitHub Actions の `dev.yml` がトリガー
2. GitHub Actions が以下を自動実行：

| ステップ               | 説明                                        |
|------------------------|---------------------------------------------|
| Terraform セットアップ | バージョン1.11.2を自動インストール         |
| AWS 認証               | GitHub OIDC + IAM ロールでセキュアに認証   |
| Terraform Init         | Terraform Cloud の dev ワークスペースに接続 |
| Terraform Apply        | AWS環境を自動構築                           |

---

## 🔐 セキュアなAWS認証（OIDC）

GitHub Actions から AWS への接続には、長期的なアクセスキーを使わず、OIDC を利用しています。これによりセキュアかつ自動的に IAM ロールへ Assume できます。

```yaml
- uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::${{ secrets.AWS_ACCOUNT_ID }}:role/${{ env.AWS_ROLE_NAME }}
    aws-region: ${{ env.AWS_REGION }}
```

---

## 📦 Lambda ZIPの作成方法

```bash
cd lambda
zip lambda.zip log_handler.py
```

※ `lambda.zip` は `.gitignore` で除外済みです

---

## 📂 ディレクトリ構成（抜粋）

```
cicd_tf/
├── .github/workflows/dev.yml     # GitHub Actions定義
├── dev/                          # Terraform構成
│   ├── main.tf / lambda.tf など
├── lambda/
│   ├── log_handler.py
│   └── lambda.zip（除外済）
└── README.md
```

---

## ✅ メリット

- PushだけでAWSに自動デプロイ
- Terraform Cloudで状態を一元管理
- OIDCでAWS認証をセキュアに運用
- Infrastructure as Code + CI/CD の実践構成

---


