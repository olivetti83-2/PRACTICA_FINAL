C=infraestructura
all: init plan apply

init:
	@echo ---------------------------------------------------------- tf-init
	cd $(C) && terraform init

plan:
	@echo ---------------------------------------------------------- tf-plan
	cd $(C) && terraform plan

apply:
	@echo ---------------------------------------------------------- tf-apply
	cd $(C) && terraform apply