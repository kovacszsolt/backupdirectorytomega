#!/bin/bash
if [ "$#" -ne 4 ]; 
	then
	echo "Mega backup v1.0"
	echo "save directory to mega.co.nz with timestamp"
	echo ""
	echo "backupdirectorytomega.sh [source_directory] [target_prefix] [mega_username] [mega_password]"
	echo "[source_directory] = source directory (that will be saved) e.g. /var/www/site/ "
	echo "[target_prefix] = source_directory ID name name e.g. var_www_site "
	echo "[mega_username] = mega.con.nz username "
	echo "[mega_password] = mega.con.nz password "
	exit -1
fi
current_date=`date +"%Y_%m_%d_%H_%M_%S"`

#source_directory
source_directory=$1

#target_prefix
target_prefix=$2

#mega_username
mega_username=$3

#mega_password
mega_password=$4

#temporary filename
target_filename=/tmp/$target_prefix$current_date.tar.gz

#change current directory to source directory
cd $source_directory

#archive the source_directory into the temporary file
tar czf $target_filename .

#read compressed file size
size=$(stat --format %s $target_filename)

#read mega.co.nz free space
free=$(megadf -u $mega_username -p $mega_password --free )

if [ "$free" -ge "$size" ] 
	then
		#save file to mega.co.nz
		megaput --username=$mega_username --password=$mega_password  $target_filename
	else 
		echo "NOT ENOUGHT SPACE IN MEGA.CO.NZ"
		exit -1
	fi

#remove temporary file
rm $target_filename

