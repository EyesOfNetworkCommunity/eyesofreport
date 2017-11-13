# Eyes Of Report : Keep an eye on your application availability ! 

Eyes of report is an open source IT toolbox which provides all the facilities to analyse your application availability regarding service contract defined with users.

To compute application availability, Eyes Of Report centralizes all your equipement monitoring log (from one or several monitoring platform) in its own database. The solution is initially developed to be plugged on nagios based monitoring plateform like Eyes Of Network, Centreon, Shinken...
However connectors can be developed to plug other kind of monitoring solution.

Eyes Of Report can centralize logs and equipments from as much monitoring platform as you want !

Eyes Of report is composed of 4 main bricks :
* Data reception from heterogeneous monitoring solution (logs + equipments) through Docker containers
* ETL for monitoring data historization and consolidate application availability with Pentaho Data Integration community
* Reporting with several out of the box reports immediately available (application availability, outage analysis, COPIL reports...)
* Web interface to manage your contract, your business process, report access and availability computation

Data base management system used is Mariadb (Embedded in Eyes Of report installation)

<p align="center">
  <a href="https://raw.githubusercontent.com/eyesofreport/eyesofreport/master/SAMPLES/Reporting_2.PNG" target="_blank">
  <img src="https://github.com/eyesofreport/eyesofreport/blob/master/SAMPLES/Reporting_2.PNG" width="100" height="100"/>
  </a>
  <a href="https://raw.githubusercontent.com/eyesofreport/eyesofreport/master/SAMPLES/Threshold.PNG" target="_blank">
  <img src="https://github.com/eyesofreport/eyesofreport/blob/master/SAMPLES/Threshold.PNG" width="100" height="100"/>
  </a>
  <a href="https://raw.githubusercontent.com/eyesofreport/eyesofreport/master/SAMPLES/Time_Period.PNG" target="_blank">
  <img src="https://github.com/eyesofreport/eyesofreport/blob/master/SAMPLES/Time_Period.PNG" width="100" height="100"/>
  </a>
  <a href="https://raw.githubusercontent.com/eyesofreport/eyesofreport/master/SAMPLES/application_report.JPG" target="_blank">
  <img src="https://github.com/eyesofreport/eyesofreport/blob/master/SAMPLES/application_report.JPG" width="100" height="100"/>
  </a>
  <a href="https://raw.githubusercontent.com/eyesofreport/eyesofreport/master/SAMPLES/application_report_2.JPG" target="_blank">
  <img src="https://github.com/eyesofreport/eyesofreport/blob/master/SAMPLES/application_report_2.JPG" width="100" height="100"/>
  </a>
  <a href="https://raw.githubusercontent.com/eyesofreport/eyesofreport/master/SAMPLES/application_report_3.JPG" target="_blank">
  <img src="https://github.com/eyesofreport/eyesofreport/blob/master/SAMPLES/application_report_3.JPG" width="100" height="100"/>
  </a>
  <a href="https://raw.githubusercontent.com/eyesofreport/eyesofreport/master/SAMPLES/application_tree.png" target="_blank">
  <img src="https://github.com/eyesofreport/eyesofreport/blob/master/SAMPLES/application_tree.png" width="100" height="100"/>
  </a>
  <a href="https://raw.githubusercontent.com/eyesofreport/eyesofreport/master/SAMPLES/outage_analysis.JPG" target="_blank">
  <img src="https://github.com/eyesofreport/eyesofreport/blob/master/SAMPLES/outage_analysis.JPG" width="100" height="100"/>
  </a>
  <a href="https://raw.githubusercontent.com/eyesofreport/eyesofreport/master/SAMPLES/Outage_analysis_2.JPG" target="_blank">
  <img src="https://github.com/eyesofreport/eyesofreport/blob/master/SAMPLES/Outage_analysis_2.JPG" width="100" height="100"/>
  </a>
  <a href="https://raw.githubusercontent.com/eyesofreport/eyesofreport/master/SAMPLES/service_catalog.png" target="_blank">
  <img src="https://github.com/eyesofreport/eyesofreport/blob/master/SAMPLES/service_catalog.png" width="100" height="100"/>
  </a>
  <a href="https://raw.githubusercontent.com/eyesofreport/eyesofreport/master/SAMPLES/COPIL_Report.JPG" target="_blank">
  <img src="https://github.com/eyesofreport/eyesofreport/blob/master/SAMPLES/COPIL_Report.JPG" width="100" height="100"/>
  </a>
  <a href="https://raw.githubusercontent.com/eyesofreport/eyesofreport/master/SAMPLES/ETL_Detail_status_1.PNG" target="_blank">
  <img src="https://github.com/eyesofreport/eyesofreport/blob/master/SAMPLES/ETL_Detail_status_1.PNG" width="100" height="100"/>
  </a>
</p>

## Installation Prerequisites

**OS** : Centos 7 x64 7.1.1503. Download CentOS-7-x86_64-DVD-1503-01.iso at http://mirror.nsc.liu.se/centos-store/7.1.1503/isos/x86_64/CentOS-7-x86_64-Minimal-1503-01.iso
Eyes Of Report installation don't need internet for security reason, and use initial Centos 7 packet version for it's own packet dependencies. Be sure you didn't execute any "yum update" after Centos 7 installation.

**RAM**: 8GO (16GO recommanded)

**Disk**: 50GO (100GO SSD recommanded)

**Processor**: 2x4 cores (4x4 cores recommanded)

## Installation Steps :

1. Download external softwares used by Eyes of Report. Follow EXTERNAL_REPORTS/README.txt file.

1. Execute install_eyesofreport.sh and follow instructions

1. To plug a nagios based monitoring system, execute Eyes-Of-Report/SOURCES/build_nagios_source/create_nagios_source_env.sh

1. Go on **http://eor_server_ip/** with **admin/admin** login information

To understand how your logs and equipments are imported in Eyes of Report, refer to :
* Script executed from cron tab on your monitoring plaform (Script pushed on your monitoring platform during installation step 3)
* Script executed from cron tab on your eyes of report server
* ETL stored in pentaho data integration repository :

    1. Install data integration on your computer

    1. Add mysql driver in data-integration/lib (mysql-connector-java-5.1.35-bin.jar)

    1. Import Eyes Of Report jdbc.properties located in /srv/eyesofreport/data-integration/simple-jndi/ in your  local data-integration folder

    1. Change all localhost to your Eyes Of Report server ip in jdbc.properties

    1. Launch spoon tool and connect to your eyes of report data integration mysql repository : jndi **EOR_REPOSITORY**, login **admin/admin**

    1. Enjoy ;)
		
More detailed technical document will be available soon

Eyes Of Report team
