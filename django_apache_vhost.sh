#!/bin/bash
#----------------------------------------------------------
# Author: José Gonçalves
#
# Desc: create the django.wsgi and the sample vhost.
#
# Version: 1.0
#----------------------------------------------------------

# init variables :
ARG = $1

# Job :

echo "#/bin/python
#-*- coding: utf-8 -*-
#-----------------------------
# ${ARG} WSGI config file
#
#-----------------------------

import os
import sys
import django.core.handlers.wsgi

sys.path.append('/var/www/${ARG}/')

os.environ['DJANGO_SETTINGS_MODULE'] = '${ARG}'

application = django.core.handlers.wsgi.WSGIHandler()
" > django.wsgi

echo "
<VirtualHost *:80>
        ServerAdmin example@domain.org
        ServerName HOSTNAME.DOMAIN.TLD
        ServerAlias WWW.DOMAIN.TLD
        DocumentRoot /var/www/${ARG}/
        Alias /static/ /var/www/${ARG}/static/

        WSGIDaemonProcess darmon-${ARG} user=www-data group=www-data processes=1 maximum-requests=50 threads=5 inactivity-timeout=6
        WSGIProcessGroup daemon-${ARG}
        WSGIScriptAlias / /var/www/${ARG}/apache/django.wsgi

        <Directory /var/www/${ARG}/apache>
                Order deny,allow
                Allow from All
        </Directory>

        ErrorLog /var/www/${ARG}/error.log
        CustomLog /var/www/${ARG}/access.log combined
</VirtualHost>
" > django_vhost_sample

# Cleaning
unset ARG

exit 0;