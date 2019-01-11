APP_NAME ?= sample_app

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

#### Global recipes

build: build_app ## Builds the app container.

test: test_app ## Runs unittests against python application.

ftest: build test_container ## Performs functional testing on the container itself

clean: # cleans out the docker containers.
	@echo docker rmi --force $(APP_NAME)

#### Flask Container recipes

build_app:
	@docker build --no-cache -f Dockerfile -t $(APP_NAME) .

test_app:
	@cd app && pip3 install -r requirements.txt && python3 app_tests.py

run_app: build_app run ## Build and run flask container on localhost port 8080

#### Container control recipes

run: ## Run container on localhost port 8080
	@docker run -d -p 8080:80 --name="$(APP_NAME)" $(APP_NAME)
	@sleep 1

#### Container testing recipes

test_container: run ## Build the container, test it, and then clean up afterwards.
	@echo ""
	@echo "Testing page load from local running container"
	@echo ""
	@(curl -s --fail http://localhost:8080/ > /dev/null && echo "Testing successful") || (echo "Testing Failed" && docker stop $(APP_NAME) 2> /dev/null && docker rm $(APP_NAME) 2>/dev/null && exit 1)
	@docker stop $(APP_NAME) > /dev/null; docker rm $(APP_NAME) >/dev/null

