FROM centos:7.1.1503
MAINTAINER Benoit Village <benoit.village@apx.fr>

ADD /Install_Files.tar /tmp/
RUN cd /tmp \
 && rpm -ivh --replacepkgs --replacefiles /tmp/createrepo/libxml2-2.9.1-5.el7_1.2.x86_64.rpm \
 && rpm -ivh /tmp/createrepo/deltarpm-3.6-3.el7.x86_64.rpm \
 && rpm -ivh /tmp/createrepo/python-deltarpm-3.6-3.el7.x86_64.rpm \
 && rpm -ivh /tmp/createrepo/libxml2-python-2.9.1-5.el7_1.2.x86_64.rpm \
 && rpm -ivh /tmp/createrepo/createrepo-0.9.9-23.el7.noarch.rpm \
 && rpm -ivh /tmp/rpm/yum-plugin-ovl-1.1.31-34.el7.noarch.rpm \
 && mkdir -p /srv/eyesofreport/depot-1.0 \
 && ln -s /srv/eyesofreport/depot-1.0 /srv/eyesofreport/depot \
 && cp /tmp/rpm/* /srv/eyesofreport/depot \
 && echo "[localrepo]" >> /etc/yum.repos.d/localrepo.repo \
 && echo "name=Eyesofreport repository" >> /etc/yum.repos.d/localrepo.repo \
 && echo "baseurl=file:///srv/eyesofreport/depot" >> /etc/yum.repos.d/localrepo.repo \
 && echo "gpgcheck=0" >> /etc/yum.repos.d/localrepo.repo \
 && echo "enabled=1" >> /etc/yum.repos.d/localrepo.repo \
 && createrepo -v /srv/eyesofreport/depot/

RUN rpm --rebuilddb
RUN yum install -y --disablerepo="*" --enablerepo="localrepo" nano openssh-server rsync \
 && groupadd eor && useradd -p eyesofreport -g eor eyesofreport \
 && /usr/bin/ssh-keygen -A \
 && mkdir /home/eyesofreport/.ssh \
 && chmod 700 /home/eyesofreport/.ssh \
 && touch /home/eyesofreport/.ssh/authorized_keys && echo 'public_key' >> /home/eyesofreport/.ssh/authorized_keys \
 && chmod 600 /home/eyesofreport/.ssh/authorized_keys \
 && chown -R eyesofreport:eor /home/eyesofreport \
 && mkdir /var/run/sshd

RUN sed -i 's/#Port 22/Port ssh_port/g' /etc/ssh/sshd_config \
 && sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config \
 && echo "AllowUsers eyesofreport" >> /etc/ssh/sshd_config

EXPOSE ssh_port
CMD chown -R eyesofreport:eor /home/eyesofreport && /usr/sbin/sshd -D
