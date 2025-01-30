<sink><include --file=site-config --dir-prefix=($config.DIST_DIR + "/config")></sink>
<if $env.APACHE_MOD_PERL --eq 'yes'>
PerlSetEnv DBI_HOST <var $site.DBI_HOST>
PerlSetEnv DBI_USER <var $site.DBI_USER>
PerlSetEnv DBI_PASS <var $site.DBI_PASS>
PerlSetEnv DBI_DB <var $site.DBI_DB>
<else>
SetEnv DBI_HOST <var $site.DBI_HOST>
SetEnv DBI_USER <var $site.DBI_USER>
SetEnv DBI_PASS <var $site.DBI_PASS>
SetEnv DBI_DB <var $site.DBI_DB>
</if>
