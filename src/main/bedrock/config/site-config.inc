<if --not $config.DIST_DIR>
<plugin:ShareDir>
<null $config.set('DIST_DIR', $ShareDir.dist_dir('Bedrock'))>
</if>

<null:site_root $env.APACHE_SITE_ROOT --default=$env.APACHE_ROOT>

<null:dest_dir --default=$site_root.format("%s/bedrock") $env.DEST_DIR>
<null:src_dir $config.DIST_DIR>

<null $config.set('BEDROCK_CONFIG_PATH', ($dest_dir + '/config'))>

<hash:site
   APACHE_MOD_PERL              ($env.APACHE_MOD_PERL --or 'no')
   APACHE_ROOT                  ($env.APACHE_ROOT)
   APACHE_VERSION               ($env.APACHE_VERSION --or '2.4')
   BEDROCK_AUTOCOMPLETE_ENABLED ($env.BEDROCK_AUTOCOMPLETE_ENABLED --or 'no')
   BEDROCK_AUTOCOMPLETE_DIR     ($env.BEDROCK_AUTOCOMPLETE_DIR --or ($site_root + '/bedrock/autocomplete'))
   BEDROCK_BENCHMARK            ($env.BEDROCK_BENCHMARK --or 'Off')
   BEDROCK_CACHE_ENABLED        ($env.BEDROCK_CACHE_ENABLED --or 'Off')
   BEDROCK_CONF_DIR             ($env.BEDROCK_CONF_DIR --or ( $site_root + '/bedrock/config'))
   BEDROCK_DOCS_ENABLED         ($env.BEDROCK_DOCS_ENABLED --or 'Off')
   BEDROCK_FORMS_AUTHENTICATE   ($env.BEDROCK_FORMS_ENABLED --or 'On')
   BEDROCK_FORMS_ENABLED        ($env.BEDROCK_FORMS_ENABLED --or 'Off')
   BEDROCK_SESSIONS_ENABLED     ($env.BEDROCK_SESSIONS_ENABLED --or 'On')
   BEDROCK_SESSION_DIR          ($env.BEDROCK_SESSION_DIR --or ($site_root.format('%s/bedrock/session')))
   BedrockLogLevel              ($env.BEDROCK_LOG_LEVEL --or 'info')
   ApacheLogLevel               ($env.APACHE_LOG_LEVEL --or 'info')
   CGI_BIN                      ($env.APACHE_CGI_BIN --or ( $site_root + '/cgi-bin' ) )
   CONF_DIR       	        ($env.APACHE_CONF_DIR --or $env.APACHE_ROOT )
   CONF_INCLUDE_DIR             ($env.APACHE_CONF_INCLUDE_DIR --or 'conf')
   CONF_SITE_DIR                ($env.APACHE_CONF_SITE_DIR --or 'conf.d')
   DBI_DB                       ($env.DBI_DB)
   DBI_HOST                     ($env.DBI_HOST)
   DBI_PASS                     ($env.DBI_PASS)
   DBI_USER                     ($env.DBI_USER)
   DOCUMENT_ROOT                ($env.APACHE_DOCUMENT_ROOT --or ( $site_root + '/html') ) 
   bedrock_shell                ($env.BEDROCK_INSTALL_PATH + '/bin/bedrock.pl')
   group                        ($env.GROUP --or 'apache' )
   owner                        ($env.OWNER --or 'apache' )
>

<hash:source
   apache_extra_conf   ( $src_dir + '/config' )
   cgibin              ( $src_dir + '/cgi-bin' )
   config              ( $src_dir + '/config' )
   css                 ( $src_dir + '/css' )
   htdocs              ( $src_dir + '/htdocs' )
   img                 ( $src_dir + '/img' )
   include             ( $src_dir + '/include')
   pebbles             ( $src_dir + '/pebbles')
   javascript          ( $src_dir + '/javascript' )
>

<hash:dest
   config               ( $dest_dir + '/config' )
   configd              ( $dest_dir + '/config.d' ) 
   include              ( $dest_dir + '/include' )
   pebbles              ( $dest_dir + '/pebbles' )
   cgibin               ( $site.CGI_BIN )
   htdocs               ( $site.DOCUMENT_ROOT ) 
   css                  ( $site.DOCUMENT_ROOT + '/css' )
   javascript           ( $site.DOCUMENT_ROOT + '/htdocs/javascript' )
   img                  ( $site.DOCUMENT_ROOT + '/img' )
   apache_extra_conf    ( $site.CONF_DIR + '/' + $site.CONF_INCLUDE_DIR) 
   apache_site_conf     ( $site.CONF_DIR + '/' + $site.CONF_SITE_DIR) 
>

<hash:site_config site        $site
                  source      $source
                  destination $dest
                  site_root   $site_root
                  src_dir     $src_dir >
