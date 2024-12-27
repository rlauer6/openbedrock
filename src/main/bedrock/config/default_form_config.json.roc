{
    "tables": {
    },
    "javascript": [
        {
            "src": "https://code.jquery.com/jquery-3.7.1.min.js",
            "integrity": "sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=",
            "crossorigin": "anonymous"
        },
        {
            "src": "/bedrock/javascript/indexed-table-handler.js"
        },
        {
            "src": "https://code.jquery.com/ui/1.14.1/jquery-ui.js"
        }
    ],
    "link": [
        {
            "rel": "stylesheet",
            "href": "https://code.jquery.com/ui/1.14.1/themes/base/jquery-ui.css"
        },
        {
            "rel": "stylesheet",
            "href": "/bedrock/indexed-table-handler.css"
        }
    ],
    "database": {
        "dsn": "dbi:mysql:<var $site.DBI_DB>",
        "user": "<var $site.DBI_USER>",
        "password": "<var $site.DBI_PASS>",
        "hostname": "<var $site.DBI_HOST>"
    },
    "title": ""
}
