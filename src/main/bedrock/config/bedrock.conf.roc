#-*- mode: conf; -*-
# -- Apache configuration for Bedrock enabled sites
<sink><include --file=site-config --dir-prefix=($config.DIST_DIR + "/config")></sink>

<if $config.DISTRO --eq 'redhat' >

<IfModule !actions_module>
  LoadModule actions_module modules/mod_actions.so
</IfModule>

<IfModule !alias_module>
  LoadModule alias_module modules/mod_alias.so
</IfModule>

<IfModule !apreq_module>
  LoadModule apreq_module modules/mod_apreq2.so
</IfModule>

</if>

<if $site.APACHE_MOD_PERL --eq yes >
PerlSetEnv BEDROCK_INCLUDE_DIR   <var $config.DIST_DIR>/include
PerlSetEnv BEDROCK_PEBBLE_DIR    <var $config.DIST_DIR>/pebbles
PerlSetEnv BEDROCK_IMAGE_DIR     <var $config.DIST_DIR>/img
PerlSetEnv BEDROCK_CONFIG_PATH   <var $config.BEDROCK_CONFIG_PATH>
PerlSetEnv BEDROCK_CACHE_ENABLED <var $site.BEDROCK_CACHE_ENABLED>
PerlSetEnv BEDROCK_BENCHMARK     <var $site.BEDROCK_BENCHMARK>
PerlSetEnv BedrockLogLevel       <var $site.BedrockLogLevel>
PerlSetEnv APACHE_CONF_DIR       <var $site.CONF_DIR>
<else>
SetEnv BEDROCK_INCLUDE_DIR   <var $config.DIST_DIR>/include
SetEnv BEDROCK_PEBBLE_DIR    <var $config.DIST_DIR>/pebbles
SetEnv BEDROCK_IMAGE_DIR     <var $config.DIST_DIR>/img
SetEnv BEDROCK_CONFIG_PATH   <var $config.BEDROCK_CONFIG_PATH>
SetEnv BEDROCK_CACHE_ENABLED <var $site.BEDROCK_CACHE_ENABLED>
SetEnv BEDROCK_BENCHMARK     <var $site.BEDROCK_BENCHMARK>
SetEnv BedrockLogLevel       <var $site.BedrockLogLevel>
SetEnv APACHE_CONF_DIR       <var $site.CONF_DIR>
</if>

DirectoryIndex index.roc index.rock

AddType	text/html .roc .rock
AddType application/json .jroc .jrock

# CGI handlers
Action        bedrock-cgi  /cgi-bin/bedrock.cgi virtual
Action        bedrock-docs /cgi-bin/bedrock-docs.cgi virtual
Action        bedrock-session-files /cgi-bin/bedrock-session-files.cgi virtual

AddHandler    bedrock-cgi .rock .jrock <if $site.APACHE_MOD_PERL --ne 'yes'>.roc .jroc</if>

<Directory "<var $site.CGI_BIN>">
  Options +SymLinksIfOwnerMatch
</Directory>

# Bedrock - mod-perl for .roc (if mod_perl)
<if $site.APACHE_MOD_PERL --eq 'yes' >
<IfModule mod_perl.c>
    PerlRequire <var $config.DIST_DIR>/config/startup.pl
    AddHandler  perl-script .roc .jroc
    PerlHandler Apache::Bedrock
</IfModule>
<IfModule !mod_perl.c>
  AddHandler bedrock-cgi .roc .jroc
</IfModule>
</if>

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

Alias /bedrock/javascript <var $config.DIST_DIR>/javascript

<Directory <var $config.DIST_DIR>/javascript>
   Options -Indexes
   <if $site.APACHE_VERSION --eq '2.2'>
   Order allow,deny
   Allow from all
   <else>
   require all granted
   </if>
</Directory>

Alias /bedrock/admin <var $config.DIST_DIR>/config/admin
<Directory  <var $config.DIST_DIR>/config/admin >

   AcceptPathInfo On
   Options -Indexes
   AllowOverride None

  AuthType Basic
  AuthName Bedrock
  AuthBasicProvider file
  AuthUserFile /var/www/bedrock/config/bedrock.users
  require valid-user

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

<if $site.BEDROCK_FORMS_ENABLED --eq 'On'>
Alias /form <var $site.DOCUMENT_ROOT>/form

<Directory <var $site.DOCUMENT_ROOT>/form/>
 
   <if $site.APACHE_VERSION --eq '2.4'>
     IncludeOptional <var $site.CONF_DIR>/dbi.con[f]  
   <else>
     Include <var $site.CONF_DIR>/dbi.con[f]  
   </if>

   AcceptPathInfo On
   Options -Indexes
   AllowOverride None

  <if $site.APACHE_MOD_PERL --eq 'yes'>
  <IfModule mod_perl.c>
      SetHandler perl-script
      PerlHeaderParserHandler Apache::Authenticate
      PerlHandler Apache::Form
  </IfModule>
  </if>

</Directory>
</if>

<if $site.BEDROCK_DOCS_ENABLED --eq 'On'>
# Bedrock system directory, access to which is controlled
#  by authentication: default username=admin, password=bedrock
#  and by setting in tagx.xml ALLOW_BEDROCK_INFO (default=yes)
Alias /bedrock <var $site.DOCUMENT_ROOT>/bedrock

<Directory <var $site.DOCUMENT_ROOT>/bedrock/>
   AcceptPathInfo On
   Options -Indexes
   AllowOverride None

  <if $site.APACHE_MOD_PERL --eq 'yes'>
  <IfModule mod_perl.c>
      SetHandler perl-script 
      PerlHandler Apache::BedrockDocs 
  </IfModule>

  <IfModule !mod_perl.c>
    SetHandler bedrock-docs
  </IfModule>
  <else>
    SetHandler bedrock-docs
  </if>

  AuthType Basic
  AuthName Bedrock
  AuthBasicProvider file
  AuthUserFile <var $config.BEDROCK_CONFIG_PATH>/bedrock.users
  require valid-user

</Directory>
</if>

<if $site.BEDROCK_SESSIONS_ENABLED --eq 'On'>
Alias /session <var $site.BEDROCK_SESSION_DIR>

<Directory <var $site.BEDROCK_SESSION_DIR>>
  AcceptPathInfo On
  Options -Indexes

  <if $site.APACHE_MOD_PERL --eq 'yes'>
  <IfModule mod_perl.c>
      SetHandler perl-script
      PerlFixupHandler Apache::BedrockSessionFiles
  </IfModule>

  <IfModule !mod_perl.c>
    # You apparently wanted to use mod_perl but it is not enabled!
    SetHandler bedrock-session-files
  </IfModule>
  <else>
    # Looks like you have deliberately disabled mod_perl via APACHE_MOD_PERL="<var $site.APACHE_MOD_PERL>"
    SetHandler bedrock-session-files
  </if>

</Directory>
<else>
# BedrockSessionFiles has been disabled BEDROCK_SESSIONS_ENABLED="<var $site.BEDROCK_SESSIONS_ENABLED>"
</if>
