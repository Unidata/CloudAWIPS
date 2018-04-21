
# CloudStream AWIPS <IMG SRC="https://travis-ci.org/mjames-upc/CloudAWIPS.svg?branch=master"/>

This docker image contains an instance of Unidata AWIPS CAVE running in a virtual X11 environment, accessed via a web browser.   

#### Build AWIPS CAVE Docker image

    git clone https://github.com/Unidata/CloudAWIPS.git
    cd CloudAWIPS
    make build

#### Run AWIPS CAVE

From the command line, run

    docker pull unidata/cloudstream:centos7
    docker run -p 6080:6080 -it unidata/cloudawips

and then open [http://localhost:6080](http://localhost:6080)

![](https://www.unidata.ucar.edu/software/awips2/images/CloudAWIPS.jpg)

### Notes

* This repository uses a modified `bootstrap.sh` which overrides the `unidata/cloudstream:centos7` file of the same name.
* AWIPS CAVE is the only application accessible through this app streaming environment, and is run full-screen, with no window decorations or titlebar.
* If you wish to run multiple sessions, or leverage dynamic port mapping, you would start CloudAWIPS as follows:

      docker run -P -it unidata/cloudawips

* By default, CloudAWIPS does not use a password. You may secure your CloudAWIPS session with a password by using the `USEPASS` environmental variable to set a password for the session.  

      docker run -e USEPASS="password" -P -it unidata/cloudawips

