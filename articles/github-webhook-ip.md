---
title: "GitHub Webhook 用エンドポイントを Cloud Armor で保護する"
emoji: "🔒"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["cloudarmor", "github", "terraform", "gcp"]
published: true
---

## 結論

GitHub Webhook 用エンドポイントを Cloud Armor で保護し、GitHub からのリクエストのみを許可する方法を紹介します。

**やること:**
1. GitHub Meta API (`https://api.github.com/meta`) から GitHub Webhook 配信用 IP アドレスを取得
2. Cloud Armor のセキュリティポリシーで GitHub の IP アドレスのみ許可

**取得コマンド:**
```bash
curl -s https://api.github.com/meta | jq -r '.hooks[]'
```

**現在（2025/11/16）の Webhook 用 IP アドレス（IPv4）:**
- `192.30.252.0/22`
- `185.199.108.0/22`
- `140.82.112.0/20`
- `143.55.64.0/20`

:::message
**注意点：**
- IP アドレスは変更される可能性があるため定期監視が必要です
- Webhook Secret 検証との併用を推奨します
- [GitHub 公式は IP アドレスベースの許可を推奨していません](https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/about-githubs-ip-addresses)
:::

それでは、詳しくみていきましょう(｀･ω･´)ゞ

## はじめに

GitHub Webhook を受け取るサービスを構築していると「GitHub からのリクエストのみを受け付けたい」というセキュリティ要件が出てきました。
私のケースでは、[Atlantis](https://www.runatlantis.io/) を導入したときにこの問題が発生しました 🫨
Atlantis の Webhook エンドポイントはインターネットに公開する必要がありますが、公開されたエンドポイントは攻撃の対象になりやすいため、適切な保護が必要です。

そこで本記事では、GitHub Webhook 配信用の IP アドレスを取得し、Cloud Armor でその IP アドレスからのアクセスのみを許可する方法を紹介します。

## 前提知識

### GitHub の IP アドレス情報

GitHub は、Webhook 配信やその他のサービスで使用する IP アドレスレンジを公開しています。これらの情報は **Meta API** (`https://api.github.com/meta`) から取得できます。

Meta API からは、様々な GitHub サービスで使用される IP アドレスが取得できますが、今回必要なのは `hooks` フィールドに含まれる Webhook 配信用の IP アドレスです。

### Cloud Armor とは

Cloud Armor は GCP が提供するネットワークセキュリティサービスで、DDoS 攻撃からの保護や IP アドレスベースのアクセス制御を提供します。Load Balancer や Cloud Run などと統合して使用できます。

参考：
- [Google Cloud Armor のドキュメント | Google Cloud Documentation](https://docs.cloud.google.com/armor/docs?hl=ja)

## GitHub Webhook 配信用 IP アドレスを取得する

### Meta API から取得する

ここではシンプルに curl コマンドで API を叩いて IP アドレスを取得します。
```bash
curl -s https://api.github.com/meta | jq -r '.hooks[]'
```

実行すると、以下のような CIDR 形式の IP アドレスレンジが取得できます。
```bash
192.30.252.0/22
185.199.108.0/22
140.82.112.0/20
143.55.64.0/20
2a0a:a440::/29
2606:50c0::/32
```

参考：
- [メタデータ用 REST API エンドポイント - GitHub ドキュメント](https://docs.github.com/ja/rest/meta?apiVersion=2022-11-28)

## Cloud Armor で GitHub IP のみ許可する

取得した IP アドレスレンジを使って、Cloud Armor のセキュリティポリシーを設定します。
これにより、GitHub の IP アドレスからのリクエストのみを許可し、その他のアクセスは拒否します。

### Terraform での設定例
```hcl
resource "google_compute_security_policy" "webhook_policy" {
  name = "github-webhook-policy"

  # デフォルトはすべて拒否
  rule {
    action   = "deny(403)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default deny all"
  }

  # GitHub の Webhook IP アドレスのみ許可
  rule {
    action   = "allow"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = [
          "192.30.252.0/22",
          "185.199.108.0/22",
          "140.82.112.0/20",
          "143.55.64.0/20",
          "2a0a:a440::/29",
          "2606:50c0::/32",
        ]
      }
    }
    description = "Allow GitHub Webhook IPs"
  }
}
```

この設定により、GitHub の IP アドレスからのリクエストは許可され、それ以外のリクエストは 403 エラーで拒否されます。
私のケースでは GKE で Atlantis を動かしているため、BackendConfig を使ってポリシーを適用しました。

参考：
- [google_compute_security_policy | Resources | hashicorp/google](https://www.terraform.io/docs/providers/google/r/compute_security_policy.html)

## おわりに

GitHub Webhook 用エンドポイントを Cloud Armor で保護し、GitHub の IP アドレスからのリクエストのみを許可する方法を紹介しました。
GitHub Webhook を受け取るサービスを構築・運用している方のお役に立てば幸いです🤞

## 参考文献

- [GitHub の IP アドレスについて - GitHub ドキュメント](https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/about-githubs-ip-addresses)
- [Google Cloud Armor のドキュメント | Google Cloud Documentation](https://docs.cloud.google.com/armor/docs?hl=ja)
- [メタデータ用 REST API エンドポイント - GitHub ドキュメント](https://docs.github.com/ja/rest/meta?apiVersion=2022-11-28)
- [google_compute_security_policy | Resources | hashicorp/google](https://www.terraform.io/docs/providers/google/r/compute_security_policy.html)
