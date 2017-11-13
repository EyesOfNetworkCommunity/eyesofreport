FROM centos_systemd
MAINTAINER Benoit Village <benoit.village@apx.fr>

ADD /Install_Files.tar /tmp/
RUN cd /tmp \
 && rpm -ivh /tmp/createrepo/deltarpm-3.6-3.el7.x86_64.rpm \
 && rpm -ivh /tmp/createrepo/python-deltarpm-3.6-3.el7.x86_64.rpm \
 && rpm -ivh /tmp/createrepo/libxml2-python-2.9.1-5.el7_1.2.x86_64.rpm \
 && rpm -ivh /tmp/createrepo/createrepo-0.9.9-23.el7.noarch.rpm \
 && mkdir -p /srv/eyesofreport/depot-1.0 \
 && ln -s /srv/eyesofreport/depot-1.0 /srv/eyesofreport/depot \
 && cp /tmp/rpm/* /srv/eyesofreport/depot \
 && echo "[localrepo]" >> /etc/yum.repos.d/localrepo.repo \
 && echo "name=Eyesofreport repository" >> /etc/yum.repos.d/localrepo.repo \
 && echo "baseurl=file:///srv/eyesofreport/depot" >> /etc/yum.repos.d/localrepo.repo \
 && echo "gpgcheck=0" >> /etc/yum.repos.d/localrepo.repo \
 && echo "enabled=1" >> /etc/yum.repos.d/localrepo.repo \
 && createrepo -v /srv/eyesofreport/depot/

RUN yum install -y --disablerepo="*" --enablerepo="localrepo" nano openssh-server rsync crontabs \
 && groupadd eor && useradd -p eyesofreport -g eor eyesofreport \
 && /usr/bin/ssh-keygen -A \
 && mkdir /home/eyesofreport/.ssh \
 && chmod 700 /home/eyesofreport/.ssh \
 && touch /home/eyesofreport/.ssh/authorized_keys && echo 'public_key' >> /home/eyesofreport/.ssh/authorized_keys \
 && chmod 600 /home/eyesofreport/.ssh/authorized_keys \
 && chown -R eyesofreport:eor /home/eyesofreport \
 && mkdir -p /home/eyesofreport/external_depot/Log_Nagios_Depot \
 && mkdir -p /home/eyesofreport/external_depot/Ged_Depot \
 && mkdir -p /home/eyesofreport/external_depot/Lilac_Depot \
 && mkdir -p /home/eyesofreport/external_depot/Nagios_BP_Depot \
 && mkdir -p /home/eyesofreport/external_depot/Log_Nagios \
 && mkdir -p /home/eyesofreport/external_depot/Ged \
 && mkdir -p /home/eyesofreport/external_depot/Lilac && mkdir -p /home/eyesofreport/external_depot/Nagios_BP && chown -R eyesofreport:eor /home/eyesofreport \
 && mkdir /var/run/sshd

RUN sed -i 's/#Port 22/Port ssh_port/g' /etc/ssh/sshd_config \
 && sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config \
 && echo "AllowUsers eyesofreport" >> /etc/ssh/sshd_config \
 && echo "*/1 * * * * root mv /home/eyesofreport/external_depot/Log_Nagios_Depot/nagios-*.log /home/eyesofreport/external_depot/Log_Nagios/" >> /etc/crontab \
 && echo "*/1 * * * * root mv /home/eyesofreport/external_depot/Ged_Depot/* /home/eyesofreport/external_depot/Ged/" >> /etc/crontab \
 && echo "*/1 * * * * root mv /home/eyesofreport/external_depot/Lilac_Depot/* /home/eyesofreport/external_depot/Lilac/" >> /etc/crontab \
 && echo "*/1 * * * * root mv /home/eyesofreport/external_depot/Nagios_BP_Depot/* /home/eyesofreport/external_depot/Nagios_BP/" >> /etc/crontab

RUN systemctl enable sshd.service && systemctl enable crond

EXPOSE ssh_port
CMD /usr/lib/systemd/systemd --system
