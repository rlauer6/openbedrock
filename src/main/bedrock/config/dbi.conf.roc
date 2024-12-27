<sink><include --file=site-config --dir-prefix=($config.DIST_DIR + "/config")></sink>
PerlSetEnv DBI_HOST $site.DBI_HOST
PerlSetEnv DBI_USER $site.DBI_USER
PerlSetEnv DBI_PASS $site.DBI_PASS
PerlSetEnv DBI_DB $site.DBI_DB
