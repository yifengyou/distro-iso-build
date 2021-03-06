#安装wps-office和wps需要的字体，该字体版权属于微软,把此脚本放在squashfs-root/../路径下,把app目录放在～/app下
set -e

CHROOTDIR=~/pcos/mkiso_out/squashfs-root
DEBDIR=~/pcos/app
DEBNAME=kingsoft-office_9.1.0.4244~a12p3_i386.deb
DEBNAME2=symbol-fonts_1.2_all.deb

if [ -z "$1" ] ; then
    echo error: No chrootdir setting at first param.
    exit -1
fi

if [ -z "$2" ] ; then
    echo error: No deb dir setting at second param.
    exit -1
fi

CHROOTDIR=$1/squashfs-root
DEBDIR=$2

if [ ! -e "${CHROOTDIR}" ]; then
    echo "squashfs-root not found"
    exit -1
fi

mkdir ${CHROOTDIR}/app
cp ${DEBDIR}/${DEBNAME} ${CHROOTDIR}/app
cp ${DEBDIR}/${DEBNAME2} ${CHROOTDIR}/app

#chroot ${CHROOTDIR} /bin/bash -c "cd app && dpkg -i wps-office_8.1.0.3724~b1p2_i386.deb && apt-get remove -y --purge libreoffice-*"
chroot ${CHROOTDIR} /bin/bash -c "cd app && dpkg -i -E kingsoft-office_9.1.0.4244~a12p3_i386.deb"


#安装wps所需字体，该字体版权属于微软
chroot ${CHROOTDIR} /bin/bash -c "cd app && dpkg -i -E symbol-fonts_1.2_all.deb"
chroot ${CHROOTDIR} /bin/bash -c "rm -rf app"
#cp ~/文档/* ${CHROOTDIR}

echo "Wps-office and wps-fonts installed successful!"
