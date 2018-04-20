#!/bin/bash
set -x
. awips2.sh
export USER=$(whoami)
export SWT_GTK3=0
/awips2/cave/cave -os linux -ws gtk -arch x86_64 -data @user.home/caveData -user @user.home/caveData -consoleLog &
