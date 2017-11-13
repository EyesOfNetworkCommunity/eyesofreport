
#!/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

useradd -p eyesofreport -g wheel eyesofreport 2> /dev/null
gpasswd -a eyesofreport wheel 2> /dev/null

ssh_folder=/home/eyesofreport/.ssh

if [ ! -d $ssh_folder ]; then
        mkdir $ssh_folder
fi

file=/home/eyesofreport/.ssh/id_dsa
filename_backup=$(date +'%Y_%m_%d_%s')_id_dsa
filename2_backup=$(date +'%Y_%m_%d_%s')_id_dsa.pub

if [ -f $file ]; then
		echo "DSA Keys already exist for user eyesofreport. Keys are temporary saved in /tmp/$filename_backup and /tmp/$filename2_backup"
        cp $file /tmp/$filename_backup
		cp ${file}.pub /tmp/$filename2_backup
        rm -f $file
		rm -f ${file}.pub
fi

yes | cp -f ${BASEDIR}/id_dsa $ssh_folder/
yes | cp -f ${BASEDIR}/id_dsa.pub $ssh_folder/
chmod 600 ${ssh_folder}/id_dsa
chmod 600 ${ssh_folder}/id_dsa.pub

chown -R eyesofreport:wheel /home/eyesofreport/.ssh

exit

