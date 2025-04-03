
## 🚀 CI/CD 自動化について

本プロジェクトでは、TerraformによるAWSリソース管理と、GitHub Actions + Terraform Cloudを用いたCI/CD自動化構成を実現しています。

###  使用技術
- AWS
  - S3（アップロードトリガー）
  - Lambda（サーバーレス処理）
  - IAM（権限管理）
  - CloudWatch Logs（ログ管理）
- GitHub Actions（CI/CDパイプライン）
- Terraform 1.11.2（Infrastructure as Code）
- Terraform Cloud：状態管理とCI/CD統合（`dev` ワークスペースを使用）
- Python 3.11（Lambda関数の実装）
- GitHub Actions：CI/CDワークフローを自動化
- OIDC (OpenID Connect)：AWSへのセキュアな認証方式（GitHubとIAMロール連携）

---
##  システム構成

```text
┌─────────────┐      S3イベント             ┌────────────┐
│   S3バケット             │ ─────────────▶ │   Lambda関数           │
│ (アップロード)           │          │                 │ (Python実装)           │
└─────────────┘          │                 └────────────┘
                                        │
                                        ▼
                               ┌────────────────┐
                               │ CloudWatch Logs                │
                               └────────────────┘

---

###  自動化の流れ

1. `main` ブランチに push されると GitHub Actions の `dev.yml` がトリガーされます
2. GitHub Actions が以下を自動実行します：

   | ステップ              | 説明                                        |
   |-----------------------|---------------------------------------------|
   | Terraform セットアップ| 指定バージョンを自動インストール（1.11.2）  |
   | AWS 認証              | GitHub OIDC + IAM ロールでセキュアに認証    |
   | Terraform Init        | Terraform Cloud 上の Workspace に接続       |
   | Terraform Apply       | コードに基づきAWS環境を自動構築             |

---

###  セキュアなAWS認証

CI環境からAWSへアクセスする際、長期的なアクセスキーは使用せず、OIDC（OpenID Connect）とIAMロールを利用しています。

```yaml
- uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::${{ secrets.AWS_ACCOUNT_ID }}:role/${{ env.AWS_ROLE_NAME }}
    aws-region: ${{ env.AWS_REGION }}

