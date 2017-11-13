FROM centos_systemd
MAINTAINER Benoit Village <benoit.village@apx.fr>

ADD /Install_Files.tar /tmp/
RUN cd /tmp \
 && rpm -ivh /tmp/createrepo/deltarpm-3.6-3.el7.x86_64.rpm \
 && rpm -ivh /tmp/createrepo/libxml2-python-2.9.1-5.el7_1.2.x86_64.rpm \
 && rpm -ivh /tmp/createrepo/python-deltarpm-3.6-3.el7.x86_64.rpm \
 && rpm -ivh /tmp/createrepo/createrepo-0.9.9-23.el7.noarch.rpm

RUN mkdir -p /srv/eyesofreport/depot-1.0 \
 && ln -s /srv/eyesofreport/depot-1.0 /srv/eyesofreport/depot \
 && cp /tmp/rpm/* /srv/eyesofreport/depot

RUN echo "[localrepo]" >> /etc/yum.repos.d/localrepo.repo \
 && echo "name=Eyesofreport repository" >> /etc/yum.repos.d/localrepo.repo \
 && echo "baseurl=file:///srv/eyesofreport/depot" >> /etc/yum.repos.d/localrepo.repo \
 && echo "gpgcheck=0" >> /etc/yum.repos.d/localrepo.repo \
 && echo "enabled=1" >> /etc/yum.repos.d/localrepo.repo \
 && createrepo -v /srv/eyesofreport/depot/

RUN yum install -y --disablerepo="*" --enablerepo="localrepo" unzip nano perl patch httpd libXpm gd crontabs mariadb perl-DBD-MySQL.x86_64

RUN groupadd eyesofnetwork && useradd -p root66 -g eyesofnetwork nagios && gpasswd -a nagios root \
 && rpm -ivh --nodeps /tmp/mk-livestatus-1.2.6p12-0.eon.x86_64.rpm \
 && rpm -ivh --nodeps /tmp/nagios-devel-3.5.1-0.eon.x86_64.rpm \
 && rpm -ivh --nodeps /tmp/nagios-3.5.1-0.eon.x86_64.rpm \
 && ln -s /srv/eyesofnetwork/nagios-3.5.1 /srv/eyesofnetwork/nagios \
 && /srv/eyesofnetworkconf/nagios/nagiosconf.sh \
 && mv /etc/httpd/conf.d/nagios.conf /root/nagios.orig

RUN rpm -ivh /tmp/mod_fcgid-2.3.9-0.eon.x86_64.rpm \
 && mv /etc/httpd/conf.d/fcgid.conf /root/fcgid.conf.orig \
 && rpm -ivh --nodeps /tmp/thruk-2.01-4.eon.x86_64.rpm \
 && sed -i 's/#logcache=mysql:\/\/hostname:port\/thruk_log_cache/logcache=mysql:\/\/eyesofreport:SaintThomas,2014@localhost:3306\/thruk/g' /srv/eyesofnetwork/thruk/thruk_local.conf \
 && sed -i 's/        name   = EyesOfNetwork/        name   = EyesOfNetwork \n        id   = livestatus_code/g' /srv/eyesofnetwork/thruk/thruk_local.conf

RUN cd /srv/eyesofnetwork/thruk \
 && patch -p0 < /tmp/Thruk_mode_sql.patch \
 && chmod +x /tmp/thruk_first_insert.sh \
 && mkdir -p /srv/eyesofreport/scripts \
 && mkdir /srv/eyesofreport/external_depot \
 && mkdir -p /srv/eyesofreport/source/source_eon/Archives/ \
 && systemctl enable crond

CMD /usr/lib/systemd/systemd --system