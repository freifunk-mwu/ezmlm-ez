#!/bin/bash

LDIR="~/ezmlm"
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
    ezmlm-make -+ -A -D -f -H -J -L -M -R -U -W -Y $LDIR/$2 ~/.qmail-$2 $2 $DOMAIN
}

if [ -z "$@" ]; then
    echo "Usage: [type] [list]"
else
    while test $# -gt 0; do
        case $1 in
            pub)
                public_list "$@"
                shift
                ;;
            *)
                echo "Wrong: $@"
        esac
        shift
    done
fi
