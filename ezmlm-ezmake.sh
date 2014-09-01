#!/bin/bash

case $(whoami) in
    freifunk)
        LDIR="$HOME/listen"
        DOMAIN="freifunk-mainz.de"
        ;;
    ffwi)
        LDIR="$HOME/ezmlm"
        DOMAIN="freifunk-wiesbaden.de"
        ;;
    ffrm)
        LDIR="$HOME/ezmlm"
        DOMAIN="freifunk-rheinmain.de"
        ;;
    *)
        echo "Error! - No settings found"
        ;;
esac

if [ -z "$LDIR" ] || [ -z "$DOMAIN" ]; then
    exit 23
fi


function new_list()
{
    echo "New List
    "
    ezmlm-make $LDIR/$1 $HOME/.qmail-$1 $1 $DOMAIN
}

function public_list()
{
    echo "Public List
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
        new)
            new_list "$2"
            shift
            ;;
        pub)
            public_list "$2"
            shift
            ;;
        *)
            echo "Wrong: $@"
            echo "Usage: [type] [list]"
            shift
            ;;
    esac
done
