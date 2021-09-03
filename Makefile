DOCKER_NAME = "madminer-workflow-ph"
DOCKER_REGISTRY = "madminertool"
DOCKER_VERSION = $(shell cat VERSION)

YADAGE_INPUT_DIR = "$(PWD)/workflow"
YADAGE_SPEC_DIR = "$(PWD)/workflow/yadage"
YADAGE_WORK_DIR = "$(PWD)/.yadage"


.PHONY: check
check:
	@echo "Checking code format"
	@black --check "code"


.PHONY: build
build:
	@echo "Building Docker image..."
	@docker build . --tag $(DOCKER_REGISTRY)/$(DOCKER_NAME):$(DOCKER_VERSION)


.PHONY: push
push: build
	@echo "Pushing Docker image..."
	@docker login --username "${DOCKERUSER}" --password "${DOCKERPASS}"
	@docker push $(DOCKER_REGISTRY)/$(DOCKER_NAME):$(DOCKER_VERSION)


.PHONY: yadage-clean
yadage-clean:
	@echo "Cleaning previous run..."
	@rm -rf $(YADAGE_WORK_DIR)


.PHONY: yadage-run
yadage-run: yadage-clean
	@echo "Launching Yadage..."
	@yadage-run $(YADAGE_WORK_DIR) "workflow.yml" \
		-p input_file="input.yml" \
		-p num_procs_per_job="1" \
		-d initdir=$(YADAGE_INPUT_DIR) \
		--toplevel $(YADAGE_SPEC_DIR)
