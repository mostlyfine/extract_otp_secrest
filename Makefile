IMAGE_NAME = extract_otp_secrets
.DEFAULT_GOAL := extract
.PHONY: build display clean help

build: ## build docker image
	docker build -t $(IMAGE_NAME) .

check: export.txt	## check export.txt exists
	@echo "check ok"

extract: check build ## extract otp secrets
	docker run --rm -it $(IMAGE_NAME)

clean: ## cleanup docker image
	docker rmi $(IMAGE_NAME)

help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)


