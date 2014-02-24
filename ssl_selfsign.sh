#!/bin/bash

#-------------------------------------------
# Author : José Gonçalves
#
# Desc : Generate a self signed certificate
# 	 to host with ssl your stuff.
#
# Version : 1.0
#-------------------------------------------

# Declare some variables :
ARG=$1

# Intro!
clear;

echo "
=====================================================================
 ___  ___  _                                    _
/ __>/ __>| |    ___  ___ ._ _  ___  _ _  ___ _| |_ ___  _ _
\__ \\__ \| |_  / . |/ ._>| ' |/ ._>| '_><_> | | | / . \| '_>
<___/<___/|___| \_. |\___.|_|_|\___.|_|  <___| |_| \___/|_|
                <___'
=====================================================================

"
# Job part :
echo "Generating an SSL private key to sign your certificate..."
openssl genrsa -out $ARG.key 2048

echo "Generating a Certificate Signing Request..."
openssl req -new -key $ARG.key -out $ARG.csr

echo "Removing passphrase from key (for nginx or apache)"
cp $ARG.key $ARG.key.org
openssl rsa -in $ARG.key.org -out $ARG.key
rm $ARG.key.org

echo "Generating certificate..."
openssl x509 -req -days 365 -in $ARG.csr -signkey $ARG.key -out $ARG.crt

echo "Copying certificate ($ARG.crt) to /etc/ssl/certs/"
mkdir -p /etc/ssl/certs
cp $ARG.crt /etc/ssl/certs/

echo "Copying key ($ARG.key) to /etc/ssl/private/"
mkdir -p /etc/ssl/private
cp $ARG.key /etc/ssl/private/

unset ARG

exit 0;