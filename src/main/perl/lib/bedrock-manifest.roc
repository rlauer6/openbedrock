<sink><include --file=site-config --dir-prefix=$config.BEDROCK_CONFIG_PATH></sink>
{
  "defaults" : {
    "mode" : "0755",
    "owner" : "<var $owner>",
    "group" : "<var $owner>",
    "file_mode" : "0600",
    "overwrite" : 1
  },
  "directories" : [
    {
      "name" : "<var $dest.cgibin>",
      "files" : [
        {
          "source" : "<var $source.cgibin>",
          "file_mode" : "0700",
          "name" : [
            "bedrock.cgi", 
            "bedrock-session-files.cgi",
            "bedrock-docs", 
            "bedrock-autocomplete", 
            "bedrock-briefcase"
          ]
        }
      ]
    },
    {
      "name" : "<var $dest.config>",
      "files": [
        "source" : "<var $source.config>",
        "name" : [
          ]
      }
    },
    {
      "name" : "<var $dest.configd>",
      "files": [
        "source" : "<var $source.config>",
        "name" : [
          ]
      }
    },
    {
      "name" : "<var $dest.startup>",
      "files": [
        "source" : "<var $source.config>",
        "name" : [
          ]
      }
    },
    {
      "recurse" : 1,  
      "name" : "<var $dest.htdocs>",
      "source" : "<var $source.htdocs>"
    },
    {
      "name" : "<var $dest.include>",
      "source" : "<var $source.include>"
    },
    {
      "name" : "<var $dest.apache_config>",
      "source" : "<var $source.apache_config>",
      "link": 1,
      "overwrite": 1,
      "condition": {
        "not_equal" : {
          "env" : [ "ENVIRONMENT", "prod" ]
        }
      },
      "files" : [ 
        {
          "source": "<var $source.apache_config>",
          "name" : [
            "<var $config.httpd_bedrock_conf>"
            ]
        }
      ]
    }
  ]
}
