# WIP

GIT_VERSION ?= $(shell git describe --always --dirty)
IMAGE_VERSION ?= $(shell git describe --always --dirty)
IMAGE_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD | sed 's/\///g')
GIT_REF = $(shell git rev-parse --short=8 --verify HEAD)

HOST=gcr.io
REPOSITORY=/analyticsframework/datasets/apis/users/grpc-server
TAG=$(shell python -c 'import UsersAPI; print(UsersAPI.__version__)')
PWD=$(shell pwd)

HEADER = \033[95m
OKBLUE = \033[94m
OKGREEN = \033[92m
WARNING = \033[93m
FAIL = \033[91m
ENDC = \033[0m
BOLD = \033[1m
UNDERLINE = \033[4m

###############################################################################
#                            Standard make targets                            #
###############################################################################

# Setting up the environment

.PHONY: dev-install-all
dev-install-all: dev-update-git-submodules
dev-install-all: dev-install-environment
dev-install-all:  ## Install the full development environment, including project dependencies.
	@echo "${OKGREEN}Development environment initialized${ENDC}"

.PHONY: dev-install-environment
dev-install-environment: PROJECT_HOME=.
dev-install-environment:  ## Install the development environment.
	@echo "${OKGREEN}Installing development environment in ${OKBLUE}${PROJECT_HOME}${ENDC}"
	@virtualenv -p python3 ${PROJECT_HOME}/.venv3
	@${PROJECT_HOME}/.venv3/bin/pip install --upgrade pip
	@${PROJECT_HOME}/.venv3/bin/pip install --upgrade setuptools
	@${PROJECT_HOME}/.venv3/bin/pip install -e .[dev] -v
	@${PROJECT_HOME}/.venv3/bin/pip install -e .[all] -v
	@echo "${OKGREEN}Activate development environment with: ${OKBLUE}source ${PROJECT_HOME}/.venv3/bin/activate${ENDC}"

.PHONY: dev-update-git-submodules
dev-update-git-submodules:  ## Update git submodules.
	git submodule update --recursive --remote


# Testing:

.PHONY: test-all
test-all: test-lint
test-all: test-unit
test-all: test-e2e
test-all: test-docs
test-all:  ## Run all the available tests.
	@echo "${OKGREEN}All the fake tests passed${ENDC}"

.PHONY: test-docs
test-docs:  ## Run all the documentation tests.
	@echo "${OKGREEN}All the fake doc tests passed${ENDC}"

.PHONY: test-e2e
test-e2e:  ## Run all the end-to-end tests.
	@echo "${OKGREEN}All the fake e2e tests passed${ENDC}"

.PHONY: test-lint
test-lint:  ## Run the code linter.
	@.venv3/bin/flake8 UsersAPI --exclude *_pb2.py,*_pb2_grpc.py
	@echo "${OKGREEN}Linter tests complete.${ENDC}"

.PHONY: test-unit
test-unit:  ## Run all the unit tests.
	@echo "${OKGREEN}All the fake unit tests passed${ENDC}"


# Install app for Production:

.PHONY: prod-install-all
prod-install-all: PROJECT_HOME=.
prod-install-all:  ## Install the production environment (intended for automation).
	@echo "${OKGREEN}Installing production environment in ${OKBLUE}${PROJECT_HOME}${ENDC}"
	@virtualenv -p python3 ${PROJECT_HOME}/.venv3
	@${PROJECT_HOME}/.venv3/bin/pip install --upgrade pip
	@${PROJECT_HOME}/.venv3/bin/pip install --upgrade setuptools
	@${PROJECT_HOME}/.venv3/bin/pip install .[all]
	@echo "${OKGREEN}Production environment initialized${ENDC}"

# Misc:

# Generates a help menu with the descriptions provided by the comments with double ##
.PHONY: help
help:  ## Show help messages for make targets
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort | awk 'BEGIN {FS = ":.*?## "}; {printf "${OKGREEN}%-30s${ENDC} %s\n", $$1, $$2}'

###############################################################################
#                        Project specific make targets                        #
###############################################################################

.PHONY: test
test:  # Run all the available tests.
	@echo "${OKGREEN}All the fake tests passed${ENDC}"


.PHONY: build-image
build-image:  # Build a docker image containing the project.
	@docker build \
		-t $(HOST)$(REPOSITORY):$(TAG) \
		.


# .PHONY: deploy
# deploy:  # Deploy the whole project.
# 	@echo "${OKGREEN}Deploying to: ... ${ENDC}"


# Custom targets

.PHONY: proto
proto: PROJECT_HOME=.
proto: # Generate protobuf definitions.
	@mkdir -p proto/out/
	@${PROJECT_HOME}/.venv3/bin/python -m grpc_tools.protoc \
		--include_imports \
		--include_source_info \
		--proto_path=googleapis/ \
		--proto_path=proto/ \
		--descriptor_set_out=proto/out/api_descriptor.pb \
		--python_out=proto/out/ \
		--grpc_python_out=proto/out/ \
		proto/api.proto
	@cp proto/out/*.py UsersAPI/ && \
		sed -i 's/^import api_pb2 as api__pb2$$/from UsersAPI import api_pb2 as api__pb2/' UsersAPI/api_pb2_grpc.py  # Fix Py3 imports
	@echo "${OKGREEN}Protobuf generated in proto/out/${ENDC}"


# .PHONY: _devinstall
# _devinstall:  # Install the development environment.
# 	@mkdir -p .local/datastore/db/
# 	@mkdir -p .local/credentials/
# 	@git submodule update --recursive --remote
# 	@virtualenv -p python3 .venv3
# 	@.venv3/bin/pip install --upgrade pip
# 	@.venv3/bin/pip install --upgrade setuptools
# 	@.venv3/bin/pip install -e .[dev] -v
# 	@.venv3/bin/pip install -e .[all] -v
# 	@echo "${OKGREEN}Activate development environment with: ${OKBLUE}source .venv3/bin/activate${ENDC}"

# # Install testing environment
# .PHONY: testinstall
# testinstall:  # Install local testing environment
# 	@git submodule update --recursive --remote
# 	@virtualenv -p python3 .venv3
# 	@.venv3/bin/pip install --upgrade pip
# 	@.venv3/bin/pip install --upgrade setuptools
# 	@.venv3/bin/pip install -e .[dev] -v
# 	@echo "${OKGREEN}Activate testing environment with: ${OKBLUE}source .venv3/bin/activate${ENDC}"

# lint: # Lint and validate code format.
# 	@rm -f ci/lint/*.txt ci/lint/*.xml
# 	@.venv3/bin/flake8 UsersAPI --exclude *_pb2.py,*_pb2_grpc.py >> ci/lint/flake8.txt || true
# 	@.venv3/bin/flake8_junit ci/lint/flake8.txt ci/lint/flake8_junit.xml > /dev/null 2>&1
# 	@cat ci/lint/flake8.txt


.PHONY: run-dev
run-dev: proto
run-dev: export _MAPI_DEV_DISABLE_AUTH=$(shell date '+%Y-%m-%d %H:%M')
run-dev: export API_SECRET=a-very-secret-string
run-dev: export API_DATASTORE_PROJECT=my-project
run-dev: export API_DATASTORE_NAMESPACE=users-namespace
run-dev: export GOOGLE_APPLICATION_CREDENTIALS=${PWD}/.local/credentials/application_default.json
# run-dev: export GOOGLE_APPLICATION_CREDENTIALS=/ml/Users/MAGICLEAP/atorresgomez/Downloads/analyticsframework-1e0201214e90.json
run-dev: export DATASTORE_EMULATOR_HOST=localhost:8081
run-dev: # Run the development server
	@.venv3/bin/users-server --port 18001 --text-logs

# .PHONY: run-container
# run-container:
# 	@echo $(HOST)$(REPOSITORY):$(TAG)
# 	@docker run -it --rm \
# 		-e _MAPI_DEV_DISABLE_AUTH="$(shell date '+%Y-%m-%d %H:%M')" \
# 		-e API_SECRET="a-very-secret-string" \
# 		$(HOST)$(REPOSITORY):$(TAG)  users-server

.PHONY: db-emulator
db-emulator:  # Run the datastore emulator locally.
	@gcloud beta emulators datastore start --data-dir=.local/datastore/db/

.PHONY: container
container:  # Build the docker container with the applciation.
	@docker build \
		-t $(HOST)$(REPOSITORY):$(TAG) \
		.

.PHONY: push
push: MESSAGE="The application 'Users gRPC server' will be deployed to production."
# push: prompt_y_n
push:  # Push docker image to remote registry
	@docker push $(HOST)$(REPOSITORY):$(TAG)

.PHONY: deploy-service
deploy-service: proto
deploy-service:  # Deploy the endpoints configuration
	@gcloud endpoints services deploy proto/out/api_descriptor.pb api_config.yaml

.PHONY: deploy-kube
deploy-kube:  # Deploy the infrastructure configuration to kubernetes
	@kubectl apply -f infrastructure/app.yaml



.PHONY: prompt_y_n
prompt_y_n:
	@echo $(MESSAGE)
	@( read -p "Are you sure? [y/N]: " sure && case "$$sure" in [yY]) true;; *) false;; esac )


.PHONY: run-client-dev
run-client-dev:
	@.venv3/bin/python UsersAPI/client.py --host 127.0.0.1 --port 18001 --api_key AIzaSyAgwZX25V5FZjgu_DHWmdHi5GxQZkqyjMw













# MAPI_POD=$(shell kubectl -n metrics-api get pods -o=name |  sed "s/^.\{4\}//")






# .PHONY: run-client-prod
# run-client-prod:
# 	@FOO=1 .venv3/bin/python UsersAPI/client.py \
# 		--host metrics.endpoints.analyticsframework.cloud.goog \
# 		--port 9000 \
# 		--api_key AIzaSyAgwZX25V5FZjgu_DHWmdHi5GxQZkqyjMw \
# 		--auth_token ${DS_ID_TOKEN}

# # --auth_token $(shell D auth id-token)
# # export DS_ID_TOKEN=$(D auth id-token)

# .PHONY: kube-deploy
# kube-deploy:
# 	@kubectl apply -f infrastructure/app.yaml

# .PHONY: kube-logs
# kube-logs:
# 	@kubectl -n metrics-api logs $(MAPI_POD) metrics -f

# .PHONY: kube-delete
# kube-delete:
# 	@kubectl -n metrics-api delete pod $(MAPI_POD)

# .PHONY: kube-delete
# kube-repeat: docker-build
# kube-repeat:
# 	@docker push $(HOST)$(REPOSITORY):$(TAG) \
# 		&& kubectl -n metrics-api delete $(shell kubectl -n metrics-api get pods -o=name) \
# 		&& kubectl -n metrics-api logs $(shell kubectl -n metrics-api get pods -o=name) metrics -f

# # kubectl -n metrics-api logs $(kubectl -n metrics-api get pods -o=name) metrics -f
# # .PHONY: run-server
# # run-server: generate-proto
# # run-server: docker-build
# # run-server:
# # 	@docker run --rm -p 18000:8000 $(HOST)$(REPOSITORY):$(TAG)
