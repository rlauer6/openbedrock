<div class="row">
  <div class="col-12">
    <form id='register-form' action="index.roc" method="post">
      
      <div class="row mt-2">
        <div class="col-2 d-flex justify-content-end">
          <span id="register-username-label">Username</span>
        </div>
        <div class="col">
          <input id="register-username" type="text" name="register-username" size="16" maxlength="30" tabindex="200">
        </div>
      </div>
      
      <div class="row mt-2">
        <div class="col-2 d-flex justify-content-end">
          <span id="register-password-label">
            <a href="#" class="link-opacity-0 m-0" data-bs-toggle="tooltip" data-bs-title="Passwords should contain at least 1 digit, special character, number, lower and uppercase letter">Password</a>
          </span>
        </div>
        <div class="col">
          <input id="register-password" type="password" name="register-password" size="16" maxlength="30" tabindex="201">
        </div>
      </div>
      
      <div class="row mt-2">
        <div class="col-2 d-flex justify-content-end">
          <span id="first_name-label">First Name</span>
        </div>
        <div class="col">
          <input id="first_name" type="text" name="first_name" size="16" maxlength="30" tabindex="202">
        </div>
      </div>
      
      <div class="row mt-2">
        <div class="col-2 d-flex justify-content-end">
          <span id="last_name-label">Last Name</span>
        </div>
        <div class="col">
          <input id="last_name" type="text" name="last_name" size="16" maxlength="30" tabindex="203">
        </div>
      </div>
      
      <div class="row mt-2">
        <div class="col-2 d-flex justify-content-end">
          <span id="email-label">E-Mail</span>
        </div>
        <div class="col">
          <input id="email" type="text" name="email" size="16" maxlength="100" tabindex="204">
        </div>
      </div>
      
      <div class="row mt-2">
        <div class="col-2"></div>
        <div class="col">
          <button type="button" id="register-button" class="btn btn-primary">Register</button>
        </div>
      </div>
      <input type="hidden" name="action" value="register">
    </form>
  </div>
</div>
