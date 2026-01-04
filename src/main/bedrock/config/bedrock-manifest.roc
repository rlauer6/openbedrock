<sink><include --file=site-config --dir-prefix=($config.DIST_DIR + "/config")></sink>
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
     "name": "<var $site.BEDROCK_AUTOCOMPLETE_DIR>",
     "files" : []
    },
    {
     "name": "<var $site.BEDROCK_SESSION_DIR>",
     "files" : []
    },
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
          "tagx.xml.roc",
          "tagx_apps.xml",
          "pod_paths.xml",
          "markdown_paths.xml",
          "log4perl.conf",
          "bedrock.users"
          ]
       }
      ]
    },
    {
     "name": "<var $dest.config>",
     "files": [
         {
          "source" : "<var $source.htdocs>",
          "name" : [ "register.xml"]
         }
       ]
    },
    {
      "name" : "<var $dest.config>/admin",
      "files": [
        {
        "source" : "<var $source.config>/admin",
        "name" : [
          "index.roc",
          "bedrock.css",
          "bedrock.js",
          "handler.inc",
          "login-container.inc",
          "register.roc",
          "plugins-container.inc",
           "register-container.inc"
          ]
       }
      ]
    },
    {
      "name" : "<var $dest.config>/forms",
      "files": [
        {
        "source" : "<var $source.config>",
        "name" : [
          "default_form_config.json"
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
             "data-sources.xml"
          ]
        }
      ]
    },
    {
      "name" : "<var $dest.configd>/startup",
      "files": [
        {
          "source" : "<var $source.config>",
          "name" : [
            "mysql-session.xml",
            "rest.xml"
           ]
        }
      ]
    },
    {
      "recurse" : 0,  
      "name" : "<var $dest.htdocs>",
      "source" : "<var $source.htdocs>",
      "exclude" : [ "qr/Makefile.*/",
                    "register-notes.inc",
                     "index.roc",
                     "register.xml",
                     "register.css",
                     "register.js"
                  ]
    },
    {
      "name" : "<var $dest.htdocs>/register",
      "files" : [
        {
         "source" : "<var $source.htdocs>",
         "name" : [ "index.roc", "register.css", "register.js" ]
        }
      ]
    },
    {
      "name" : "<var $dest.include>",
      "source" : "<var $source.include>",
      "exclude" : [ "qr/Makefile.*/" ]
    },
    {
      "name" : "<var $dest.include>",
      "files" : [
        {
          "source" : "<var $source.htdocs>",
          "name": [ "register-notes.inc"]
        }
      ]
    },
    {
      "recurse" : 0,
      "name" : "<var $dest.pebbles>",
      "source" : "<var $source.pebbles>",
      "exclude" : [ "qr/Makefile.*/" ]
    },
    {
      "name" : "<var $dest.apache_extra_conf>",
      "files" : [ 
        {
          "source": "<var $source.config>",
          "name" : [
              "dbi.conf",
              "bedrock-session-files.conf"
          ]
        }
      ]
    },
    {
      "name" : "<var $dest.apache_site_conf>",
      "files" : [
        {
          "source": "<var $source.config>",
          "name" : [
              "bedrock.conf"
          ]
        }
      ]
    }

  ]
}
