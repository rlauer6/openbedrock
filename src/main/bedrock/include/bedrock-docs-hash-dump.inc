<var $head>
    <table cellpadding="0" cellspacing="0" border="0">
    <foreach $hash>
      <tr>
        <th valign="middle" align="right"><code class="bedrock-config-var"><var $key></code>&nbsp;</th>
        <if --ref $value>
        <td valign="bottom"><pre class="bedrock-config"><var $value.compact()></pre></td>
        <else>
        <td valign="bottom"><pre class="bedrock-config"><var $value></pre></td>
        </if>
      </tr>
    </foreach>
    </table>
  </body>
</html>
