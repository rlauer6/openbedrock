This is the `README-Apache` file for configuring your Apache server
for Bedrock.

# Before You Get Started

We'll assume you've installed core Bedrock.

See the `README` file for a general overview of Bedrock and the
installation process.

# Overview

Since you're reading this file, we'll assume that you don't like
surprises and have opted to install Bedrock manually or you've run
into some difficulties.

Normally the installation process does not know much about your
particular Apache server setup so tries to take some guesses.  These
may or may not be correct.  Since you apparently don't like surprises,
we'll guide you through the process of enabling your Apache web server
rather than forcing an install that "might" work.

It will help if you know something about administering an Apache web
server and you're almost certainly going to need to do these steps as
'root'.

When you installed core Bedrock, certain files were configured and
installed as reference files for you, most likely in:

`/usr/local/share/bedrock/config`

These files will be used configure your web server.

| File | Description | 
| ---- | ----------- |
| `tagx.xml` | Bedrock's default configuration file |
| `tagx_apps.xml` | Bedrock's default application configuration file |
| `startup.pl`  | mod_perl startup script |
| `perl_bedrock.conf` | Apache configuration directives |


For the sake of the following example, let's assume your site is
located at `/var/www` and your Apache configuration directory is
`/etc/apache2`:

1. Create the log directories for Bedrock and set the owner to the
Apache user (usually apache or www-data):
   ```
   mkdir -p /var/www/log/html
   chown -R apache:apache /var/www/log
   ```
2. Edit the `tagx.xml` file in the site's configuration directory
and modify the path names in some of the XML tags based on your
site's configuration if necessary.  See the instructions within the
`tagx.xml` file.  If you're document root is /`var/www` then you
can probably skip this step.

3. You'll want to use the `perl_bedrock.conf` file as a starting point
for Bedrock enabling your Apacher serve or a specific virtual host. To
do that, you should either copy and paste the contents of the
`perl_bedrock.conf' file into your Apache configuration file
(apache2.conf or httpd.conf) or copy the file to the Apache
configuration directory.

   If your Apache configuration directory has a `config.d` directory
   that is already being included by your configuration (`Include
   config.d/*`), then copy the `perl_bedrock.conf` file to that
   directory. Otherwise, copy the file to the same directory as
   your Apache configuration file and add the following Apache
   directive:
   ```
   Include perl_bedrock.conf
   ```
4. Once you've done all that, you'll want to restart your Apache web
   server in the usual way (e.g. `apachectl restart`). Make sure that
   these modules have been installed:
   * `mod_actions`
   * `mod_perl` (optional)
5. Create a symbolic link in your site's script directory to the
Bedrock script (or copy the script) that is used to process
your Bedrock pages in a non mod-perl enabled environment.
   ```
   ln -s /usr/local/lib/bedrock/cgi-bin/bedrock.cgi /var/www/cgi-bin
   ```
   Note if you use the symbolic link method, you'll want to make
   sure that your `/cgi-bin` directory includes the directives below:
   ```
   <Directory /var/www/cgi-bin>
   ...
   Options ExecCGI FollowSymLinks
   ...
   </Directory>

6. Finally, copy the Bedrock site verification files to your web
server's document root, restart Apache and test the server.
   ```
   cp -r /usr/local/share/bedrock/htdocs /var/www
   apachectl restart
   curl http://localhost/index.rock
   ```
