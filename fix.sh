#!/bin/bash

wget http://www.grokpodcast.com/atom.xml -q

MAX=$(cat atom.xml| grep '<item>' -c)

FILE_PREFIX="http://media.grokpodcast.com/"

for i in `seq 1 $MAX`
do
    TITLE=$(eval "xmllint --xpath 'string(//channel/item[$i]/title)' atom.xml")
    echo "TITLE = $TITLE"

    DATE=$(eval "xmllint --xpath 'string(//channel/item[$i]/pubDate)' atom.xml")
    echo "DATE = $DATE"
    DATE=$(date -d "$DATE" +%Y-%m-%d)
    echo "DATE = $DATE"

    IMG_URL=$(eval "xmllint --xpath \"string(//channel/item[$i]/*[local-name()='image']/@href)\" atom.xml")
    echo "IMG_URL = $IMG_URL"
    IMG_PATH="media/$(basename "$IMG_URL")"
    wget $IMG_URL --continue -q -P media/ -O $IMG_PATH

    URL=$(eval "xmllint --xpath 'string(//channel/item[$i]/enclosure/@url)' atom.xml")
    echo "URL = $URL"
    wget $URL --continue -q -P media/

    FILE=$(eval "xmllint --xpath 'string(//channel/item[$i]/guid)' atom.xml")
    FILE=${FILE#$FILE_PREFIX}
    echo "FILE = $FILE"

    FILE_PATH="media/$FILE"
    echo "FILE_PATH = $FILE_PATH"

    mid3v2 --convert --verbose "$FILE_PATH"
    mid3v2 --artist="Grok Podcast" \
        --album="Grok Podcast" \
        --song="$TITLE" \
        --genre="Podcast" \
        --track="" \
        --picture="$IMG_PATH" \
        --date="$DATE" \
        --verbose \
        "$FILE_PATH"
    mid3iconv --debug "$FILE_PATH"

    echo -e "\n---\n"

done
