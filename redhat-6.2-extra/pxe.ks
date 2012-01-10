# Kickstart file automatically generated by anaconda.

install
url --url http://192.168.1.2:8091/ubuntu_dvd
key --skip
lang en_US.UTF-8
keyboard us
text
# network --bootproto=dhcp
# crowbar
rootpw --iscrypted $1$H6F/NLec$Fps2Ut0zY4MjJtsa1O2yk0
firewall --disabled
authconfig --enableshadow --enablemd5
selinux --disabled
timezone --utc Europe/London
bootloader --location=mbr --driveorder=sda
zerombr
ignoredisk --only-use=sda
clearpart --all --drives=sda
part /boot --fstype ext3 --size=100 --ondisk=sda
part swap --recommended
part pv.6 --size=1 --grow --ondisk=sda
volgroup lv_admin --pesize=32768 pv.6
logvol / --fstype ext3 --name=lv_root --vgname=lv_admin --size=1 --grow
reboot

%packages

@base
@core
@editors
@text-internet
keyutils
trousers
fipscheck
device-mapper-multipath
OpenIPMI
OpenIPMI-tools
emacs-nox
openssh
createrepo

%post
export PS4='${BASH_SOURCE}@${LINENO}(${FUNCNAME[0]}): '
exec > /root/post-install.log 2>&1

BASEDIR="/tftpboot/redhat_dvd"
OS_TOKEN="redhat-6.2"
# copy the install image.
mkdir -p "$BASEDIR"
(   cd "$BASEDIR"
    while ! wget -q http://192.168.1.2:8091/files.list; do sleep 1; done
    while read f; do
	wget -a /root/post-install-wget.log -x -nH --cut-dirs=1 \
	    "http://192.168.1.2:8091/${f#./}"
    done < files.list
    rm files.list
)
	
# Fix links
while read file dest; do
  L_FILE=${file##*/}
  L_DIR=dirname ${file%/*}
  T_FILE=$dest
  (cd "${BASEDIR}/$L_DIR" ; ln -s "$T_FILE" "$L_FILE")
done < "${BASEDIR}/crowbar_links.list"

. /tftpboot/redhat_dvd/extra/redhat-common-post.sh
