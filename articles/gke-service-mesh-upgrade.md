---
title: "GKE Service Mesh のリリースチャンネル変更と再インストール手順"
emoji: "🕸️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["gke", "servicemesh", "istio", "kubernetes"]
published: true
---

## はじめに

GKE（Google Kubernetes Engine）で Service Mesh を運用している際、リリースチャンネルを変更したくなることがありますよね？（きっとあります 😚）
しかし、公式ドキュメント以外にこの手順を詳しく説明した記事はなかなか見つかりませんでした。

そこで本記事では、Service Mesh のリリースチャンネルを `rapid` から `regular` に変更し、一度完全にアンインストールして再インストールする手順を詳しく解説します。
本記事では`rapid`から`regular`に変更する手順を解説しますが、`regular`から`rapid`に変更する手順も同様です。

:::message alert
執筆時点（2025年6月）での手順を記載しています。Google Cloud Platform のサービスは頻繁にアップデートされるため、最新の情報については必ず公式ドキュメントをご確認ください。また、本番環境での作業前には十分な検証を行うことを強く推奨します。
:::

## 環境情報

作業を行う前に以下の情報を確認しました：

#### GKE クラスタ構成
- **リージョン**: asia-northeast1
- **GKE バージョン**: 1.32.3-gke.1170000
- **リリースチャンネル**: Rapid

#### Service Mesh 構成
- **種類**: マネージド Cloud Service Mesh
- **コントロールプレーン**: Istiod（※Traffic Director ではない）
- **管理方式**: MANAGEMENT_AUTOMATIC
- **リリースチャンネル**: Rapid

#### 確認コマンド
作業前に以下のコマンドで環境を確認しました：

```bash
# クラスタ情報の確認
gcloud container clusters list --format="table(name,currentMasterVersion,releaseChannel.channel,location)"

# Service Mesh の状態確認
gcloud container fleet mesh describe --project=my-project-123456
```

## 作業手順

### 1. 事前準備

まず、現在の状態を確認します。

```bash
# 現在の Service Mesh バージョン確認
kubectl get controlplanerevision -n istio-system

# VirtualService と Gateway の確認
kubectl get vs -A
kubectl get gateways -A
```

実際の確認結果：
```
NAMESPACE          NAME                      GATEWAYS               HOSTS   AGE
katayan-gateway    katayan-virtualservice    ["katayan-gateway"]    ["*"]   2y180d
katayan            katayan-virtualservice    ["katayan-gateway"]    ["*"]   4y183d
```

### 2. メッシュ関連ワークロードの削除

Service Mesh をアンインストールする前に、関連するワークロードを削除します。

```bash:削除手順
# 1. Istio 関連リソースの削除
kubectl get vs,gw,dr,se,pa,ap -A
kubectl delete vs <virtualservice-name> -n <namespace>
kubectl delete gateway <gateway-name> -n <namespace>
kubectl delete destinationrule <destinationrule-name> -n <namespace>

# 2. サイドカーがインジェクションされた Pod の削除
kubectl get namespaces -L istio-injection
kubectl delete deployment <deployment-name> -n <namespace>

# 3. 実際の削除例
kubectl delete vs katayan-virtualservice -n katayan-gateway
kubectl delete gateway katayan-gateway -n katayan-gateway
kubectl delete namespace katayan
kubectl delete namespace katayan-gateway
```

### 3. Service Mesh のアンインストール

#### 3.1 自動管理の無効化

```bash
gcloud container fleet mesh update \
    --management manual \
    --memberships dev-cluster-1 \
    --project my-project-123456 \
    --location asia-northeast1
```

#### 3.2 Istio 関連リソースの削除

```bash
# Webhook リソースの削除
kubectl delete validatingwebhookconfiguration istio-validator-istio-system
kubectl delete mutatingwebhookconfiguration istio-sidecar-injector

# クラスタ内コントロールプレーンの削除
istioctl uninstall --purge
```

:::details 実行結果（クリックして表示）
```
All Istio resources will be pruned from the cluster
Proceed? (y/N) y
  Removed ClusterRole::istio-reader-istio-system.
  Removed ClusterRole::istiod-istio-system.
  Removed ClusterRoleBinding::istio-reader-istio-system.
  Removed ClusterRoleBinding::istiod-istio-system.
  Removed ClusterRoleBinding::istiod-pilot-istio-system.
  Removed CustomResourceDefinition::istiooperators.install.istio.io.
✔ Uninstall complete
```
:::

