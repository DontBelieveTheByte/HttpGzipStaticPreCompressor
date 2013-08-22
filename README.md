#Nginx Gzip Static Pre Compressor
___
## Purpose 

This is a helper script to pre compress files when using the Nginx 
HttpGzipStatic module available at http://wiki.nginx.org/HttpGzipStaticModule

___
##Usage

1. Change the @extensions array to indicate which type of files you want to compress.
2. Set a hard coded directory path by changing the $customDir variable or just use a command line parameter when invoking the script.
3. Run the script manually, when deploying/updating your app or set up a cron job to run it at regular intervals.

___
## Requirements

- Any unix based system with gzip and touch commands installed

- Perl 5
___
## License and copyright

GPLv3 or later versions :  https://www.gnu.org/licenses/gpl.html

Copyright (c) J-F B 2013
