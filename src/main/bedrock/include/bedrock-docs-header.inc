<table width="100%" id="bedrock-docs-header" class="bedrock-docs">
  <tr>
    <td align="middle" align="left">
      <a href="<var $back_url>"><img src="<var $logo>" border="0"></a>
    </td>
    <td align="right" valign="middle" width="9999">
      <i>Bedrock Version: <var $version></i>
    </td>
  </tr>
  <tr>
    <td colspan="2" align="left" valign="bottom" width="9999">
      <form style="margin-top:0; margin-bottom:0;" action="/bedrock/pod" method="GET">
        <input type="text" placeholder="Module name" name="module" size="30">&nbsp;<input type="submit" value="Search:">
        <input type="hidden" name="external" value="1">
      </form>
    </td>
  </tr>
  
  <tr>
    <td colspan="2"><hr></td>
  </tr>
</table>

<if $module>
  <h2><var $module></h2>
</if>
