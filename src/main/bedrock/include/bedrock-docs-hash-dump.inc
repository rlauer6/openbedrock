<var $head>
    <table class="bedrock-hash">
    <foreach $hash>
      <tr>
        <th><code class="bedrock-hash-key"><var $key></code>&nbsp;</th>
        <if --ref $value>
        <td><pre class="bedrock-hash-value"><var $value.compact()></pre></td>
        <else>
        <td><pre class="bedrock-hash-value"><var $value></pre></td>
        </if>
      </tr>
    </foreach>
    </table>
  </body>
</html>
