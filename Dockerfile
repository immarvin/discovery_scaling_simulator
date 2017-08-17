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

RUN yum makecache fast; \
    yum install -y openssh-server gawk scp rsyslog rpcbind initscripts; \
    echo root:cluster|chpasswd; \
    sshd-keygen -t rsa; \
    chmod +x /bin/startservice.sh; \
    chmod +x /bin/minixcatd.awk; \
    chmod +x /bin/udpcat.awk; \
    chmod +x /bin/dodiscovery; \
    chmod +x /bin/doxcat 


            

ENTRYPOINT ["/bin/startservice.sh"]
