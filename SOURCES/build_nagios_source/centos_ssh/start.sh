
#!/bin/bash

trigram=$3

for file in `docker ps | grep $1`; do
	echo -e "container $1 already up 	\e[92m[STARTED] \e[39m"
	exit
done

for file in `docker ps -a | grep $1`; do
	echo "container $1 exist : starting..."
        docker start $1
	echo -e "container $1		\e[92m[STARTED] \e[39m"
	exit
done

docker run -d -p $2:$2 --privileged -v /srv/eyesofreport/source/$3/Log_Nagios:/home/eyesofreport/external_depot/Log_Nagios -v /srv/eyesofreport/source/$3/Ged:/home/eyesofreport/external_depot/Ged -v /srv/eyesofreport/source/$3/Lilac:/home/eyesofreport/external_depot/Lilac -v /srv/eyesofreport/source/$3/Nagios_BP:/home/eyesofreport/external_depot/Nagios_BP -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name $1 $1
