#!/bin/sh
# simple GHDL wrapper script
##########################################################################
# use: $ bash ghdlRun.sh AppTb (look at main at the end of script)
##########################################################################
##########################################################################

ROOT_DIR=${PWD}/../../
FIRMWARE_DIR=${ROOT_DIR}/firmware

GHDL_DIR=${GHDL_DIR}/ghdl

SHARED_DIR=${FIRMWARE_DIR}/shared
SHARED_RTL_DIR=${SHARED_DIR}/rtl
SHARED_TB_DIR=${SHARED_DIR}/tb

SHARED_PKG_DIR=${SHARED_RTL_DIR}/pkg

SURF_DIR=${SHARED_RTL_DIR}/surf


SHARED_VHD=${SHARED_RTL_DIR}/*.vhd
SHARED_PKG_VHD=${SHARED_PKG_DIR}/*.vhd
SHARED_TB_VHD=${SHARED_TB_DIR}/*.vhd
SURF_VHD=${SURF_DIR}/*.vhd

# note that the packages have to be declared separately in order to be imported first
# the order of the packages *matter*.
SURF_PKG_DIR=${SURF_DIR}/pkg
SURF_PKG=("${SURF_PKG_DIR}/StdRtlPkg.vhd"
          "${SURF_PKG_DIR}/TextUtilPkg.vhd")


#############################
# can be changed to some other ghdl variant
GHDL_CMD="ghdl-llvm"
#############################
GHDL_GLBL_FLAGS="--ieee=standard -fexplicit -fsynopsys"
GHDL_STD_FLAG="--std=93c"

GHDL_ANALYZE="${GHDL_CMD} -s ${GHDL_GLBL_FLAGS} ${GHDL_STD_FLAG}"
GHDL_IMPORT_SURF="${GHDL_CMD} -i ${GHDL_GLBL_FLAGS} --work=surf"
GHDL_IMPORT_WORK="${GHDL_CMD} -i ${GHDL_GLBL_FLAGS} --work=work"
GHDL_MAKE="${GHDL_CMD} -m  -g -Psurf -Papp --warn-unused ${GHDL_GLBL_FLAGS}"
GHDL_RUN="${GHDL_CMD} --elab-run ${GHDL_GLBL_FLAGS}"

DEFAULT_STOP_TIME_US="10"

##########################################################################

checkFileExists()
{
  retVal=0
  if compgen -G $1 > /dev/null; then
    retVal=1
  fi
  return $retVal
}

##########################################################################
ghdlAnalyze()
{
  # analyze the files to make sure their syntax is correct
  echo "List of Files:"
  echo "$(ls ${SHARED_VHD})"
  echo "$(ls ${SHARED_PKG_VHD})"
  echo "$(ls ${SHARED_TB_VHD})"

  checkFileExists ${SURF_VHD}
  surf_exists=$?

  # surf import
  if [[ $surf_exists -eq 1 ]]; then
    echo "[INFO]: Surf libraries found in ${SURF_DIR}. Importing following files..."
    echo "${SURF_VHD}"
    for package in "${SURF_PKG[@]}"
    do
      ${GHDL_IMPORT_SURF} $package
    done
    ${GHDL_IMPORT_SURF} ${SURF_VHD}
  else
    echo "[ERROR]: No surf files found...have you run 'make' under firmware/ ?"
    exit 1
  fi

  echo "[INFO]: Importing RTL Files..."
  ${GHDL_IMPORT_WORK} ${SHARED_PKG_VHD}
  ${GHDL_IMPORT_WORK} ${SHARED_VHD}
  ${GHDL_IMPORT_WORK} ${SHARED_TB_VHD}

  echo "[INFO]: Analyzing RTL Files..."
  ${GHDL_ANALYZE} ${SHARED_PKG_VHD}
  ${GHDL_ANALYZE} ${SHARED_VHD}
  ${GHDL_ANALYZE} ${SHARED_TB_VHD}
  echo "[INFO]: Success!"
}
##########################################################################

##########################################################################
ghdlTestbench()
{
  tbFilePath="${SHARED_TB_DIR}/${1}.vhd"
  tbFileName="${1}.vhd"
  checkFileExists ${tbFilePath}
  tbExists=$?

  if [[ $tbExists -eq 1 ]]; then
    echo "Assuming testbench entity name: ${1}"
    echo "Assuming testbench file name: ${1}.vhd"
    ${GHDL_IMPORT_WORK} ${tbFilePath}

    # compile an executable to-be-run.
    # the argument name has to be the SAME as the entity name of the testbench at the top-level of your testbench file
    ${GHDL_MAKE} $1

    if [[ -z "$2" ]]; then
      echo "Default stopping time of ${DEFAULT_STOP_TIME_US}us not overriden by user."
      stopTime=$DEFAULT_STOP_TIME_US
    else
      stopTime=$2
    fi

    echo "Will run for ${stopTime}us."

    gtkwFile=""
    checkFileExists "${1}.gtkw"
    gtkwExists=$?
    if [[ $tbExists -eq 1 ]]; then
      echo "GTKW file exists. Will load."
      gtkwFile="${1}.gtkw"
    fi

    # note the use of .ghw. We like .ghw. .ghw is good; it supports records on the waveform!
    ${GHDL_RUN} $1 --wave=$1.ghw --stop-time="${stopTime}us"

    gtkwave $1.ghw ${gtkwFile}

  else
    echo "[ERROR]: ${tbFilePath} not found! Is it under the tb/ directory as it is supposed to?"
    exit 1
  fi

}
##########################################################################

##########################################################################

main()
{
  noTb=1
  if [[ -z "$1" ]]; then
    echo "[INFO]: No arguments are given!"
    echo "[INFO]: Will only run analysis on files under ${SHARED_DIR}"
  else
    noTb=0
  fi

  checkFileExists "${SHARED_VHD}"
  rtlExists=$?
  if [[ $rtlExists -eq 0 ]]; then
    echo "[ERROR]: There are no .vhd files in shared/rtl/."
    echo "[ERROR]: Are you in the right directory? You need to run this from the ghdl/ dir."
    exit 1
  fi

  echo "[INFO]: Please make sure that you have run make clean && make under firmware/ to generate the surf library links!"

  ghdlAnalyze

  if [[ $noTb == 0 ]]; then
    ghdlTestbench "$1" "$2"
  fi

}

main "$@"
