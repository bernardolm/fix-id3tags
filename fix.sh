#!/bin/bash

MAX=$(cat atom.xml| grep '<item>' -c)

FILE_PREFIX="http://media.grokpodcast.com/"

for i in `seq 148 $MAX`
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

    FILE_PATH=$(echo "media/$FILE")
    echo "FILE_PATH = $FILE_PATH"

    mid3v2 --convert --verbose "$(echo $FILE_PATH)"
    mid3v2 --artist="Grok Podcast" --album="Grok Podcast" --song="$(echo $TITLE)" --genre="Podcast" --track="$(echo $i)" --verbose --picture="$(echo $IMG_PATH)" --date="$(echo $DATE)" "$(echo $FILE_PATH)"
    mid3iconv --debug $(echo "media/$FILE")

    echo -e "\n---\n"

done
