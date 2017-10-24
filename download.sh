#!/bin/bash

wget http://www.grokpodcast.com/atom.xml -q

URLS=$(cat atom.xml | grep enclosure | grep --only-matching --perl-regexp "https?\:\/\/[A-Za-z0-9-/.?=_]*")

max=$(echo $URLS | grep -c http)

for i in $URLS
do
    echo "$i"
    wget $i --continue -q -P media/
done
