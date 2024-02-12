<table width="100%" id="bedrock-docs-header" class="bedrock-docs">
  <tr>
    <td rowspan="2" align="left">
      <a href="<var $back_url>"><img src="<var $logo>" border="0"></a>
    </td>
  </tr>
  <tr>
    <td align="right" valign="bottom" width="9999">
      <i>Bedrock Version: <var $version></i>
    </td>
  </tr>
  <tr>
    <td colspan="2" align="right" valign="bottom" width="9999">
      <form action="/bedrock/pod" method="GET">
        <input type="text" name="module" size="30">&nbps;<input type="submit" value="Search:">
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
