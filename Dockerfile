#####
# Copyright Unidata 2018
# Used to generate the 'unidata/cloudawips' docker container.
# Visit us on the web at https://www.unidata.ucar.edu
#####

FROM unidata/cloudstream:centos7
MAINTAINER Michael James <mjames@ucar.edu>

###
# Install latest EL7 development release of AWIPS CAVE 
###

USER root
RUN wget -O /etc/yum.repos.d/awips2.repo https://www.unidata.ucar.edu/software/awips2/doc/el7-dev.repo
RUN yum -y clean all
RUN groupadd fxalpha && useradd -G fxalpha awips
RUN yum groupinstall awips2-cave -y
RUN yum groupinstall "Fonts" -y
RUN yum install -y gtk2 mesa-libGLU mesa-libGL mesa-dri-drivers
USER ${CUSER}

###
# Application files and localization preferences to auto-connect to edex-cloud, and open windows at full width
###

COPY localization.prefs ${HOME}/caveData/.metadata/.plugins/org.eclipse.core.runtime/.settings/
COPY workbench.xmi ${HOME}/caveData/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi
COPY bootstrap.sh ${HOME}/
COPY start.sh ${HOME}/
COPY Dockerfile ${HOME}/
COPY README.md ${HOME}/
COPY COPYRIGHT.md ${HOME}/
ENV COPYRIGHT_FILE COPYRIGHT.md
ENV README_FILE README.md

###
# Add the version number to the version file
###

RUN echo "CloudAWIPS Version: $(rpm -qa |grep awips2-cave-wrapper | cut -d "-" -f 4,5) $(date)" >> $VERSION_FILE

###
# Environmental variable control
###

USER root
RUN rm -rf /etc/profile.d/awips2.csh
RUN mv /etc/profile.d/awips2.sh ${HOME}
RUN chown -R ${CUSER}:${CUSER} ${HOME}

###
# Manual cleanup
###

RUN rm -rf /awips2/cave/plugins/com.raytheon.uf.viz.archive*.jar
RUN rm -rf /awips2/cave/plugins/com.raytheon.uf.viz.useradmin*.jar

USER ${CUSER}

###
# Override default windows session geometry and color depth.
###
ENV SIZEW 1280
ENV SIZEH 768
ENV CDEPTH 24

# Fluxbox desktop environment
RUN echo "session.screen0.toolbar.visible: false" >> ~/.fluxbox/init
#RUN echo "session.screen0.defaultDeco: NONE" >> ~/.fluxbox/init
RUN echo "/usr/bin/fluxbox -log ~/.fluxbox/log" > ~/.fluxbox/startup
# Fluxbox menu
RUN echo "[begin] (fluxbox)" > ~/.fluxbox/menu
RUN echo "[exec] (AWIPS CAVE) {/awips2/cave/cave.sh} </awips2/cave/cave.png>" >> ~/.fluxbox/menu
RUN echo "[end] (fluxbox)" >> ~/.fluxbox/menu

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG IMAGE
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$IMAGE \
      org.label-schema.description="An image based on centos 7 containing AWIPS CAVE and an X_Window_System" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0"
