<sink><null $session.create_session_dir()>

<sink:list>
 [ { "label" : "Bedrock", "value" : "1" },
   {  "label" : "Perl", "value" : "2"} ]
</sink>

<null $session.create_session_file("test.jroc", $list)>

</sink><var --json $session>
