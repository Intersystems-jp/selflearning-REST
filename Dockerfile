# 2021/10/31 updated
ARG IMAGE=containers.intersystems.com/intersystems/iris-community:2021.1.0.215.3
FROM $IMAGE

USER root


RUN apt-get update
RUN apt-get -y install locales && \
   localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm


###########################################
#### Set up the irisowner account and load application
USER ${ISC_PACKAGE_MGRUSER}


ENV SRCDIR=src
COPY . $SRCDIR/

RUN  iris start $ISC_PACKAGE_INSTANCENAME \ 
 && printf 'Do ##class(Config.NLS.Locales).Install("jpuw") Do ##class(Security.Users).UnExpireUserPasswords("*") h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && printf 'Set tSC=$system.OBJ.Load("'$HOME/$SRCDIR'/ZFS/REST/Installer.cls","ck") Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && printf 'set tSC=##class(ZFS.REST.Installer).RunInstall("'$HOME/$SRCDIR'") Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly

ARG COMMIT_ID="unknown"
RUN echo $COMMIT_ID > $HOME/commit.txt