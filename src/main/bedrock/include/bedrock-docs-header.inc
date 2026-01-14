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
      <form style="margin-top:0; margin-bottom:0;" action="/bedrock/pod">
        <input type="text" placeholder="Module name" name="module" size="30">&nbsp;
        <input type="submit" value="Search:"><br/>
        <label for="pod-only">Exclude modules without POD</label>
        <input id="pod-only" type="checkbox" onchange="updatePodSetting(this);" value="1" <if $session.pod_only>checked</if>>
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

<script>
function updatePodSetting(checkbox) {
    const value = checkbox.checked ? 1 : 0;
    
    // Calls the route: '/pod-only/:pod_only' => 'pod_only'
    fetch('/bedrock/pod-only/' + value, {
        method: 'GET',
        headers: {
            'Accept': 'application/json'
        }
    })
    .then(response => {
        if (!response.ok) {
            console.error('Failed to update pod-only setting');
        }
        // Optional: Reload the page if you want the listing to update immediately
        // window.location.reload(); 
    })
    .catch(error => console.error('Error:', error));
}
</script>
