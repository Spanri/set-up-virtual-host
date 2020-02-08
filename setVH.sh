#!/bin/bash

#  If without sudo, the script doesn't work
if [ "$(whoami)" != "root" ]; then
	echo "\e[32m× Root privileges are required to run this, try running with sudo\e[39m"
	exit 1;
fi

# If the parameter is not entered, the script doesn't work
if [ "$1" = "" ] ; then
  echo "\e[91m× Parameter with site name not found\e[39m"
  exit 1;
fi

# Take the name of the site, the name of the config for the site,
# check the existence of the config file
site_name=$1
config_file="$site_name.conf"
if [ ! -f "$config_file" ]; then
  echo "\e[91m× File '$config_file' does not exist\e[39m";
  exit 1;
fi

# Moving the file <site_name>.conf to sites-available
sites_available_path="/etc/apache2/sites-available/"
cp $config_file /$sites_available_path
echo "\e[32m✔ Config file was successfully copied to the folder '$sites_available_path'\e[39m"

# Check if the config file exists in sites-enabled and 
# if it does not, make sure it does
sites_enabled_path="/etc/apache2/sites-enabled/"
if [ ! -f "$sites_enabled_path/$config_file" ]; then
  a2ensite $config_file
  echo "\e[32m✔ Config file was successfully e2ensite to the folder '$sites_enabled_path'\e[39m"
else 
  echo "\e[32m✔ Operation 'e2ensite' is not necessary\e[39m"
fi

# Restarting the Apache
systemctl restart apache2
if ! pgrep apache2 -c >/dev/null; then
  echo "\e[91m× Error in apache restart\e[39m";
  echo "\e[94mThe config file has been removed from the 'sites-available' and 'sites-enabled' folders\e[39m";
  rm $sites_available_path/$config_file
  rm $sites_enabled_path/$config_file
  exit 1;
else  
  echo "\e[32m✔ Apache2 restarted\e[39m"
fi

# Setting up the host
hosts_path="/etc/hosts"
if [ ! $(grep -Ril $site_name "$hosts_path") ]; then
  echo 127.0.0.1    $site_name >> $hosts_path
  echo "\e[32m✔ Hosts file updated\e[39m"
else
  echo "\e[32m✔ Updating the hosts file is not necessary\e[39m"
fi