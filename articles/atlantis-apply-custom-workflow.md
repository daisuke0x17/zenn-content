---
title: "Atlantis のカスタムワークフローを使って環境別に apply を制御する"
emoji: "🏝️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["Terraform", "Atlantis"]
published: true
---

## 結論

[環境に応じて`atlantis apply`の実行を制御するカスタムワークフロー](#解決策：カスタムワークフローで環境判定を行う)を定義することで

- dev 環境では`atlantis apply`の実行に approve が不要
- stg/prd 環境では`atlantis apply`の実行に approve が必須

を実現しました。

## はじめに

[Atlantis](https://www.runatlantis.io/) で Terraform を運用する際、「全環境で`atlantis apply`には approve が必須」というガードレールを設けていました。安全性が高まる一方で dev 環境の開発サイクルが遅くなるという課題が出てきました。
そこで dev 環境だけ approve を不要にし、stg/prd のガードレールは維持する方法を調査しました。
この記事では調査内容と実際の解決アプローチを紹介します(｀･ω･´)ゞ

## 前提

### 課題

あらためて課題を整理します：

- これまでは「全環境で`atlantis apply`には approve が必須」という強いガードレールにしていました。
- その結果、dev 環境でも`atlantis apply`の実行には approve が必要となり、レビュー待ちによる開発サイクルの遅延が発生していました。
- ただし、stg/prd は安全性のためこれまで通り`atlantis apply`の実行には approve を必須としたい。

### ディレクトリ構成

Atlantis で運用している Terraform リポジトリのディレクトリ構成は以下のようになっています。
環境名（dev/stg/prd）はディレクトリ末尾で固定です。

```
├── platform/
│   └── gcp/
│       └── system-name/
│           ├── dev/
│           ├── stg/
│           └── prd/
├── services/
│   └── gcp/
│       └── service-name/
│           ├── dev/
│           ├── stg/
│           └── prd/
```

## 調査内容

### ワイルドカードによる環境判定（うまくいかなかった）

最初に検討したのは`atlantis.yaml`の dir でワイルドカードを使って環境ごとに apply_requirements を分ける方法でした。
```yaml
version: 3
projects:
  # dev環境 - approve不要
  - dir: platform/**/dev
    apply_requirements: []
  - dir: services/**/dev
    apply_requirements: []

  # prd環境 - approve必須
  - dir: platform/**/prd
    apply_requirements: [approved]
  - dir: services/**/prd
    apply_requirements: [approved]
```

`**`で中間ディレクトリ（gcp/system-name など）をまとめてマッチできれば、ディレクトリが増えても設定変更不要で理想的でした。
しかし、Atlantis の dir は glob/ワイルドカード指定に対応していません。Feature Request として起票されていますが未実装です。

参考：[Allow supplying wildcard for dir · Issue #686 · runatlantis/atlantis](https://github.com/runatlantis/atlantis/issues/686)

この方法が使えないため、カスタムワークフローで環境変数を使った判定に切り替えました。

### 解決策：カスタムワークフローで環境判定を行う

Atlantis のカスタムワークフローとは、plan や apply の実行ステップを自由にカスタマイズできる機能です。デフォルトでは init → plan や apply が実行されますが、カスタムワークフローを使うことで以下のようなことが可能になります。

- 任意のシェルスクリプトを実行する（run ステップ）
- 環境変数を使った条件分岐
- 追加のバリデーションやチェックの挿入

参考：[Custom Workflows | Atlantis](https://www.runatlantis.io/docs/custom-workflows)

カスタムワークフローは`repos.yaml`（サーバーサイド設定）で定義するか、サーバーサイドで許可されていれば `atlantis.yaml`（リポジトリ側設定）でも定義できます。今回はサーバーサイドで定義する方法を紹介します。

#### repos.yaml（サーバーサイド設定）
```yaml
repos:
  - id: github.com/your-org/your-repo
    workflow: env-protected-apply

workflows:
  env-protected-apply:
    apply:
      steps:
        - run: |
            echo "REPO_REL_DIR=${REPO_REL_DIR}"
            # dev 配下は承認不要
            if [[ "$REPO_REL_DIR" =~ /dev$ ]]; then
              echo "dev environment detected, skipping approval check"
              exit 0
            fi
            # dev 以外は承認必須
            if [[ "$ATLANTIS_PR_APPROVED" != "true" ]]; then
              echo "ERROR: PR approval required for non-dev environments"
              exit 1
            fi
        - apply
```

以下の環境変数を使って環境判定を行っています：

- `REPO_REL_DIR`：PR が作成されたリポジトリの相対パスを取得
- `ATLANTIS_PR_APPROVED`：PR が承認されたかどうかを取得（true/false）

その他の環境変数は[公式ドキュメント](https://www.runatlantis.io/docs/custom-workflows#native-environment-variables)を参照してください。

今回は apply のみを定義しているので plan はデフォルトの挙動になります。
run ステップの出力は PR コメントに表示されます。そのため、exit 1 で処理を中断しても、echo で出力したエラー理由が開発者に伝わります。

## まとめ

この設定により dev 環境は PR 作成直後に`atlantis apply`可能（承認不要）、stg/prd 環境は PR 承認後のみ`atlantis apply`可能になりました。
dev 環境の開発サイクルは速くなりましたが、当然リスクもあります。dev 環境は「壊れても影響が限定的」という前提があるので、スピードを優先してこのトレードオフを受け入れました。
同じような課題を抱えている方の参考になれば幸いです。

## 参考
- [Atlantis](https://www.runatlantis.io/)
- [Allow supplying wildcard for dir · Issue #686 · runatlantis/atlantis](https://github.com/runatlantis/atlantis/issues/686)
- [Custom Workflows | Atlantis](https://www.runatlantis.io/docs/custom-workflows)
