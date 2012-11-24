#!/bin/bash
set -o nounset

if [ $# -lt 1 ]; then
    echo 1>&2 "$0: not enough arguments"
    exit 2
elif [ $# -gt 1 ]; then
    echo 1>&2 "$0: too many arguments"
    exit 2
elif [ -f fi_wordlist.xml ]
then
    echo "The file exists already. Remove the old file before proceeding."
    exit 2
fi

WORDCOUNT=`cat $1 |wc -l`
INTERVAL=$[$WORDCOUNT / 255]
REMAINDER=$[$WORDCOUNT % 255]
COUNTER=255
DATE=`date +%s`
i=1

echo "<wordlist locale=\"fi\" description=\"Finnish\" date=\"$DATE\" version=\"16\">" >> fi_wordlist.xml

while [ $i -lt 256 ]
do
    echo $COUNTER
    while read line
    do
        echo "  <w f=\"$COUNTER\">$line</w>" >> fi_wordlist.xml
    done < <(head -n $[$INTERVAL*$i] $1 |tail -n $INTERVAL)
    let COUNTER-=1
    let i=i+1
done

while read line
do
    echo "  <w f=\"1\">$line</w>" >> fi_wordlist.xml
done < <(tail -n $REMAINDER $1)
echo "</wordlist>" >> fi_wordlist.xml
