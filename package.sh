#!/usr/bin/env bash

BASEDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

# resolve symlinks
while [ -h "$BASEDIR/$0" ]; do
    DIR=$(dirname -- "$BASEDIR/$0")
    SYM=$(readlink $BASEDIR/$0)
    BASEDIR=$(cd $DIR && cd $(dirname -- "$SYM") && pwd)
done
cd ${BASEDIR}

if [ -z ${1} ] || [ -z ${2} ]; then
  echo "Usage: ${0} <env> <version>"
  exit 1
fi

app=cake-redux
env=${1}
version=${2}

echo "> Assembling files"

cp ~/.m2/repository/no/javazone/${app}/${version}/${app}-${version}-jar-with-dependencies.jar ./app.jar

echo "> Packaging app"
zip -r app.zip app.jar application-${env}.properties Procfile

if [ $? -ne 0 ]; then
  rm -f app.jar
  echo "> Package failed!"
  exit 1
fi
# rm -f app.jar
echo "> Done packaging app"
