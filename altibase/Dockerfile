#####################################
# telegraf docker file
#
# 07/20/2018 
# swhors@coupang.com
#

#####################################
# os image
FROM ubuntu:16.04

#####################################
# install basic development tools 
RUN apt-get -qq update \
    && apt-get -qq install -y g++ cmake autoconf curl git gawk vim texlive help2man\
    wget php python perl libncurses5-dev libssl-dev locales libtool texinfo\
    binutils-dev ddd tkdiff libldap2-dev manpages-dev autopoint gettext \
    && apt-get clean
RUN apt install -y software-properties-common g++-multilib rpm build-essential vsftpd

#####################################
# git no check ssl
ENV GIT_SSL_NO_VERIFY 0

#####################################
# patch sysctl
ADD sysctl_patch.sh /root/
RUN sh /root/sysctl_patch.sh;rm /root/sysctl_patch.sh

#####################################
# patch sysctl
ADD select.patch /root/
RUN ls /root
ENV SELECT_H_PATH=/usr/include/x86_64-linux-gnu/sys
RUN cd $SELECT_H_PATH; patch -p1 < /root/select.patch; rm /root/select.patch

#####################################
# install re2c
RUN mkdir -p /root/Download;cd /root/Download;wget http://archive.ubuntu.com/ubuntu/pool/main/r/re2c/re2c_0.13.5.orig.tar.gz;tar xvzf re2c_0.13.5.orig.tar.gz
RUN cd /root/Download/re2c-0.13.5;./configure --prefix=/usr/local/;make;make install;rm -fR ~/Download/re2c-0.13.5;rm -fR re2c_0.13.5.orig.tar.gz
ENV PATH /usr/local/bin:$PATH

#####################################
# install bison
RUN mkdir -p ~/Download;cd ~/Download;wget https://ftp.gnu.org/gnu/bison/bison-2.7.tar.gz;tar xvzf bison-2.7.tar.gz
RUN cd ~/Download/bison-2.7;./configure --prefix=/usr/local/;make;make install
ENV PATH /usr/local/share/bison-2.7/bin:$PATH
ENV LDLIBRARY_PATH /usr/local/share/bison-2.7/lib:$LD_LIBRARY_PATH

#####################################
# install flex 
RUN cd ~/Download;wget https://sourceforge.net/projects/flex/files/flex-2.5.37.tar.gz/download
RUN cd ~/Download;mv download flex-2.5.37.tar.gz;tar xvxf flex-2.5.37.tar.gz;cd ~/Download/flex-2.5.37;./autogen.sh;./configure --prefix=/usr/local/;make;make install
ENV LDLIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

#####################################
# install java 1.7 environment tools 
RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get -qq update && apt-get -y install openjdk-7-jdk 
ENV ADAPTER_JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64

#####################################
# install java 1.5 environment tools 
ADD jdk-1_5_0_22-linux-amd64.bin /root/Download/jdk-1_5_0_22-linux-amd64.bin
RUN chmod 755 /root/Download/jdk-1_5_0_22-linux-amd64.bin
RUN (echo yes) | sh /root/Download/jdk-1_5_0_22-linux-amd64.bin
ENV JAVA_HOME /usr/share/java/jdk1.5.0_22
RUN mv /jdk1.5.0_22 /usr/share/java
ENV PATH $PATH:$JAVA_HOME/bin

#####################################
# set go environments
ENV ALTIDEV_HOME	/root/work/altibase
ENV ALTIBASE_DEV	/root/work/altibase
ENV ALTIBASE_HOME	/root/work/altibase/altibase_home
ENV ALTIBASE_NLS_USE	US7ASCII
ENV ALTIBASE_PORT_NO	20300
ENV CLASSPATH		.:${JAVA_HOME}/lib:${JAVA_HOME}/jre/lib:${ALTIBASE_HOME}/lib/Altibase.jar:$CLASSPATH
#ENV LD_LIBRARY_PATH	$ADAPTER_JAVA_HOME/jre/lib/amd64/server:${ALTIBASE_HOME}/lib:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH	$ALTIBASE_HOME/lib:$LD_LIBRARY_PATH

RUN echo "alias godev='cd $ALTIBASE_DEV'" >> /root/.bashrc
ENV PATH		$JAVA_HOME/bin:$ALTIBASE_HOME/bin:$PATH
ENV LANG                ko_KR.EUC-KR

#####################################
# clean installing files.
RUN rm -fR ~/Download/flex* ~/Download/bison* ~/Download/jdk*

#####################################
# get source code
RUN mkdir -p /root/work;
RUN cd /root/work;git clone https://github.com/ALTIBASE/altibase.git
RUN locale-gen ko_KR.EUC-KR
RUN cd $ALTIBASE_DEV;./configure
#RUN cd $ALTIBASE_DEV;make build -j2
RUN cd $ALTIBASE_DEV;make build 


#####################################
# create altibase.properties
VOLUME     ["/Volume/disk1"]
ENV  ALTIDATAHOME /Volume/disk1/altibase
ENV  TRCHOME      $ALTIDATAHOME/trc
ENV  DISKDBHOME   $ALTIDATAHOME/dbs
ENV  MEMDBHOME    $ALTIDATAHOME/dbs
ENV  LOGSHOME     $ALTIDATAHOME/logs
ENV  ARCHIVE_DIR  $ALTIDATAHOME/arch_logs
COPY patch_property.sh $ALTIBASE_HOME/conf/
RUN  mkdir -p $ALTIDATAHOME;mkdir -p $TRCHOME;mkdir -p $DISKDBHOME
RUN  mkdir -p $LOGSHOME;mkdir -p $ARCHIVE_DIR;mkdir -p $MEMDBHOME
RUN  cd $ALTIBASE_HOME/conf;sh patch_property.sh;rm patch_property.sh

#####################################
# create database
#RUN server create MS949 UTF8
COPY entrypoint.sh /entrypoint.sh

#RUN service vsftpd start

EXPOSE     20300

#ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["sh", "/entrypoint.sh"]
#ENTRYPOINT ["/entrypoint.sh"]
#ENTRYPOINT ["/root/work/altibase/altibase_home/bin/server","start"]
#CMD ["server","start",";","/bin/bash"]
#CMD ["server","start"]
