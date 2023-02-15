.PHONY: start
start:
	npx zenn preview

.PHONY: article
article:
	npx zenn new:article --slug ${SLUG}
