Run this in foreground - dont use nohup
- nohup makes provisioners like 'file' hang

	https://github.com/hashicorp/packer/issues/7677
	- This says using -machine-readable flag fixes the issue (like packer build -machine-readable ... ...)
	- BUT THAT DID NOT HELP - STILL NEED TO RUN IN FOREGROUND ONLY


Touch a file files-to-install.tar.gz  
- otherwise shell-local does not seem to kick off  
