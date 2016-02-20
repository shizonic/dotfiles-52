#!/bin/bash

#
# Xcode Command-Line Tools
#

echo -e "* \033[0;33mDetermining Xcode status. You may be asked to enter root password.\033[0;0m"
xcode-select --install 2>/dev/null
if [[ $? == 1 ]] ; then
    echo -e "\033[1A\033[K* Xcode has been successfully setup. \033[0;32m✓\033[0;0m"
fi


#
# Homebrew
#

which -s brew
if [[ $? != 0 ]] ; then
    echo -e "* \033[0;33mHomebrew is not installed. Installing.\033[0;0m"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo -e "* Homebrew is already installed. \033[0;32m✓\033[0;0m"
fi

#
# Ansible
#

which -s ansible-playbook
if [[ $? != 0 ]] ; then
    echo -e "* \033[0;33mAnsible is not installed. Installing.\033[0;0m"
    $(which brew) install ansible
else
    echo -e "* Ansible is already installed. \033[0;32m✓\033[0;0m"
fi

#
# Playbook
#

echo -e "* \033[0;33mRunning Ansible playbook. This will take a while.\033[0;0m"
$(which ansible-playbook) provision/local.yml -K -i provision/hosts $@