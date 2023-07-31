run:
	packer init config.pkr.hcl
	packer build -var-file variables.pkrvars.hcl debian12/packer.pkr.hcl