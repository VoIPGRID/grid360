#/bin/sh
# Enable running ./locale/extract.sh as well as from within locale as ./extract.sh
if ! [ -d "locale" ]; then
    cd ..
fi

TEMPLATE=locale/nl_NL/LC_MESSAGES/messages.po
LOCALE_TMP_DIR=locale/.ignore

# Create directory for temporary translation files
if ! [ -d $LOCALE_TMP_DIR ]; then
    mkdir -p $LOCALE_TMP_DIR
fi

# Find translatables in all PHP files and write to >messages_php.po<
echo "1   :   Finding translations in PHP files"
xgettext --from-code=UTF-8 --language PHP --output $LOCALE_TMP_DIR/messages_php.po $(find . -type d -name templates_c -prune -o -type f \( -iname "*.php" \) | grep -v "templates_c")

if [ -f $LOCALE_TMP_DIR/messages_php.po ]; then
    # Fix charset
    sed --in-place $LOCALE_TMP_DIR/messages_php.po --expression=s/CHARSET/UTF-8/
fi

if ! [ -f $LOCALE_TMP_DIR/messages_php.po ]; then
    echo "1.1 :   No translatables found in PHP files"
fi

# Find translatables like {t}Translatables{/t} in all Smarty templates and write to >messages_tpl.po<
echo "2   :   Finding translations in Smarty templates"
php ./lib/smarty-gettext-1.0b1/tsmarty2c.php views > $LOCALE_TMP_DIR/messages_tpl.c
if [ -f $LOCALE_TMP_DIR/messages_tpl.c ]; then
    xgettext $LOCALE_TMP_DIR/messages_tpl.c --from-code=UTF-8 --add-comments --output $LOCALE_TMP_DIR/messages_tpl.po
    # Fix charset
    sed --in-place $LOCALE_TMP_DIR/messages_tpl.po --expression=s/CHARSET/UTF-8/

    if [ -f $LOCALE_TMP_DIR/messages_tpl.po ]; then
        if [ -f $LOCALE_TMP_DIR/messages_php.po ]; then
            touch $LOCALE_TMP_DIR/messages.po
            xgettext $LOCALE_TMP_DIR/messages_tpl.po --join-existing $LOCALE_TMP_DIR/messages_php.po --output $LOCALE_TMP_DIR/messages.po --from-code=UTF-8

            # Fix charset
            sed --in-place $LOCALE_TMP_DIR/messages.po --expression=s/CHARSET/UTF-8/

            # Remove merge source files
            rm $LOCALE_TMP_DIR/messages_php.po
            rm $LOCALE_TMP_DIR/messages_tpl.po
        else
            mv $LOCALE_TMP_DIR/messages_tpl.po $LOCALE_TMP_DIR/messages.po
        fi
    else
        echo "2.1 :   No translatables found in Smarty templates"
    fi

    rm $LOCALE_TMP_DIR/messages_tpl.c
fi

# Rename messages_php.po in case there were no translatables in Smarty templates
if [ -f $LOCALE_TMP_DIR/messages_php.po ]; then
    mv $LOCALE_TMP_DIR/messages_php.po $LOCALE_TMP_DIR/messages.po
fi

if [ -f $LOCALE_TMP_DIR/messages.po ]; then
    if [ -f $TEMPLATE ]; then
        echo "3   :   Merging temporary messages.po with original messages.po"
        msgmerge $TEMPLATE $LOCALE_TMP_DIR/messages.po --output $TEMPLATE --silent

        # Remove merge source file
        rm $LOCALE_TMP_DIR/messages.po

        echo "4   :   Compiling $PWD/$TEMPLATE"
        msgfmt --statistics $TEMPLATE --output locale/nl_NL/LC_MESSAGES/messages.mo
    else
        mv $LOCALE_TMP_DIR/messages.po $TEMPLATE
    fi
else
    echo "3   :   No translatables found at all"
fi

# Remove empty temporary directory
if [ -d $LOCALE_TMP_DIR ]; then
    rm -r $LOCALE_TMP_DIR
fi
