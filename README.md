Installing the application on Linux with Apache
-----------------------------------------------

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

1. **Setup your config file**  
This will either be local.php or production.php, depending on what you need (local.php for test environment, production.php for live environment)
2. **Make sure Smarty can read and write templates_c**  
Most likely you'll need to make sure *www-data* can read and write templates_c
3. **Create a public folder (for Sacy)**  
Also make sure that *www-data* can read and write this folder
4. **Import grid360.sql**  
If you don't import this sql file you'll get SQLState errors. This is because the application operates under frozen mode meaning the database won't be dynamically changed by RedBeanPHP
5. **Setup the cron job**  
This cron job is used to determine what rounds are expired and to automatically close them. You'll need to execute ```crontab -e``` and in that file put in the following command: 
```0 * * * * /usr/bin/php applicationfilesdir/cron.php```. Where ```applicationfilesdir``` is the folder where your files for the applcication are (most likely /var/www/grid360). After saving the file it will run every hour. 



