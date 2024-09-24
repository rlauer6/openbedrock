#-*- mode: conf; -*-
# bedrock -e apache24-env-debian httpd-bedrock.conf.roc > httpd-bedrock.roc
<sink><include --file=site-config --dir-prefix=$config.BEDROCK_CONFIG_PATH></sink>
<if $site.APACHE_MOD_PERL --eq yes >
<IfModule !perl_module>
LoadModule perl_module modules/mod_perl.so
</IfModule>
</if>

# These may have already been loaded
<IfModule !cgi_module>
 LoadModule cgi_module modules/mod_cgi.so
</IfModule>

<IfModule !actions_module>
LoadModule actions_module modules/mod_actions.so
</IfModule>

<IfModule !alias_module>
LoadModule alias_module modules/mod_alias.so
</IfModule>

SetEnv BEDROCK_CONFIG_PATH   <var $config.BEDROCK_CONFIG_PATH>
SetEnv BEDROCK_CACHE_ENABLED <var $site.BEDROCK_CACHE_ENABLED>
SetEnv BEDROCK_BENCHMARK     <var $site.BEDROCK_BENCHMARK>
SetEnv BedrockLogLevel       <var $site.BedrockLogLevel>

DirectoryIndex index.roc index.rock

AddType	text/html .roc .rock
AddType application/json .jroc .jrock

# CGI handlers
Action        bedrock-cgi  /cgi-bin/bedrock.cgi virtual
Action        bedrock-docs /cgi-bin/bedrock-docs.cgi virtual
Action        bedrock-session-files /cgi-bin/bedrock-session-files.cgi virtual

AddHandler    bedrock-cgi .rock .jrock

# Bedrock - mod-perl for .roc (if mod_perl)
<IfModule mod_perl.c>
  PerlRequire <var $config.BEDROCK_CONFIG_PATH>/startup.pl
  AddHandler  perl-script .roc .jroc
  PerlHandler Apache::Bedrock
</IfModule>

<IfModule !mod_perl.c>
  AddHandler  bedrock-cgi .roc .jroc
</IfModule>

Alias /bedrock/img <var $config.DIST_DIR>/img

<Directory <var $config.DIST_DIR>/img>
   Options -Indexes
   <if $site.APACHE_VERSION --eq '2.2'>
   Order allow,deny
   Allow from all
   <else>
   require all granted
   </if>
</Directory>

Alias /bedrock/doc <var $config.DIST_DIR>/doc/bedrock-<var $config.version()>

<Directory <var $config.DIST_DIR>/doc/bedrock-<var $config.version()>>
   Options +Indexes
   AllowOverride None
   <if $site.APACHE_VERSION --eq '2.2'>
   Order allow,deny
   Allow from all
   <else>
   require all granted
   </if>
</Directory>

Alias /bedrock/css <var $config.DIST_DIR>/css

<Directory <var $config.DIST_DIR>/css>
   Options -Indexes
   AllowOverride None
   <if $site.APACHE_VERSION --eq '2.2'>
   Order allow,deny
   Allow from all
   <else>
   require all granted
   </if>
</Directory>

# Bedrock system directory, access to which is controlled
#  by authentication: default username=admin, password=bedrock
#  and by setting in tagx.xml ALLOW_BEDROCK_INFO (default=yes)
Alias /bedrock <var $site.DOCUMENT_ROOT>/bedrock

<Directory <var $site.DOCUMENT_ROOT>/bedrock/>
   AcceptPathInfo On
   Options -Indexes
   AllowOverride None
   <if $site.APACHE_VERSION --eq '2.2'>
   Order allow,deny
   Allow from all
   <else>
   require all granted
   </if>

  <IfModule mod_perl.c>
    SetHandler perl-script 
    PerlHandler Apache::BedrockDocs 
  </IfModule>

  <IfModule !mod_perl.c>
    SetHandler bedrock-docs
  </IfModule>

  AuthType Basic
  AuthName Bedrock
  AuthBasicProvider file
  AuthUserFile <var $config.BEDROCK_CONFIG_PATH>/bedrock.users
  require valid-user

</Directory>

Alias /session <var $site.BEDROCK_SESSION_DIR>

<Directory <var $site.BEDROCK_SESSION_DIR>>
  AcceptPathInfo On
  Options -Indexes

  <IfModule mod_perl.c>
    SetHandler perl-script
    PerlHandler Apache::BedrockSessionFiles
  </IfModule>

  <IfModule !mod_perl.c>
    SetHandler bedrock-session-files
  </IfModule>

</Directory>
