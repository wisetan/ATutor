#! /bin/csh -f
#########################################################################
# ATutor snap script                                                    #
# Author: Joel Kronenberg - ATRC, Oct 2003                              #
#########################################################################

set db_name = "dev_atutor_langs"
set db_user = "dev_atutor_langs"
set db_pass = "devlangs99"

if (-e "atutor_snap") then
	rm -r "atutor_snap"
endif

cvs -Q -d :pserver:greg@thor.snow.utoronto.ca:/repos export -D 2007-12-31 atutor
cd atutor

set now = `date +"%Y_%m_%d"`
set atutor_dir = "ATutor"
set bundle = "snap_${now}"
set time = `date +"%k_%M_%S"`
set extension = "snap_${time}"

./bundle.sh $bundle ignore

mv ATutor-$bundle.tar.gz /disk2/webserver/content/atutor.ca/docs/atutor/builds/

cd ..

rm -r atutor

exit
rm install/db/atutor_lang_base.sql
echo "DROP TABLE lang_base;" > install/db/atutor_lang_base.sql
mysqldump $db_name lang_base -u $db_user --password=$db_pass --allow-keywords --quote-names --quick >> install/db/atutor_lang_base.sql

echo -n "<?php /* This file is a placeholder. Do not delete. Use the automated installer. */ ?>" > include/config.inc.php

rm include/cvs_development.inc.php

sed "s/define('AT_DEVEL', 1);/define('AT_DEVEL', 0);/" include/vitals.inc.php > vitals.inc.php
mv vitals.inc.php include/

rm -r content/

mkdir content
touch content/index.html

mkdir content/import
touch content/import/index.html

mkdir content/chat
touch content/chat/index.html

cd ../

tar -zcf $bundle ATutor/
mv $bundle ..

cd ..
rm -r atutor

mv $bundle /disk2/webserver/content/atutor.ca/docs/atutor/builds

exit 1