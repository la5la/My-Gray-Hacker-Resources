#!/bin/bash

r=`x="() { :; }; echo x" bash -c ""`
if [ -n "$r" ]; then
	echo -e '\033[91mVulnerable to CVE-2014-6271 (original shellshock)\033[39m'
else
	echo -e '\033[92mNot vulnerable to CVE-2014-6271 (original shellshock)\033[39m'
fi

cd /tmp;rm echo 2>/dev/null
X='() { function a a>\' bash -c echo 2>/dev/null > /dev/null
if [ -e echo ]; then
	echo -e "\033[91mVulnerable to CVE-2014-7169 (taviso bug)\033[39m"
else
	echo -e "\033[92mNot vulnerable to CVE-2014-7169 (taviso bug)\033[39m"
fi

bash -c "true $(printf '<<EOF %.0s' {1..16})" 2>/dev/null
if [ $? != 0 ]; then
	echo -e "\033[91mVulnerable to CVE-2014-7186 (redir_stack bug)\033[39m"
else
	echo -e "\033[92mNot vulnerable to CVE-2014-7186 (redir_stack bug)\033[39m"
fi

bash -c "`for i in {1..200}; do echo -n "for x$i in; do :;"; done; for i in {1..200}; do echo -n "done;";done`" 2>/dev/null
if [ $? != 0 ]; then
	echo -e "\033[91mVulnerable to CVE-2014-7187 (nested loops off by one)\033[39m"
else
	echo -e "\033[96mTest for CVE-2014-7187 not reliable without address sanitizer\033[39m"
fi

r=`a="() { echo x;}" bash -c a 2>/dev/null`
if [ -n "$r" ]; then
	echo -e "\033[93mVariable function parser still active, likely vulnerable to yet unknown parser bugs like CVE-2014-6277 (lcamtuf bug)\033[39m"
else
	echo -e "\033[92mVariable function parser inactive, likely safe from unknown parser bugs\033[39m"
fi
