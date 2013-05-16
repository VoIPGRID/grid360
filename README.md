Installing the application on Linux
-----------------------------------

Make sure the following modules are enabled before you use the application:

* mod_rewrite is enabled
* mod_setenvif is enabled

Execute ```sudo a2enmod rewrite``` and ```sudo a2enmod setenvif```

If a module is already enabled it should say
>Module rewrite already enabled
>
>or
>
>Module setenvif already enabled

Otherwise these commands will makes sure they get enabled.

Also check your virtual host configuration file (most likely /etc/apache2/sites-enabled/000-default) so it says the following:

    <Directory yourfilesdir>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>

Where ```yourfilesdir``` is the directory where you save the files of the application (default /var/www/).

After you've done these things, restart your apache ```sudo /etc/init.d/apache2 reload``` or ```sudo service apache2 restart```.

Configuring the application
---------------------------

Use config file (local.php or production.php)
Make sure Smarty can read and write templates_c
Import grid360.sql, otherwise -> SQLState error

