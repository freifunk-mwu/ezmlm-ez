#!/bin/bash

LDIR="$HOME/ezmlm"
DOMAIN="freifunk-rheinmain.de"

function public_list()
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
    ezmlm-make -+ -A -D -f -H -J -L -M -R -U -W -Y $LDIR/$1 $HOME/.qmail-$1 $1 $DOMAIN
}

while test $# -gt 0; do
    case $1 in
        pub)
            public_list "$2"
            shift
            ;;
        *)
            echo "Wrong: $@"
            echo "Usage: [type] [list]"
    esac
done
