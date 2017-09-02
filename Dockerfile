FROM centos:7

MAINTAINER yangsbj@cn.ibm.com

#ENV xcatcoreurl "http://xcat.org/files/xcat/repos/apt/devel/core-snap trusty main"
#ENV xcatdepurl  "http://xcat.org/files/xcat/repos/apt/xcat-dep trusty main"

#VOLUME ["/install","/var/log/xcat/"]
COPY startservice.sh /bin/startservice.sh 
COPY /xcat/minixcatd.awk /bin/minixcatd.awk
COPY /xcat/udpcat.awk /bin/udpcat.awk
COPY /xcat/dodiscovery /bin/dodiscovery
COPY /xcat/doxcat /bin/doxcat
COPY /xcat/getcert /bin/getcert
COPY /xcat/getdestiny /bin/getdestiny
COPY /xcat/allowcred.awk /bin/allowcred.awk
COPY /xcat/restart /bin/restart
COPY /xcat/ntp-wait /bin/ntp-wait

RUN yum makecache fast; \
    yum install -y lldpad openssh-server gawk scp rsyslog rpcbind initscripts openssl openssh-clients ntp dhclient; \
    echo root:cluster|chpasswd; \
    sshd-keygen -t rsa; \
    chmod +x /bin/startservice.sh; \
    chmod +x /bin/minixcatd.awk; \
    chmod +x /bin/udpcat.awk; \
    chmod +x /bin/dodiscovery; \
    chmod +x /bin/getcert; \
    chmod +x /bin/getdestiny; \
    chmod +x /bin/allowcred.awk; \
    chmod +x /bin/doxcat; \
    chmod +x /bin/ntp-wait 


            

ENTRYPOINT ["/bin/startservice.sh"]
#ENTRYPOINT ["/bin/bash"]
