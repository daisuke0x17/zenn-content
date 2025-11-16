.PHONY: help
help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

.PHONY: start
start: ## Zennのプレビューサーバーを起動
	npx zenn preview

.PHONY: article
article: ## 新しい記事を作成 (SLUG=記事のスラッグ名 を指定)
	npx zenn new:article --slug ${SLUG}
