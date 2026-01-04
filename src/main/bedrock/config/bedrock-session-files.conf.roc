#-*- mode: conf; -*-
<sink><include --file=site-config --dir-prefix=($config.DIST_DIR + "/config")></sink>

<if (($env.APACHE_VERSION --eq '2.4') --and ($site.BEDROCK_SESSIONS_ENABLED --eq 'yes')) >
Define BEDROCK_SESSION_FILES_ENABLED
</if>

<IfDefine BEDROCK_SESSION_FILES_ENABLED>
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
    SetHandler bedrock-session-files
  </IfModule>
  <else>
    # mod_perl has been disabled APACHE_MOD_PERL="<var $site.APACHE_MOD_PERL>"
    SetHandler bedrock-session-files
  </if>

</Directory>
</IfDefine>
