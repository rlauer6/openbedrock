#-*- mode: conf; -*-

<sink><include --file=site-config --dir-prefix=($config.DIST_DIR + "/config")></sink>

<if $site.BEDROCK_AUTOCOMPLETE_ENABLED --eq 'yes'>
Action bedrock-autocomplete /cgi-bin/bedrock-autocomplete.cgi virtual

Alias /autocomplete <var $site.BEDROCK_AUTOCOMPLETE_DIR>

<Directory <var $site.BEDROCK_AUTOCOMPLETE_DIR>>
  AcceptPathInfo On
  Options -Indexes

  <IfModule mod_perl.c>
    SetHandler perl-script
    PerlHandler Apache::BedrockAutocomplete
    PerlSetEnv BEDROCK_AUTOCOMPLETE_ENABLED yes
  </IfModule>

  <IfModule !mod_perl.c>
    SetHandler bedrock-autocomplete
    SetEnv BEDROCK_AUTOCOMPLETE_ENABLED yes
  </IfModule>

</Directory>
<else>
# Bedrock::Apache::BedrockAutocomplete has been disabled:
# BEDROCK_AUTOCOMPLETE_ENABLED=<var $site.BEDROCK_AUTOCOMPLETE_ENABLED>
</if>
