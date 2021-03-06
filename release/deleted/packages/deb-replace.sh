#!/bin/bash
set -e

if [ "$USER" != "root" ] ; then
    echo "error: you are not run as root user, you should excute sudo."
    exit
fi
echo -e "\033[31m upgrade for COS Desktop v0.5 \033[0m"

COSREPOIP=124.16.141.172
#添加源
echo "deb http://${COSREPOIP}/cos iceblue main" > /etc/apt/sources.list.d/cos-repository.list
#添加密钥文件
wget -q -O - http://${COSREPOIP}/cos/project/keyring.gpg | apt-key add -
wget -q -O - http://${COSREPOIP}/cos/project/coskeyring.gpg | apt-key add -

#为新加源赋予优先级
origin=`sed -n '2p' /etc/apt/preferences | awk '{print $3}'`
if [ ${origin} != "o=cos" ] ; then
sed -i '1i\Package: *\
Pin: release o=cos\
Pin-Priority: 700\

' /etc/apt/preferences
fi
perl /tmp/repos-conf.pl

rm -rf /var/lib/apt/lists/*
apt-get update -o Dir::Etc::sourcelist="sources.list.d/cos-repository.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"

apt-get install cos-upgrade

#mintpackages=("mint-mdm-themes" "mint-meta-cinnamon" "mintwelcome" "mint-meta-core" "ubuntu-system-adjustments" \
#"mint-artwork-gnome" "mint-artwork-common" "mint-backgrounds-olivia" "mintsystem" "mintdesktop" \
#"mint-info-cinnamon")
#for pkg in ${mintpackages[*]}; do
#    dpkg -s ${pkg} &> /dev/null && result=0 || result=1
#    #package is not install.
#    if [ "${result}" == 1 ]; then
#        echo -e "\033[31m remove package ${pkg} : ${pkg} is not install or has been removed. \033[0m"
#    else
#        echo -e "\033[31m remove package ${pkg}. \033[0m"
#        dpkg -P ${pkg}
#    fi
#done
#
#cospackages=("cos-info-iceblue" "cosdesktop" "cossystem" "cos-artwork-common" "cos-backgrounds-iceblue" \
#"cos-artwork-gnome" "cos-system-adjustments" "cos-meta-core" "coswelcome" "cos-mdm-themes")
#for pkg in ${cospackages[*]}; do
#    dpkg -s ${pkg} &> /dev/null && result=0 || result=1
#    #package is not install.
#    if [ "${result}" == 1 ]; then
#        echo -e "\033[31m installing package ${pkg}. \033[0m"
#        apt-get install ${pkg}
#    else
#        echo -e "\033[31m install mpackage ${pkg} : ${pkg} has been installed. \033[0m"
#    fi
#done
#
#apt-get clean
rm /tmp/repos-conf.pl
echo -e "\033[31m upgrade for COS Desktop v0.5 success. \033[0m"
