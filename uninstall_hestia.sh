#!/bin/bash

# ======================================================== #
#
# Unofficial Hestia CP Uninstallation Routine
# Automatic OS detection wrapper
# Note: This is purely for Educational purposes, to Test/Try before opting the product 
# Let's respect the hard work of any community developer, who has contributed in developing such a wonderful portal source, that works without a flaw in Ubuntu 24.04(Not just limited to Ubuntu 20.04) too.
# Use it ONLY for learning purposes and NOT on Production Environments. Use this script at your own risk.
# Works well on the supported Operating Systems. 
# Currently Supported Operating Systems:
#
# Debian 11, 12
# Ubuntu 20.04, 22.04, 24.04 LTS
#
# ======================================================== #

# Am I root?
if [ "x$(id -u)" != 'x0' ]; then
        echo 'Error: this script can only be executed by root'
        exit 1
fi

# Detect OS
if [ -e "/etc/os-release" ] && [ ! -e "/etc/redhat-release" ]; then
        type=$(grep "^ID=" /etc/os-release | cut -f 2 -d '=')
        if [ "$type" = "ubuntu" ]; then
                # Check if lsb_release is installed
                if [ -e '/usr/bin/lsb_release' ]; then
                        release="$(lsb_release -s -r)"
                        VERSION='ubuntu'
                else
                        echo "lsb_release is currently not installed, please install it:"
                        echo "apt-get update && apt-get install lsb-release"
                        exit 1
                fi
        elif [ "$type" = "debian" ]; then
                release=$(cat /etc/debian_version | grep -o "[0-9]\{1,2\}" | head -n1)
                VERSION='debian'
        else
                type="NoSupport"
        fi
# elif [ -e "/etc/os-release" ] && [ -e "/etc/redhat-release" ]; then
#       type=$(grep "^ID=" /etc/os-release | cut -f 2 -d '"')
#       if [ "$type" = "rhel" ]; then
#               release=$(cat /etc/redhat-release | cut -f 1 -d '.' | awk '{print $3}')
#               VERSION='rhel'
#       elif [ "$type" = "almalinux" ]; then
#               release=$(cat /etc/redhat-release | cut -f 1 -d '.' | awk '{print $3}')
#               VERSION='almalinux'
#       elif [ "$type" = "eurolinux" ]; then
#               release=$(cat /etc/redhat-release | cut -f 1 -d '.' | awk '{print $3}')
#               VERSION='eurolinux'
#       elif [ "$type" = "rocky" ]; then
#               release=$(cat /etc/redhat-release | cut -f 1 -d '.' | awk '{print $3}')
#               VERSION='rockylinux'
#       fi
else
        type="NoSupport"
fi

no_support_message() {
        echo "****************************************************"
        echo "Your operating system (OS) is not supported by"
        echo "Hestia Control Panel. Officially supported releases:"
        echo "****************************************************"
        echo "  Debian 11, 12"
        echo "  Ubuntu 20.04, 22.04, 24.04 LTS"
        # Commenting this out for now
        # echo "  AlmaLinux, EuroLinux, Red Hat Enterprise Linux, Rocky Linux 8,9"
        echo ""
        exit 1
}

if [ "$type" = "NoSupport" ]; then
        no_support_message
fi

check_wget_curl() {
        # Check wget
        if [ -e '/usr/bin/wget' ]; then
                # if [ -e '/etc/redhat-release' ]; then
                #       wget -q https://raw.githubusercontent.com/hestiacp/hestiacp/release/uninstall/hst-uninstall-rhel.sh -O hst-uninstall-rhel.sh
                #       if [ "$?" -eq '0' ]; then
                #               bash hst-uninstall-rhel.sh $*
                #               exit
                #       else
                #               echo "Error: hst-uninstall-rhel.sh download failed."
                #               exit 1
                #       fi
                # else
                wget -q https://raw.githubusercontent.com/hestiacp/hestiacp/release/uninstall/hst-uninstall-$type.sh -O hst-uninstall-$type.sh
                if [ "$?" -eq '0' ]; then
                        bash hst-uninstall-$type.sh $*
                        exit
                else
                        echo "Error: hst-uninstall-$type.sh download failed."
                        exit 1
                fi
                # fi
        fi

        # Check curl
        if [ -e '/usr/bin/curl' ]; then
                # if [ -e '/etc/redhat-release' ]; then
                #       curl -s -O https://raw.githubusercontent.com/hestiacp/hestiacp/release/uninstall/hst-uninstall-rhel.sh
                #       if [ "$?" -eq '0' ]; then
                #               bash hst-uninstall-rhel.sh $*
                #               exit
                #       else
                #               echo "Error: hst-uninstall-rhel.sh download failed."
                #               exit 1
                #       fi
                # else
                curl -s -O https://raw.githubusercontent.com/hestiacp/hestiacp/release/uninstall/hst-uninstall-$type.sh
                if [ "$?" -eq '0' ]; then
                        bash hst-uninstall-$type.sh $*
                        exit
                else
                        echo "Error: hst-uninstall-$type.sh download failed."
                        exit 1
                fi
                # fi
        fi
}

# Check for supported operating system before proceeding with download
# of OS-specific uninstaller, and throw error message if unsupported OS detected.
if [[ "$release" =~ ^(11|12|20.04|22.04|24.04)$ ]]; then
        check_wget_curl $*
# elif [[ -e "/etc/redhat-release" ]] && [[ "$release" =~ ^(8|9)$ ]]; then
#       check_wget_curl $*
else
        no_support_message
fi

exit
