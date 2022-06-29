#!/usr/bin/env sh
# git clone https://github.com/moodle/moodle.git
git clone git://git.moodle.org/moodle.git
INSTALL_DIR = $PWD

sudo apt-get install apache2
cd moodle
git branch -r
echo "Select version"
read VERSION
git checkout MOODLE_${VERSION}_STABLE

mkdir $INSTALL_DIR/moodledata
chmod 0777 $INSTALL_DIR/moodledata


sudo apt-get install postgress
echo "database name"
read DB_NAME
echo "database username"
read DB_USERNAME
echo "database password"
read DB_PASSWORD

psql -U postgres -c "CREATE USER $DB_USERNAME WITH PASSWORD '${DB_PASSWORD}'";
psql -U postgres -c "CREATE DATABASE ${DB_NAME} WITH OWNER ${DB_USERNAME};"


chown www-data $INSTALL_DIR/moodle
cd  $INSTALL_DIR/moodle/admin/cli
sudo -u www-data /usr/bin/php install.php


chown -R root $INSTALL_DIR/moodle
chmod -R 0755 $INSTALL_DIR/moodle
 
