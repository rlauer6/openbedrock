<style type="text/css">
.var		{ color: #a020f0; }
.include	{ color: #a020f0; }
.exec		{ color: #a020f0; }
.sql		{ color: #778899; }
.sqlconnect	{ color: #778899; }
.sink		{ color: #7a378b; }
.null		{ color: #7a378b; }
.foreach	{ color: #0000ff; }
.sqlselect	{ color: #0000ff; }
.while		{ color: #0000ff; }
.if		{ color: #00cd00; }
.else		{ color: #00cd00; }
.elseif		{ color: #00cd00; }
.elsif		{ color: #00cd00; }
.trace		{ color: #b22222; }
.try		{ color: #ff0000; }
.catch		{ color: #ff0000; }
.raise		{ color: #ff0000; }
.error		{ background-color: #ffe4b5; font-weight: 900; }
.context	{ color: red; font-weight: 900; }
.lineno		{ color: black; font-size: 12pt; }
.source		{ font-size: 10pt; }

.pebble h1              { font-family:verdana; font-size:12pt; color:purple; }
.pebble h2              { margin-left:20; font-family:verdana; font-size:11pt; 
                            color:purple; font-weight:800; }
.pebble h3              { margin-left:20; font-family:verdana; font-size:10pt; 
                            color:purple; font-style:italic; }
.pebble p,ul,ol,dl      { font-family:verdana; font-size:10pt; margin-left:20; }
.pebble td              { font-family:verdana; font-size:10pt; vertical-align:text-top; }
.pebble th              { font-family:verdana; font-size:10pt; font-weight:800;}
.pebble div,pre         { margin-left:20; }
.pebble code            { font-family:courier; font-size:8pt; color:green; }
</style>


<null --define-var = "timenow" $Bedrock.new("BLM::Timenow")>

<table cellpadding=0 border=0 width="100%">
<tr>
  <td align=left><img src="/img/bedbug.jpg" border=0></td>
</tr>

<tr>
  <td><i>Bedrock version:&nbsp;</i><b><var
  $Bedrock.version></b></td>
</tr>
<tr>
  <td ><i>Timestamp:&nbsp;</i><b><var $timenow.ctime></b></td>
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
