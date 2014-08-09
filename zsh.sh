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
wget http://formation-debian.via.ecp.fr/fichiers-config/zshrc
wget http://formation-debian.via.ecp.fr/fichiers-config/zshenv
wget http://formation-debian.via.ecp.fr/fichiers-config/zlogin
wget http://formation-debian.via.ecp.fr/fichiers-config/zlogout
wget http://formation-debian.via.ecp.fr/fichiers-config/dir_colors
 
echo '========================================
* Moving Files :
========================================
'
mv zshrc zshenv zlogin zlogout /etc/zsh/
mv dir_colors /etc/
 
echo '========================================
* Setup zsh by default :
========================================
'
su - root -c 'chsh'
su - ${USER} -c 'chsh'
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
