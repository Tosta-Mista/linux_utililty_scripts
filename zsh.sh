#!/bin/bash
######################
# Name : zsh Installer!
#
# Purpose : Install zsh and set up to starup
#
# Version : 0.1
######################
 
clear;
echo '###################################
### Zsh Install :               ###
###                             ###
###################################
 
========================================
* Install Zsh :
========================================
'
apt-get update && apt-get upgrade
apt-get install zsh
 
echo '========================================
* Downloading config files :
========================================
'
cd ~
wget http://formation-debian.via.ecp.fr/fichiers-config/zshrc > /etc/zsh/zshrc
wget http://formation-debian.via.ecp.fr/fichiers-config/zshenv > /etc/zsh/zshenv
wget http://formation-debian.via.ecp.fr/fichiers-config/zlogin > /etc/zsh/zlogin
wget http://formation-debian.via.ecp.fr/fichiers-config/zlogout > /etc/zsh/zlogout
wget http://formation-debian.via.ecp.fr/fichiers-config/dir_colors > /etc/dir_colors
 
echo '========================================
* Setup zsh by default :
========================================
'
chsh

echo '========================================
= [TIPS]                               =
= You can add users to zsh, execute    =
= the following command :              =
= - "chsh <username>" and enter the    =
= correct path (/bin/zsh)...           =
========================================
'
 
echo '========================================
= Installation Done!                   =
========================================'
