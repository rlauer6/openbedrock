#-*- mode: makefile; -*-
# use pattern rule publi-%: bedrock:% when `make` can be upgraded to 4+
	echo "$(DOCKERHUB_TOKEN)" | docker login -u rlauer --password-stdin
	image="$<"; \
	docker tag $$image:latest $(REPO):$$image; \
	docker push $(REPO):$$image
