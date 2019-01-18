
PWD=$(shell pwd)


.PHONY: help
help:
	@echo ">> To deploy to production:"
	@echo "   $ make deployspec"
	@echo "   $ make deploy"

# Install development environment
.PHONY: devinstall
devinstall:
	@echo "Installing local development environment"
	@mkdir -p lib/
	@pip install --target lib/ --requirement requirements.txt --upgrade

# Install testing environment
.PHONY: testinstall
testinstall:
	@echo "Installing local testing environment"
	@virtualenv -p python3 .venv3
	@.venv3/bin/pip install --upgrade pip
	@.venv3/bin/pip install --upgrade setuptools
	@.venv3/bin/pip install flake8 --upgrade
	@.venv3/bin/pip install flake8-junit-report --upgrade

# Install testing environment
.PHONY: lint
lint:
	@rm -f flake8.txt flake8_junit.xml
	@.venv3/bin/flake8 . --exclude lib/,.venv3/ >> flake8.txt || true
	@.venv3/bin/flake8_junit flake8.txt flake8_junit.xml > /dev/null 2>&1
	@cat flake8.txt

.PHONY: buildspec
buildspec:
	@python lib/endpoints/endpointscfg.py get_openapi_spec main.UsersApi

.PHONY: deployspec
deployspec: buildspec
deployspec:
	@gcloud endpoints services deploy usersv1openapi.json --project analyticsframework

.PHONY: deploy
deploy:
	@gcloud app deploy
