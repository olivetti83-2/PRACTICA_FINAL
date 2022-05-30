C=infraestructura

all: clean init plan apply

clean:
	@echo --------------------------------------------------------------------------- tf-clean
	rm -rf $(C)/.terraform*

init:
	@echo --------------------------------------------------------------------------- tf-init
	cd $(C) && terraform init -backend-config="key=dev/terraform.practica-final-cicd"

plan:
	@echo --------------------------------------------------------------------------- tf-plan
	cd $(C) && terraform plan

apply:
	@echo --------------------------------------------------------------------------- tf-apply
	cd $(C) && terraform apply