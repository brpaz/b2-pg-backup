
IMAGE_NAME:=brpaz/backblaze-pg-backup:local-dev

setup-env: # Setup local envrionment
	lefthook install
	test -e .env || cp -p .env.dist .env


lint: ## Runs hadoint against application dockerfile
	@docker run --rm -v "$(PWD):/data" -w "/data" hadolint/hadolint hadolint Dockerfile

build: ## Builds the docker image
	@docker build . -t $(IMAGE_NAME)

test: build ## Runs a test in the image
	@docker run -i --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ${PWD}:/test zemanlx/container-structure-test:v1.9.1-alpine \
    test \
    --image $(IMAGE_NAME) \
    --config test/structure-tests.yaml

test-integration: build # Runs integration tests
	IMAGE_TAG=$(IMAGE_NAME) test/run_tests.sh

dev: ## Starts development containers
	@docker-compose up -d

shell: ## Opens a shell in the backup tool container
	@docker-compose exec pgbackup sh

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

.DEFAULT_GOAL := help
.PHONY: lint build test help