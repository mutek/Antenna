#!/usr/bin/env sh
#
# mutek (2014)
# 
# <mutek@riseup.net>
#
# Indicizza in base al contenuto di incoming
#
#

REPO=Antenna

mkdir -p PDF EPUB MOBI Covers
wait

. ./genThumb.sh
wait

mv incoming/*.png Covers/
wait

mv incoming/*.pdf PDF/
wait

mv incoming/*.epub EPUB/
wait

mv incoming/*.mobi MOBI/
wait

mv model/body.html model/body.html.old
wait

for file in $(ls PDF | cut -d"." -f 1 | sort -r)
do

echo $file

echo "<li><a href=\"http://mutek.github.io/"$REPO"/PDF/"$file".pdf\"><img src=\"http://mutek.github.io/"$REPO"/Covers/"$file".pdf.png\" style=\"max-width: 314px;\" alt=\""$REPO" numero "$file"\"></a><div><a href=\"http://mutek.github.io/"$REPO"/MOBI/"$file.mobi"\">MOBI</a>    |    <a href=\"http://mutek.github.io/"$REPO"/EPUB/"$file.epub"\">EPUB</a></div>"$file"</li>" >> model/body.html
wait

done

# header
cat model/header.html > index.html
wait

#body
cat model/body.html >> index.html
wait

# footer
cat model/footer.html >> index.html
