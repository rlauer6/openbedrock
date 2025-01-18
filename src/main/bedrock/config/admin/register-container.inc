<sink->
  <if $input.action --eq 'register'>
    <null $session.register($input.get('register-username'), $input.get('register-password'),  $input.first_name, $input.last_name, $input.email)>
  <elsif $input.action --eq 'logout'>
    <null $session.logout()>
  <elsif $input.action --eq 'login'>
    <null $session.login($input.username, $input.password)>
  </if>
</sink>
