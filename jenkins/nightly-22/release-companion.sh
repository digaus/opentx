#!/bin/bash

# stops on first error
set -e
set -x

# make sure we are in the good directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

# pull the latest changes
./update-repo.sh

source ./version.sh

DESTDIR=/var/www/html/downloads-${version}/nightly/companion

# create companion rpm
cd $DIR/companion-build/
cmake ../opentx/companion/src
make package
cp ./companion${version}-${release}${OPENTX_VERSION_SUFFIX}-i686.rpm ${DESTDIR}

make stamp
chmod -Rf g+w . || true

# request companion compilation on Windows
cd ${DESTDIR}
wget -qO- http://winbox.open-tx.org/companion-builds/compile.php?branch=${branch}\&suffix=${OPENTX_VERSION_SUFFIX}
wget -O companion-windows-${release}${OPENTX_VERSION_SUFFIX}.exe http://winbox.open-tx.org/companion-builds/companion-windows-${release}${OPENTX_VERSION_SUFFIX}.exe
mv $DIR/opentx/companion/companion.stamp ./companion-windows.stamp

chmod -Rf g+w . || true

