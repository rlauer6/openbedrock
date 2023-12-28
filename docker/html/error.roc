<html>
<head>
<!-- $Id$ -->
<link rel="stylesheet" href="<var $config.BEDROCK_SOURCE_CSS_URL>" type="text/css" />
<plugin:Timenow>
</head>

<body>
<table cellpadding=0 border=0 width="100%">
<tr>
  <td align=left><img src="<var ($config.BEDROCK_IMAGE_URL + '/' + $config.BEDROCK_ERROR_LOGO)>" border=0></td>
</tr>

<tr>
  <td><i>Bedrock version:&nbsp;</i><b><var
  $Bedrock.version></b></td>
</tr>
<tr>
  <td ><i>Timestamp:&nbsp;</i><b><var $Timenow.ctime></b></td>
</tr>
</table>

<hr>

<table width=100%>
<tr>
  <th align=left bgcolor="#dcdcdc">Error Encountered</th>
</tr>

<tr>
<null --define-var = "msg" $ERROR.mesg()>
<if $msg --re "^(PebbleDoc|BedrockDoc|BLMDoc)">
  <td class=pebble><var $msg.replace("^(PebbleDoc|BedrockDoc|BLMDoc)")></td>
<elseif $msg --re "^(PebbleDocRef|BedrockDocRef|BLMDocRef)">
  <td ><a href="<var $msg.replace(q{(.*?):\s*})>"><var $msg></a></td>
<else>
  <td><pre ><var --HTMLEncode $ERROR.mesg()></pre></td>
</if>
</tr>

<foreach --define-index = "i" $ERROR>
<tr>
  <th align=left bgcolor="#dcdcdc" >
    Location: <code ><var $file>(
     <font color="red"><a href="#error_<var $i>"><var --default = "???" $line></a></font>
    )</code>
  </th>
</tr>

<tr >
  <td >
<pre class=junk>
<var $ERROR.view_source($i, "context", 2, "compact", 0)>
</pre>
  </td>
</tr>
</foreach>
</table>
</body>
</html>
