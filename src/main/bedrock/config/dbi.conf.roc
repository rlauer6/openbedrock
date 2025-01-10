<sink><include --file=site-config --dir-prefix=($config.DIST_DIR + "/config")></sink>
PerlSetEnv DBI_HOST <var $site.DBI_HOST>
PerlSetEnv DBI_USER <var $site.DBI_USER>
PerlSetEnv DBI_PASS <var $site.DBI_PASS>
PerlSetEnv DBI_DB <var $site.DBI_DB>
