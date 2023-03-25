# mgr-bash-scripts
This repository contains scripts written in bash, which will be used to carry out the research in the master thesis.
The scripts was created to detect the moment a user interacts with a mobile application written in one of the React Native or Flutter technologies.

## How to run scripts

1. Open the **git bash cmd**
2. Type **./badania.sh <user_name>** Or **bash badania.sh <user_name>"**


##Tips and tricks
Scripts will be terminated if your current main activity on mobile phone isn't the one specific in the scripts.
Scripts automatically will be terminated after 3 minutes or if user close the app. 
<user_name> is a string variable e.g "User1" or "AAAA" it is important to run script with username because the script based on the first 
parameter will be create output file with data from research.
