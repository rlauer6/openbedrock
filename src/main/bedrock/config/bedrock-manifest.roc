<sink><include --file=site-config --dir-prefix=$config.BEDROCK_CONFIG_PATH></sink>
{
  "defaults" : {
    "mode" : "0755",
    "owner" : "<var $site.owner>",
    "group" : "<var $site.group>",
    "file_mode" : "0600",
    "overwrite" : 1
  },
  "directories" : [
    {
      "name" : "<var $dest.cgibin>",
      "link" : 1,
      "file_mode" : "0700",
      "files" : [
        {
          "source" : "<var $source.cgibin>/bedrock.cgi",
          "name" : [
            "bedrock.cgi", 
            "bedrock-session-files.cgi",
            "bedrock-docs.cgi", 
            "bedrock-autocomplete.cgi", 
            "bedrock-briefcase.cgi"
          ]
        }
      ]
    },
    {
      "name" : "<var $dest.config>",
      "files": [
        {
        "source" : "<var $source.config>",
        "name" : [
          "tagx.xml",
          "tagx_apps.xml",
          "pod_paths.xml",
          "rest.xml",
          "markdown_paths.xml"
          ]
      }
      ]
    },
    {
      "name" : "<var $dest.configd>",
      "files": [
        {
          "source" : "<var $source.config>",
          "name" : [
          ]
        }
      ]
    },
    {
      "name" : "<var $dest.startup>",
      "files": [
        {
          "source" : "<var $source.config>",
          "name" : [
            "session.xml"
           ]
        }
      ]
    },
    {
      "recurse" : 1,  
      "name" : "<var $dest.htdocs>",
      "source" : "<var $source.htdocs>",
      "exclude" : [ "qr/Makefile.*/" ]
    },
    {
      "name" : "<var $dest.include>",
      "source" : "<var $source.include>",
      "exclude" : [ "qr/Makefile.*/" ]
    },
    {
      "name" : "<var $dest.apache_config_extra>",
      "files" : [ 
        {
          "source": "<var $config.bedrock_conf>",
          "name" : [ "bedrock.conf" ]
        }
      ]
    }
  ]
}
