<if --not $config.DIST_DIR>
<plugin:ShareDir>
<null $config.set('DIST_DIR', $ShareDir.dist_dir('Bedrock'))>
</if>

<null:site_root ($env.APACHE_SITE_ROOT --or $env.APACHE_ROOT)>

<null:dest_dir ($env.DEST_DIR --or $site_root)>
<null:src_dir $config.DIST_DIR>

<null $config.set('BEDROCK_CONFIG_PATH', ($dest_dir + '/config'))>

<hash:site 
   APACHE_ROOT                ($env.APACHE_ROOT)
   DOCUMENT_ROOT              ($env.APACHE_DOCUMENT_ROOT --or ( $site_root + '/html') ) 
   CGI_BIN                    ($env.APACHE_CGI_BIN --or ( $site_root + '/cgi-bin' ) )
   CONF_DIR       	      ($env.APACHE_CONF_DIR --or $env.APACHE_ROOT )
   CONF_INCLUDE_DIR           ($env.APACHE_CONF_INCLUDE_DIR --or 'conf')
   BEDROCK_SESSION_DIR        ($env.BEDROCK_SESSION_DIR)
   APACHE_MOD_PERL            ($env.APACHE_MOD_PERL --or 'no')
   APACHE_VERSION             ($env.APACHE_VERSION --or '2.4')
   BEDROCK_CACHE_ENABLED      ($env.BEDROCK_CACHE_ENABLED --or 'Off')
   BEDROCK_DOCS_ENABLED       ($env.BEDROCK_DOCS_ENABLED --or 'Off')
   BEDROCK_FORMS_ENABLED      ($env.BEDROCK_FORMS_ENABLED --or 'Off')
   BEDROCK_FORMS_AUTHENTICATE ($env.BEDROCK_FORMS_ENABLED --or 'On')
   BEDROCK_SESSIONS_ENABLED   ($env.BEDROCK_SESSIONS_ENABLED --or 'On')
   BEDROCK_BENCHMARK          ($env.BEDROCK_BENCHMARK --or 'Off')
   BedrockLogLevel            ($env.BEDROCK_LOG_LEVEL --or 'info')
   owner                      ($env.OWNER --or 'apache' )
   group                      ($env.GROUP --or 'apache' )
   DBI_DB                     ($env.DBI_DB)
   DBI_USER                   ($env.DBI_USER)
   DBI_PASS                   ($env.DBI_PASS)
   DBI_HOST                   ($env.DBI_HOST)
   bedrock_shell              ($perl_config.installsitebin + '/bedrock.pl')
>

<hash:source
   apache_config_extra ( $src_dir + '/config' )
   cgibin              ( $src_dir + '/cgi-bin' )
   config              ( $src_dir + '/config' )
   css                 ( $src_dir + '/css' )
   htdocs              ( $src_dir + '/htdocs' )
   img                 ( $src_dir + '/img' )
   include             ( $src_dir + '/include')
   javascript          ( $src_dir + '/javascript' )
>

<hash:dest
   config               ( $dest_dir + '/config' )
   configd              ( $dest_dir + '/config.d' ) 
   include              ( $dest_dir + '/include' )
   pebbles              ( $dest_dir + '/pebbles' )
   startup              ( $dest_dir + '/startup' )
   cgibin               ( $site.CGI_BIN )
   htdocs               ( $site.DOCUMENT_ROOT ) 
   css                  ( $site.DOCUMENT_ROOT + '/css' )
   javascript           ( $site.DOCUMENT_ROOT + '/htdocs/javascript' )
   img                  ( $site.DOCUMENT_ROOT + '/img' )
   apache_config_extra  ( $site.CONF_DIR + '/' + $site.CONF_INCLUDE_DIR) 
>
