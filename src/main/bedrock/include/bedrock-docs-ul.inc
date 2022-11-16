<ul class="bedrock-docs">
 <foreach $links>
 <if $value --re '/disabled/' >
   <li><var $value></li>
 <else>
   <li><a href="<var $url>/<var $key>"><var $value></a></li>
 </if>
 </foreach>
</ul>
