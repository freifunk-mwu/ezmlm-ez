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
    *)
        echo "Error! - No settings found"
        ;;
esac

if [ -z "$LDIR" ] || [ -z "$DOMAIN" ]; then
    exit 23
fi

function header_settings()
{
    if [ $# -eq 2 ]
    then
        echo "\"$2\" <$1.$DOMAIN>" > $LDIR/$1/listid
        echo "reply-to" >> $LDIR/$1/headerremove
        echo "Reply-To: \"$2\" <$1.$DOMAIN>" >> $LDIR/$1/headeradd
    elif [ $# -eq 1 ]
    then
        echo "<$1.$DOMAIN>" > $LDIR/$1/listid
        echo "reply-to" >> $LDIR/$1/headerremove
        echo "Reply-To: <$1.$DOMAIN>" >> $LDIR/$1/headeradd
    fi
}

function subscribe()
{
    ezmlm-sub $LDIR/$1 $2
}

function unsubscribe()
{
    ezmlm-unsub $LDIR/$1 $2
}

function new_list()
{
    echo "New Private List
    "
    ezmlm-make -f $1 $LDIR/$1 $HOME/.qmail-$1 $1 $DOMAIN
    header_settings $1 "$2"
}

function public_list()
{
    echo "New Public List
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
    ezmlm-make -+ -A -D -f $1 -H -J -L -M -R -U -W -Y $LDIR/$1 $HOME/.qmail-$1 $1 $DOMAIN
    header_settings $1 "$2"
}

while [ $# -gt 0 ]
do
    case $1 in
        new)
            case $2 in
                priv)
                    new_list "$3" "$4"
                    exit 0
                    ;;
                pub)
                    public_list "$3" "$4"
                    exit 0
                    ;;
                *)
                    echo "Wrong: `basename $0` $@"
                    echo "Usage: `basename $0` new [type] [listname] [\"description\"]"
                    exit 1
                    ;;
            esac
            ;;
        sub)
            if [ $# -eq 3 ]
            then
                subscribe "$2" "$3"
                exit 0
            else
                echo "Wrong: `basename $0` $@"
                echo "Usage: `basename $0` sub [listname] [email]"
                exit 1
            fi
            ;;
        unsub)
            if [ $# -eq 3 ]
            then
                unsubscribe "$2" "$3"
                exit 0
            else
                echo "Wrong: `basename $0` $@"
                echo "Usage: `basename $0` unsub [listname] [email]"
                exit 1
            fi
            ;;
        del)
            echo "purging list $2"
            rm -f $HOME/.qmail-$2 $HOME/.qmail-$2-*
            echo "delete dir $LDIR/$2 manually if you want to destroy all list data, too!"
            exit 0
            ;;
        *)
            echo "Wrong: `basename $0` $@"
            echo "Usage: `basename $0` new [priv|pub] [listname] [\"description\"]"
            echo "                       sub [listname] [email]"
            echo "                       unsub [listname] [email]"
            echo "                       del [listname]"
            exit 1
            ;;
    esac
done
