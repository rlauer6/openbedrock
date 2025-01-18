<div class="row mt-4">
  <div class="col-12">
    <form id='login-form' action="index.roc" method="post">
      <div class="row m-2">
        <div class="col-4">
          <span id="username-label"><a href="#" class="m-0" data-bs-toggle="tooltip" data-bs-title="Enter your username, not your email!">Username</a></span>
        </div>
        <div class="col-4">
          <input id="username" name="username" class="w-20" value="<var $session.username>">
        </div>
      </div>

      <div class="row m-2">
        <div class="col-4">
          <span id="password-label">Password</span>
        </div>
        <div class="col-4">
          <input type="password" id="password" name="password" class="w-20">
        </div>
      </div>

      <div class="row mt-4">
        <div class="col-4 offset-4">
          <button type="button" id="<iif $session.username logout login >-button" class="btn btn-primary">
            <iif $session.username Logout Login/>
          </button>
        </div>
      </div>
      <input type="hidden" name="action" id="login-action" value="">
    </form>
  </div>
</div>
