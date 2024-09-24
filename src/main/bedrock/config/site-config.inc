<if --not $config.DIST_DIR>
<plugin:ShareDir>
<null $config.set('DIST_DIR', $ShareDir.dist_dir('Bedrock'))>
</if>

<null $config.set('BEDROCK_CONFIG_PATH', ($config.DIST_DIR + '/config'))>

<hash:site 
   APACHE_ROOT           $env.APACHE_ROOT
   DOCUMENT_ROOT         ($env.APACHE_DOCUMENT_ROOT --or ( $env.APACHE_ROOT + '/htdocs') ) 
   CGI_BIN               ($env.APACHE_CGI_BIN --or ( $env.APACHE_ROOT + '/cgi-bin' ) )
   CONF_DIR       	 ($env.APACHE_CONF_DIR --or ($env.APACHE_ROOT + '/conf' ) )
   BEDROCK_SESSION_DIR   $env.BEDROCK_SESSION_DIR
   APACHE_MOD_PERL       ($env.APACHE_MOD_PERL --or 'no')
   APACHE_VERSION        ($env.APACHE_VERSION --or '2.4')
   BEDROCK_CACHE_ENABLED ($env.BEDROCK_CACHE_ENABLED --or 'Off')
   BEDROCK_BENCHMARK     ($env.BEDROCK_BENCHMARK --or 'Off')
   BedrockLogLevel       ($env.BEDROCK_LOG_LEVEL --or 'info')
   owner                 ($env.OWNER --or 'apache' )
   group                 ($env.GROUP --or 'apache' )
>

<null:destdir ($env.DESTDIR --or '/var/www')>
<null:srcdir $config.DIST_DIR>

<hash:source
   apache_config_extra ( $srcdir + '/config' )
   cgibin              ( $srcdir + '/cgi-bin' )
   config              ( $srcdir + '/config' )
   css                 ( $srcdir + '/css' )
   htdocs              ( $srcdir + '/htdocs' )
   img                 ( $srcdir + '/img' )
   include             ( $srcdir + '/include')
>

<hash:dest
   config               ( $destdir + '/config' )
   configd              ( $destdir + '/config.d' ) 
   include              ( $destdir + '/include' )
   pebbles              ( $destdir + '/pebbles' )
   startup              ( $destdir + '/startup' )
   cgibin               ( $site.CGI_BIN )
   htdocs               ( $site.DOCUMENT_ROOT ) 
   css                  ( $site.DOCUMENT_ROOT + '/css' )
   img                  ( $site.DOCUMENT_ROOT + '/img' )
   apache_config_extra  ( $site.CONF_DIR ) 
>
