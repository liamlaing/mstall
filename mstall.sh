#!/usr/bin/env sh

INSTALL_DIR=$PWD
echo "install folder, i.e, moodle "
read MOODLE_FOLDER
MOODLE_DATA_FOLDER=${MOODLE_FOLDER}data
apt-get update
apt-get install git -y
# git clone https://github.com/moodle/moodle.git
git clone git://git.moodle.org/moodle.git $MOODLE_FOLDER
cd $MOODLE_FOLDER


git branch -r
echo "Select version"
read VERSION
git checkout MOODLE_${VERSION}_STABLE

# plugins
git clone https://github.com/trampgeek/moodle-qbehaviour_adaptive_adapted_for_coderunner.git ${INSTALL_DIR}/${MOODLE_FOLDER}/question/behaviour/adaptive_adapted_for_coderunner

git clone https://github.com/trampgeek/moodle-qtype_coderunner.git ${INSTALL_DIR}/${MOODLE_FOLDER}/question/type/coderunner

git clone https://github.com/trampgeek/moodle-filter_ace_inline.git ${INSTALL_DIR}/${MOODLE_FOLDER}/filter/ace_inline


mkdir $INSTALL_DIR/$MOODLE_DATA_FOLDER
chmod 0777 $INSTALL_DIR/$MOODLE_DATA_FOLDER

apt-get install apache2 -y

echo "php version "
read PHP_VERSION
apt-get install ${PHP_VERSION} -y
apt-get install ${PHP_VERSION}-mbstring -y
apt-get install ${PHP_VERSION}-curl -y
apt-get install ${PHP_VERSION}-xmlrpc -y
apt-get install ${PHP_VERSION}-soap -y
apt-get install ${PHP_VERSION}-zip -y
apt-get install ${PHP_VERSION}-gd -y
apt-get install ${PHP_VERSION}-xml -y
apt-get install ${PHP_VERSION}-intl -y
apt-get install ${PHP_VERSION}-json -y
apt-get install ${PHP_VERSION}-pgsql -y

apt-get install ghostscript -y
apt-get install aspell -y
apt-get install graphviz -y


sudo apt-get install postgresql -y
echo "database name"
read DB_NAME
echo "database username"
read DB_USERNAME
echo "database password"
read DB_PASSWORD

psql -U postgres -c "CREATE USER $DB_USERNAME WITH PASSWORD '${DB_PASSWORD}'";
psql -U postgres -c "CREATE DATABASE ${DB_NAME} WITH OWNER ${DB_USERNAME}"

cd $INSTALL_DIR/${MOODLE_FOLDER}/admin/cli

chown -R root $INSTALL_DIR/${MOODLE_FOLDER}
chmod -R 0755 $INSTALL_DIR/${MOODLE_FOLDER}

# quick teardown
# not including repo installs
TEARDOWN_FILE="${INSTALL_DIR}/un.mstall.${MOODLE_FOLDER}.sh"
echo '#!/usr/bin/env sh' >> $TEARDOWN_FILE
echo "rm -r ${INSTALL_DIR}/${MOODLE_FOLDER}" >> $TEARDOWN_FILE
echo "rm -r ${INSTALL_DIR}/${MOODLE_DATA_FOLDER}" >> $TEARDOWN_FILE
echo psql -U postgres -c "'DROP DATABASE ${DB_NAME}'" >> $TEARDOWN_FILE
echo  psql -U postgres -c "'DROP USER $DB_USERNAME '" >> $TEARDOWN_FILE
chmod +x $TEARDOWN_FILE