#### 3.3 追加リソースの削除

```bash
# mdp-controller の削除
kubectl delete deployment mdp-controller -n kube-system

# istio-cni-plugin-config の削除
kubectl delete configmap istio-cni-plugin-config -n kube-system

# istio-cni-node の削除
kubectl delete daemonset istio-cni-node -n kube-system
```

### 4. GKE クラスタのリリースチャンネル変更

```bash
# リリースチャンネルを regular に変更
gcloud container clusters update dev-cluster-1 \
    --location asia-northeast1 \
    --release-channel regular
```

### 5. Service Mesh の再インストール

#### 5.1 フリートからの一時的な削除と再登録

:::message
この手順は本環境特有の作業かもしれません🙏
:::

Service Mesh の再インストールを試したところ、問題が発生したので一度フリートから削除して再登録しました。

```bash
# フリートメンバーシップの削除
gcloud container fleet memberships delete dev-cluster-1

# フリートへの再登録
gcloud container clusters update dev-cluster-1 \
    --location asia-northeast1 \
    --fleet-project my-project-123456
```

#### 5.2 自動管理の有効化

```bash
gcloud container fleet mesh update \
    --management automatic \
    --memberships dev-cluster-1 \
    --project my-project-123456 \
    --location asia-northeast1
```

## 遭遇した問題と解決策

### プロビジョニングが`STALLED`状態になる

**症状:**
```
servicemesh:
  controlPlaneManagement:
    details:
    - code: REVISION_STALLED
      details: 'Failed to provision: asm-managed'
    state: STALLED
```

**原因:**
必須の connectgateway API が有効化されていなかった

**解決策:**
```bash
# connectgateway API の有効化
gcloud services enable connectgateway.googleapis.com --project=my-project-123456

# Service Mesh の再インストール
gcloud container fleet mesh update \
    --management automatic \
    --memberships dev-cluster-1 \
    --project my-project-123456 \
    --location asia-northeast1
```

### データプレーンが`DISABLED`状態のまま

**症状:**
```
dataPlaneManagement:
  details:
  - code: DISABLED
    details: Data Plane Management is not enabled.
  state: DISABLED
```

**原因:**
実際のワークロードが存在しないため、データプレーンが有効化されない

**解決策:**
istio-injection が有効な名前空間で Pod を起動することで、データプレーンが自動的に有効化される

## 成功後の確認

### Service Mesh の状態確認

```bash
gcloud container fleet mesh describe --project my-project-123456
```

:::details 成功時の出力例（クリックして表示）
```yaml
membershipStates:
  projects/123456789012/locations/asia-northeast1/memberships/dev-cluster-1:
    servicemesh:
      controlPlaneManagement:
        details:
        - code: REVISION_READY
          details: 'Ready: asm-managed'
        state: ACTIVE
      dataPlaneManagement:
        details:
        - code: OK
          details: Service is running.
        state: ACTIVE
```
:::

コントロールプレーンの状態が`ACTIVE`になっていれば成功です。

### Istio Proxy のバージョン確認

```bash
# Pod のサイドカーイメージ確認
kubectl describe pod <pod-name> -n <namespace>
```

:::details 期待される結果（クリックして表示）
```
image: 'gcr.io/gke-release/asm/proxyv2:1.20.8-asm.33'
```
:::

## まとめ

GKE Service Mesh のリリースチャンネル変更と再インストール、なんとか成功しました！

特に重要だったポイント：
- **connectgateway API の有効化**：これを忘れると STALLED 状態になる
- **関連リソースの事前削除**：VirtualService や Gateway などを先に削除
- **完全なアンインストール**：中途半端な状態だと問題が起きやすい

意外とハマりどころが多かったですが、公式ドキュメントをしっかり読んで手順通りに進めれば大丈夫でした 🙆‍♂ ️
同じような作業をする方の参考になれば幸いです！

## 参考資料

- [Cloud Service Mesh をアンインストールする](https://cloud.google.com/service-mesh/docs/uninstall?hl=ja)
- [GKE でマネージド Cloud Service Mesh コントロール プレーンをプロビジョニングする](https://cloud.google.com/service-mesh/docs/onboarding/provision-control-plane?hl=ja)
- [マネージド Cloud Service Mesh の問題の解決](https://cloud.google.com/service-mesh/docs/troubleshooting/troubleshoot-managed-service-mesh?hl=ja)
