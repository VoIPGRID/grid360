#!/bin/sh
TEMPLATE_DIR=locale/nl_NL/LC_MESSAGES/
if ! [ -d "locale" ]; then
    cd ..
fi

if [ -f $TEMPLATE_DIR/messages.po ]; then
    msgfmt --statistics $TEMPLATE_DIR/messages.po --output $TEMPLATE_DIR/messages.mo
    echo "messages.mo is now up to date"
else
    echo "$PWD/$TEMPLATE/messages.po is not a file, run extract.sh first."
fi
