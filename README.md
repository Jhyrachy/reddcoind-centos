Files required to get reddcoind running on CentOS
- create a new user
- put these files into the user's home directory. You don't want to do this as root. 
- Then go ahead and run the ./centos-install.sh and it should create reddcoind, if you've installed the other yum dependencies. 
- Only other thing to note is that you might need to after installing make a symbolic link for ld64 in your /lib directory and you'll need to be root to do that.
