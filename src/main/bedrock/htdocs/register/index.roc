<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Login or Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="/register/register.css" />
    <script src="/register/register.js"></script>

    <script>
      <if $input.token>
        <null $session.cookieless_session($input.token) />
      </if>

      var token    = "<var $input.token>";
      var username = "<var $input.username>";

      var password_changed;
      var registered;
      var login_error;
      var email_sent;
      var user;
      var action;

      <if $input.logout>
        action="logout";
        <null $session.logout()>
      <elseif $input.forgot_password>
        action="forgot-password";
      <elseif $input.token>
        action="reset-password";
      </if>

      // done after, because we might have logged out
      var session  = <var --json $session>;

      <if $input.forgot_password --eq '1'>
        <if $input.username>
          <null:user $session.lookup_user($input.username, 1) />
          user = <if $user><var --json $user><else>""</if>;

          <if $user --and $user.email>

            <null:register $config.register />

            <null:token $session.create_temp_login_session($input.username) />

            <plugin:SMTP $register.smtp_host $register.smtp_from $user.email />

            <null $SMTP.subject("Password Reset") />

            <sink $SMTP>
              Follow the link below to reset your password:
              <null:reset_link '%s/register/index.roc?token=%s&username=%s' />
              <var $reset_link.sprintf($register.host, $token, $input.username)>
            </sink>

            email_sent = 1;
          </if>
        </if>
      </if>

      <if $input.reset_password >
        <if --not $session.username >
          
        <elseif $input.password --eq $input.confirm_password>
          <null $session.change_passwd('', $input.password) />
          password_changed = 1;
        <elseif ($input.password --and  ( $input.password --ne $input.confirm_password))>
          password_changed = -1;
        </if>
      </if>

      <try>
        <if $input.username --and $input.password>
          <null $session.register($input.username, $input.password, $input.firstname, $input.lastname, $input.email) />
          registered = 1;
        </if>
      <catch>
        console.log("<var $@>");

        <if $session.username --ne $input.username>
          <try>
            <null $session.login($input.username, $input.password)>
            <null $header.location("/register/index.roc")>
          <catch>
            login_error = "Unknown user or bad password";
          </try>
        <else>
          login_error = "<var $@>";
        </if>
      </try>
        
    </script>
  </head>
  
  <body>
    <h1 class="text-center mb-4">Login</h1>

    <div class="d-none alert alert-danger alert-dismissible fade" id="alert-message-container" role="alert">
      <p id="alert-message"></p>
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>

    <div class="session d-none" id="login-message">
      <p class="text-end me-1"></p>
    </div>

    <div id="reset-password-container" class="d-none" >
      <form id="reset-password" action="" method="POST">
        <input type="password" name="password" class="form-control" placeholder="New password" />
        <input type="password" name="confirm_password" class="form-control" placeholder="Confirm password" />
        <input type="submit" value="Reset" class="btn btn-primary w-100" />
        <input type="hidden" name="reset_password" value="1" />
        <input type="hidden" name="token" value="<var $input.token>" />
      </form>

      <a class="btn btn-primary d-none" href="?username=<var $input.username>">Login</a>
    </div>

    <div id="login-form-container" class="d-none">
      <form id="login_form" method="POST">
        <input type="text" name="username" class="form-control" placeholder="Username" value="<var $input.username>">
        <input type="password" name="password" class="form-control" placeholder="Password">
        <input type="text" id="email" name="email" class="form-control" placeholder="Email">
        <input type="text" name="firstname" class="form-control" placeholder="First Name">
        <input type="text" name="lastname" class="form-control" placeholder="Last Name">
        <input type="submit" class="btn btn-success w-100" value="Register or Login">
        <input type="hidden" id="forgot_password" name="forgot_password" value="0">
        <div class="form-text text-end">
          <a class="btn btn-link" href="#" id="forgot_link">Forgot Password?</a>
        </div>
        </form>
    </div>

    <div class="session d-none" id="session-container">
      <h2 class="notes-heading text-primary fw-semibold mt-1 mb-3 border-bottom pb-2">Session</h2>
      <pre class="mt-3 session" id="session-message"></pre>
      <a class="btn btn-secondary" href="?logout=1">Logout</a>
    </div>

   <h2 class="notes-heading text-primary fw-semibold mt-3 mb-3 border-bottom pb-2">About The Login App</h2>
   
   <include register-notes />

   <div class="text-end me-1">Powered by Bedrock</div>
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>

</html>
