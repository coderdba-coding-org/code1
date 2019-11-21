This creates an image with a golang program/repo

See .drone.yml for more

NOTE: The 'app' and 'logger' can be from same or other repo.  
      However, for convenience it is in the same repo
      Also, the 'imports' of app and logger in main.go 
            will pull the same git repo as this for compilation - if they are in the same repo as this
