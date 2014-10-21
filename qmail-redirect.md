#qmail-redirect

TODO: ``ezmlm-make`` Aufruf finden, der einen ``ezmlm-reject -T`` Befehl gleich mit ins .qmail-File setzt.

Möchte man eine Mail-Weiterleitung auf eine (öffentliche) ezmlm Liste einrichten muss man ein bisschen in den Listen-Einstellungen rumfummeln:

## Szenario
### bla@example.com
* Mailingliste

### fasel@example.com
* Mail auf diese Adresse soll auf **bla@example.com** weitergeleitet werden

## Anwendung

Der Trick ist der ``-T`` Flag von **ezmlm-reject**:

> Do  not  require the list address in the ``To:`` or ``Cc:`` header(s)

1. In ``.qmail-bla`` die Überprüfung der To: und CC: Header abschalten:

    * Die Zeile mit ezmlm-reject suchen

            |if test ! -f '/home/user/listen/bla/sublist'; then /usr/local/bin/ezmlm-reject '/home/user/listen/bla'; fi

    * mit ``-T`` erweitern

            |if test ! -f '/home/user/listen/bla/sublist'; then /usr/local/bin/ezmlm-reject -T '/home/user/listen/bla'; fi

2. ``.qmail-fasel`` leitet wie gehabt weiter:

        &bla@example.com

Bei jedem Aufruf von ezmlm-make auf die Liste bla muss man das alles (leider) immer wiederholen.

## Reply-Feld

Möchte man sicherstellen, dass Antworten sofort auf der korrekten Liste landen, kommen zwei Zeilen in die ``/home/user/listen/bla/headeradd``:

    Reply-To: bla@example.com
    X-Mailing-List: bla@example.com
