<var $head>
    <foreach $groups.pairs()>
      <h2><var $_.key></h2>
      <ul class="bedrock-index">
      <foreach $_.value>
        <li><a href="<var $admin_dir>/tag/<var $_>"><var $_></a></li>
      </foreach>
      </ul>
   </foreach>
  </body>
</html>
