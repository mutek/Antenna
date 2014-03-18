#!/usr/bin/env sh
#
# fuck what you want to do
#
# 
# LJ con 36x produce 314x413 ... supersimmetria!!!
#

[ -z $(which convert) ] && echo "non trovo il tool: convert di ImageMagick nella PATH" && exit 1

CARTELLA=incoming
for file in $(ls $CARTELLA/*.pdf)
do

	echo "Elaboro: "$file
	
	convert -colorspace sRGB  -density 36x  $file[0] $file.png

done
