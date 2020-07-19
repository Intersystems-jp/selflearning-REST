#イメージのタグはこちら（https://hub.docker.com/_/intersystems-iris-data-platform）でご確認ください
ARG IMAGE=store/intersystems/iris-community:2020.1.0.215.0
ARG IMAGE=store/intersystems/iris-community:2020.2.0.211.0
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
USER irisowner


ENV SRCDIR=src
COPY . $SRCDIR/

RUN  iris start $ISC_PACKAGE_INSTANCENAME \ 
 && printf 'Do ##class(Config.NLS.Locales).Install("jpuw") Do ##class(Security.Users).UnExpireUserPasswords("*") h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && printf 'Set tSC=$system.OBJ.Load("'$HOME/$SRCDIR'/ZFS/REST/Installer.cls","ck") Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && printf 'set tSC=##class(ZFS.REST.Installer).RunInstall("'$HOME/$SRCDIR'") Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly

# clean up
RUN iris start $ISC_PACKAGE_INSTANCENAME nostu quietly \
 && printf "kill ^%%SYS(\"JOURNAL\") kill ^SYS(\"NODE\") h\n" | iris session $ISC_PACKAGE_INSTANCENAME -B | cat \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly bypass \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/iris.ids \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal/* \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/messages.log

ARG COMMIT_ID="unknown"
RUN echo $COMMIT_ID > $HOME/commit.txt