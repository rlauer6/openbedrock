#-*- mode: makefile; -*-

DOCKERFILE_GITHUB = Dockerfile.github
GHCR = ghcr.io
GHCR_REPO = $(GHCR)/rlauer6
GITHUB_TOKEN ?= $(shell cat ~/.ssh/github.token)

.PHONY: bedrock-ci
bedrock-ci: $(DOCKERFILE_GITHUB) bedrock-test
	echo $(GITHUB_TOKEN) | docker login $(GHCR) -u rlauer6 --password-stdin
	docker build -f $< . -t $(GHCR_REPO)/bedrock-test
	docker push $(GHCR_REPO)/bedrock-test:latest

bedrock-test: $(DOCKERFILE_GITHUB)
	set -x; LOG=$$(mktemp); \
	echo $$LOG; \
	docker build -f $< . -t $@:latest | tee $$LOG; \
	cat $$LOG | grep 'Successfully built' | awk '{print $$3}' > $@; \
	rm $$LOG;
