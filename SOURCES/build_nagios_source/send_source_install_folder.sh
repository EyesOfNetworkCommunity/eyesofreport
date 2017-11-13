#!/bin/bash
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE=install_source.tar.gz
FILE2=completeInstallClient.sh
PATH1=${BASEDIR}/${FILE}
PATH2=${BASEDIR}/${FILE2}

mkdir $BASEDIR/remote_intall 2> /dev/null
yes | cp $PATH1 $BASEDIR/remote_intall
yes | cp $PATH2 $BASEDIR/remote_intall

/usr/bin/rsync -avr --rsh=/usr/bin/ssh $BASEDIR/remote_intall/* root@$1:/tmp

remote_install=0
while true; do
	read -p "Do you want to execute automatic data transfert install through ssh on $1 ? " yn
	case $yn in
		[Nn]*) echo "Client install files are located in BASEDIR/remote_install";break;;
		[Yy]*) remote_install=1;break;;
		*) echo "Please type y or n";;
	esac
done

if [ "$remote_install" -eq 1 ]; then
	ssh root@$1 << EOF
chmod +x /tmp/completeInstallClient.sh
/tmp/completeInstallClient.sh
EOF
fi	

exit 0





