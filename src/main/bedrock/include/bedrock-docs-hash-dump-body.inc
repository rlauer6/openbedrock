<div class="bedrock-hash">
  <foreach $hash.sorted()>

    <div class="bedrock-hash-row">
      <div class="bedrock-hash-key">
        <code><var $key></code>
      </div>
      <div class="bedrock-hash-value">
        <if --ref $value>
          <pre><var $value.compact()></pre>
        <else>
          <null:value $value.chomp()>
          <if $value><pre><var $value.chomp()></pre></if>
        </if>
      </div>
    </div>
  </foreach>
</div>
