<html>
  <head>
    <title><var $title --default="no-title"></title>
    <link rel="stylesheet" href="<var $stylesheet>" type="text/css" />
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  </head>

  <body id="bedrock-docs-index" class="bedrock-docs">

  <include --file=~/bedrock-docs-header>

  <if $title>
    <h1><var $title></h1>
  </if>

  <if $content>
    <var $content>
 </body>
</html>
   </if>
