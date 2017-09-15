baseDir= #rootPath

SUBDIR=$1

# add '/' if '/' is not exist
slash() {
  if [ ${SUBDIR:0:1} != '/' ]; then
    SUBDIR="/${SUBDIR}"
    echo "$SUBDIR"
  fi
}

echo "${SUBDIR}"
if [ $SUBDIR != "" ]; then
  slash
  cd ${baseDir}${SUBDIR}
else
  cd ${baseDir}
fi

#print list
ls -la
