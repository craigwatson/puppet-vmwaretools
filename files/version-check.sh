#!/bin/bash

function usage() {
  echo -e "
Usage: $0 [ version ]
Example: $0 \"8.6.5-621624\""
}

if [ $# -ne 1 ]; then
  usage
elif [ ! -x /usr/bin/vmware-toolbox-cmd ]; then
  echo "FAIL: vmware-toolbox-cmd does not exist - Tools not installed."
  exit 1
else
  CURRENT_STRING=$(/usr/bin/vmware-toolbox-cmd -v)
  CURRENT_VERSION=${CURRENT_STRING% (build-*}
  CURRENT_VERSION=${CURRENT_VERSION%.*}
  CURRENT_BUILD=${CURRENT_STRING#*-}
  CURRENT_BUILD=${CURRENT_BUILD%?}
  ARG_VERSION=${1%-*}
  ARG_BUILD=${1#*-}

  if [ ${CURRENT_VERSION} == ${ARG_VERSION} -a ${CURRENT_BUILD} == ${ARG_BUILD} ]; then
    echo "OK: Versions match"
    exit 0
  else
    echo "FAIL: Versions do NOT match"
    exit 1
  fi

fi
