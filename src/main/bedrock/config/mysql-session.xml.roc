<sink><include --file=site-config --dir-prefix=($config.DIST_DIR + "/config")></sink>
&lt;!-- Bedrock MySQL Sessions --&gt;
&lt;object&gt;
  &lt;scalar name=&quot;binding&quot;&gt;session&lt;/scalar&gt;
  &lt;scalar name=&quot;session&quot;&gt;yes&lt;/scalar&gt;
  &lt;scalar name=&quot;module&quot;&gt;BLM::Startup::UserSession&lt;/scalar&gt;

  &lt;object name=&quot;config&quot;&gt;
    &lt;scalar name=&quot;verbose&quot;&gt;info&lt;/scalar&gt;
    &lt;scalar name=&quot;param&quot;&gt;session&lt;/scalar&gt;
    &lt;scalar name=&quot;login_cookie_name&quot;&gt;session_login&lt;/scalar&gt;
    &lt;scalar name=&quot;login_cookie_expiry_days&quot;&gt;365&lt;/scalar&gt;
    &lt;scalar name=&quot;purge_user_after&quot;&gt;30&lt;/scalar&gt;

    &lt;!-- MySQL connect information --&gt;
    &lt;scalar name=&quot;data_source&quot;&gt;dbi:mysql:<var $site.DBI_DB>:<var $site.DBI_HOST>&lt;/scalar&gt;
    &lt;scalar name=&quot;username&quot;&gt;<var $site.DBI_USER>&lt;/scalar&gt;
    &lt;scalar name=&quot;password&quot;&gt;<var $site.DBI_PASS>&lt;/scalar&gt;
    &lt;scalar name=&quot;table_name&quot;&gt;session&lt;/scalar&gt;

    &lt;object name=&quot;cookie&quot;&gt;
      &lt;scalar name=&quot;path&quot;&gt;/&lt;/scalar&gt;
      &lt;scalar name=&quot;expiry_secs&quot;&gt;3600&lt;/scalar&gt;
      &lt;scalar name=&quot;domain&quot;&gt;&lt;/scalar&gt;
    &lt;/object&gt;
  &lt;/object&gt;
&lt;/object&gt;

