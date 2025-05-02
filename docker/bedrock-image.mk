#-*- mode: makefile; -*-
# use pattern rule public-%: bedrock:% when `make` can be upgraded to 4+
	set -x; LOG=$$(mktemp); \
	echo $$LOG; \
	docker build  --build-arg VERSION=$(BEDROCK_VERSION) -f $< . -t $@:latest | tee $$LOG; \
	cat $$LOG | grep 'Successfully built' | awk '{print $$3}' > $@; \
	rm $$LOG;
