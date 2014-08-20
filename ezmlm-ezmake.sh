#!/bin/bash

LDIR="~/ezmlm"
DOMAIN="freifunk-rheinmain.de"

function default_list()
{
    echo "
        -A Not archived
        -D No Digest
        -f Prefix [listname]
        -H Subscription via confirmation mail
        -J Unsubscribe via confirmation mail
        -L No subscriber list
        -M No Moderation
        -R No remote administration
        -U No post restriction based on Sender
        -W No adresss restriction
        -Y No sender confirmation
    "
    ezmlm-make -+ -A -D -f -H -J -L -M -R -U -W -Y $LDIR/$1 ~/.qmail-$1 $1 $DOMAIN
}

if [ ! -z "$1" ]; then
    default_list "$@"
else
    echo "Please specify a list."
fi
