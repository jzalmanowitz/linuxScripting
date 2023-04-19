#!/bin/bash
clear
echo "Welcome to mediaserver!"
echo ""
echo "System information:"
echo "-------------------"
lsb_release -d
uname -a
uptime
echo "External IP is: $(cat /home/jason/scripts/speedtest/externalip.txt | jq -r '.origin')"
echo ""
echo "Disk usage:"
echo "-----------"
df -h
echo ""
echo "Memory usage:"
echo "-------------"
free -h
echo ""
echo "Installed packages:"
echo "-------------------"
dpkg --list | grep '^ii' | awk '{print $2}' > /tmp/default_packages.txt
grep -v -x -f /tmp/default_packages.txt <(dpkg --get-selections | awk '{print $1}') | sort
echo ""
echo "Speedtest Results:"
echo "-------------------"
cat /home/jason/scripts/speedtest/mediaserver_info.txt
echo ""
sudo echo "Fail2Ban Results:"
echo "-------------------"
count=$(sudo zgrep 'Ban' /var/log/fail2ban.log | wc -l)

echo "There are $count records. Do you want to see them? ([Y]es/[N]o)"
read answer

if [[ "$answer" =~ ^[Yy][Ee]?[Ss]?$ ]]; then
  sudo zgrep 'Ban' /var/log/fail2ban.log
elif [[ "$answer" =~ ^[Nn][Oo]?$ ]] || [[ -z "$answer" ]]; then
  echo ""
else
  echo "Invalid input, please enter 'yes' or 'no'"
fi
