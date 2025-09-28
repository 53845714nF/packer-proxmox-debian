.PHONY: run

run:
	packer init config.pkr.hcl
	packer build -var-file variables.pkrvars.hcl debian/debian.pkr.hcl