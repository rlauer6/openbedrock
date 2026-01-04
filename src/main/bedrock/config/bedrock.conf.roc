#-*- mode: conf; -*-

# -- Apache configuration for Bedrock enabled sites
<sink><include --file=site-config --dir-prefix=($config.DIST_DIR + "/config")></sink>

<if $site.APACHE_MOD_PERL --eq yes >
PerlSetEnv APACHE_SITE_ROOT             <var $site_root>
PerlSetEnv BEDROCK_INCLUDE_DIR          <var $site_root>/bedrock/include
PerlSetEnv BEDROCK_PEBBLE_DIR           <var $site_root>/bedrock/pebbles
PerlSetEnv BEDROCK_IMAGE_DIR            <var $config.DIST_DIR>/img
PerlSetEnv BEDROCK_CONFIG_PATH          <var $config.BEDROCK_CONFIG_PATH>
PerlSetEnv BEDROCK_BENCHMARK            <var $site.BEDROCK_BENCHMARK>
PerlSetEnv BedrockLogLevel              <var $site.BedrockLogLevel>
PerlSetEnv APACHE_CONF_DIR              <var $site.CONF_DIR>
PerlSetEnv BEDROCK_AUTOCOMPLETE_ENABLED <var $site.BEDROCK_AUTOCOMPLETE_ENABLED>
PerlPassEnv PERL5LIB
PerlPassEnv BEDROCK_CACHE_ENGINE
PerlPassEnv BEDROCK_SESSION_MANAGER
</if>

PassEnv PERL5LIB
PassEnv BEDROCK_CACHE_ENGINE
PassEnv BEDROCK_SESSION_MANAGER

# we always set this in case we are using bedrock.cgi
SetEnv APACHE_SITE_ROOT             <var $site_root>
SetEnv BEDROCK_INCLUDE_DIR          <var $site_root>/bedrock/include
SetEnv BEDROCK_PEBBLE_DIR           <var $site_root>/bedrock/pebbles
SetEnv BEDROCK_IMAGE_DIR            <var $config.DIST_DIR>/img
SetEnv BEDROCK_CONFIG_PATH          <var $config.BEDROCK_CONFIG_PATH>
SetEnv BEDROCK_BENCHMARK            <var $site.BEDROCK_BENCHMARK>
SetEnv BedrockLogLevel              <var $site.BedrockLogLevel>
SetEnv APACHE_CONF_DIR              <var $site.CONF_DIR>
SetEnv BEDROCK_AUTOCOMPLETE_ENABLED <var $site.BEDROCK_AUTOCOMPLETE_ENABLED>

<VirtualHost *:80>

  DocumentRoot <var $site.DOCUMENT_ROOT>

  <if $config.DISTRO --eq 'redhat' >

  <IfModule !actions_module>
    LoadModule actions_module modules/mod_actions.so
  </IfModule>

  <IfModule !rewrite_module>
    LoadModule rewrite_module modules/mod_rewrite.so
  </IfModule>

  <IfModule !alias_module>
    LoadModule alias_module modules/mod_alias.so
  </IfModule>

  <IfModule !apreq_module>
    LoadModule apreq_module modules/mod_apreq2.so
  </IfModule>

  </if>


  LogLevel <var $site.ApacheLogLevel --default=$site.BedrockLogLevel>

  <if $site.APACHE_LOG_DIR>
  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
  <else>
  ######################################################################
  # Logs were configured this way because APACHE_LOG_DIR was not found
  # in the environment when 'bedrock-site-install' was executed. If
  # you want logs to go to files then make sure APACHE_LOG_DIR is set.
  #
  # debian:
  #
  #   source /etc/apache2/envvars && bedrock-site-install --distro debian
  #
  # redhat:
  #
  #   APACHE_LOG_DIR=/var/log/httpd && bedrock-site-install --distro redhat
  #
  ######################################################################
  ErrorLog /dev/stderr
  CustomLog /dev/stdout combined
  </if>

  DirectoryIndex index.roc index.rock

  AddType	text/html .roc .rock
  AddType       application/json .jroc .jrock

  # CGI handlers
  Action        bedrock-cgi  /cgi-bin/bedrock.cgi virtual
  Action        bedrock-docs /cgi-bin/bedrock-docs.cgi virtual
  Action        bedrock-session-files /cgi-bin/bedrock-session-files.cgi virtual

  AddHandler    bedrock-cgi .rock .jrock

  <if $site.APACHE_MOD_PERL --ne 'yes'>
  AddHandler    bedrock-cgi .roc .jroc
  </if>

  <Directory "<var $site.CGI_BIN>">
    Options +FollowSymLinks -SymLinksIfOwnerMatch
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

  Alias /bedrock/admin <var $config.DIST_DIR>/config/admin
  <Directory  <var $config.DIST_DIR>/config/admin >

    AcceptPathInfo On
    Options -Indexes
    AllowOverride None

    AuthType Basic
    AuthName Bedrock
    AuthBasicProvider file
    AuthUserFile <var $site.BEDROCK_CONF_DIR>/bedrock.users
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

  <if $site.BEDROCK_FORMS_ENABLED --eq 'On'>
  Alias /form <var $site.DOCUMENT_ROOT>/form

  <Directory <var $site.DOCUMENT_ROOT>/form/>

     <if $site.APACHE_VERSION --eq '2.4'>
       IncludeOptional <var $site.CONF_INCLUDE_DIR>/dbi.conf
     <else>
       Include <var $site.CONF_INCLUDE_DIR>/dbi.conf
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

</VirtualHost>
