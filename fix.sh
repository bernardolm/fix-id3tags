#!/bin/bash

MAX=$(cat atom.xml| grep '<item>' -c)

FILE_PREFIX="http://media.grokpodcast.com/"

for i in `seq 1 $MAX`
do
    TITLE_COMMAND="xmllint --xpath 'string(//channel/item["$i"]/title)' atom.xml"
    TITLE=$(eval $TITLE_COMMAND)
    echo "TITLE = $TITLE"

    URL_COMMAND="xmllint --xpath 'string(//channel/item["$i"]/enclosure/@url)' atom.xml"
    URL=$(eval $URL_COMMAND)
    echo "URL = $URL"
    wget $URL --continue -q -P media/

    FILE_COMMAND="xmllint --xpath 'string(//channel/item["$i"]/guid)' atom.xml"
    FILE=$(eval $FILE_COMMAND)
    FILE=${FILE#$FILE_PREFIX}
    echo "FILE = $FILE"

    FILE_PATH=$(echo "media/$FILE")
    echo "FILE_PATH = $FILE_PATH"

    mid3v2 --convert --verbose "$(echo $FILE_PATH)"
    mid3v2 --artist="Grok Podcast" --album="Grok Podcast" --song="$(echo $TITLE)" --genre="Podcast" --track="$(echo $i)" --verbose "$(echo $FILE_PATH)"
    mid3iconv --debug $(echo "media/$FILE")

    echo -e "\n---\n"

done
