FROM centos:7.4.1708

MAINTAINER lvhfa <lvhfa@yonyou.com>

ENV OPENOFFICEVERSION 4.1.4
ENV OPENOFFICEPACKAGE Apache_OpenOffice_4.1.4_Linux_x86-64_install-rpm_zh-CN.tar.gz

RUN yum install -y wget \
       java-1.8.0-openjdk \
       java-1.8.0-openjdk-devel

ENV JAVA_HOME /etc/alternatives/jre


RUN wget https://ops.yonyouccs.com/resources/openoffice/$OPENOFFICEVERSION/$OPENOFFICEPACKAGE -P /tmp/; \
    mkdir /tmp/OpenOffice; \
    tar -xzf /tmp/$OPENOFFICEPACKAGE -C /tmp/OpenOffice; \
    cd /tmp/OpenOffice/zh-CN/RPMS; \
    rpm -ivh *.rpm; \
    rm -rf /tmp/OpenOffice

RUN wget https://ops.yonyouccs.com/resources/windowsfornts/windows.tar.gz -P /tmp/; \
    tar -xzf /tmp/windows.tar.gz -C /usr/share/fonts; \
    rm -rf /tmp/windows.tar.gz

COPY start-openoffice.sh /tmp/

ENTRYPOINT ["/tmp/start-openoffice.sh"]
