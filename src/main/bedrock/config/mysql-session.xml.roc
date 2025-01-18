<sink><include --file=site-config --dir-prefix=($config.DIST_DIR + "/config")></sink>
<!-- Bedrock MySQL Sessions -->
<object>
  <scalar name="binding">session</scalar>
  <scalar name="session">no</scalar>
  <scalar name="module">BLM::Startup::UserSession</scalar>

  <object name="config">
    <scalar name="verbose">info</scalar>
    <scalar name="param">session</scalar>
    <scalar name="login_cookie_name">session_login</scalar>
    <scalar name="login_cookie_expiry_days">365</scalar>
    <scalar name="purge_user_after">30</scalar>

    <!-- MySQL connect information -->
    <scalar name="data_source">dbi:mysql:<var $site.DBI_DB>:<var $site.DBI_HOST></scalar>
    <scalar name="username"><var $site.DBI_USER></scalar>
    <scalar name="password"><var $site.DBI_PASS></scalar>
    <scalar name="table_name">session</scalar>

    <object name="cookie">
      <scalar name="path">/</scalar>
      <scalar name="expiry_secs">3600</scalar>
      <scalar name="domain"></scalar>
    </object>
  </object>
</object>

