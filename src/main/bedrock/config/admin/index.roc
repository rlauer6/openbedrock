<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" type="text/css" />
    <script src="https://code.jquery.com/jquery-1.12.4.min.js" integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ=" crossorigin="anonymous"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
    </script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>

    <script src="bedrock.js"></script>
    <link rel="stylesheet" href="bedrock.css">
  </head>

  <if $input.action --eq 'register'>
    <null $session.register($input.username, $input.password,  $input.first_name, $input.last_name, $input.email)>
  <elsif $input.action --eq 'logout'>
    <null $session.logout()>
  <elsif $input.action --eq 'login'>
    <null $session.login($input.username, $input.password)>
  </if>
  
  <body class="p-3 m-0 border-0 m-0 border-0">
    <nav class="navbar navbar-expand-lg bg-body-tertiary">
      <div class="container-fluid">
        <a class="navbar-brand" href="#">
          <img src="/bedrock/img/bedrock.gif" alt="Bedrock">
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                Documentation
              </a>
              <ul class="dropdown-menu">
                <li><a class="dropdown-item" id="tag-link" href="#">Tags</a></li>
                <li><a class="dropdown-item" href="#">Plugins</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="#">Bedrock Modules</a></li>
                <li><a class="dropdown-item" href="#">Installed Perl Modules</a></li>
              </ul>
            </li>
            <li class="nav-item">
              <a href="#" class="nav-link <if $config.ALLOW_BEDROCK_ENV_INFO --eq 'no'>disabled aria-disabled=\"true\"</if>">Environment</a>
            </li>
            <li class="nav-item">
              <a href="#" class="nav-link <if $config.ALLOW_BEDROCK_CONFIG_INFO --eq 'no'>disabled aria-disabled=\"true\"</if>">Configuration</a>
            </li>
            <li class="nav-item">
              <a href="#" id="login-link" class="nav-link"><iif $session.username Logout Login></a>
            </li>
            <li class="nav-item">
              <a href="#" id="register-link" class="nav-link">Register</a>
            </li>
            <li class="nav-item">
              <a href="#" id="session-link" class="nav-link">Session</a>
            </li>
          </ul>
          <form class="d-flex">
            <input class="form-control me-2" id='module-name' name="module" type="search" placeholder="Search" aria-label="Search">
            <input type="hidden" name="external" value="1">
            <button id="module-search" class="btn btn-outline-success" type="submit">Search</button>
          </form>
        </div>
      </div>
    </nav>

    <div id="top-container">
      <div id="bedrock-error" role="alert">
        <span id="bedrock-error-message"></span>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>

      <div id="plugins-container">
        <div class="accordion accordion-flush" id="plugins-content">

          <div class="accordion-item">
            <h2 class="accordion-header">
              <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#application-plugins" aria-expanded="false" aria-controls="application-plugins">
                Application Plugins
              </button>
            </h2>

            <div id="application-plugins" class="accordion-collapse collapse" data-bs-parent="#plugins-content">
              <div class="accordion-body">
              </div>
            </div>
          </div>

          <div class="accordion-item">
            <h2 class="accordion-header">
              <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#filters" aria-expanded="false" aria-controls="filters">
                Filters
              </button>
            </h2>

            <div id="filters" class="accordion-collapse collapse" data-bs-parent="#plugins-content">
              <div class="accordion-body">
              </div>
            </div>
          </div>

          <div class="accordion-item">
            <h2 class="accordion-header">
              <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#plugins" aria-expanded="false" aria-controls="plugins">
                Plugins
              </button>
            </h2>

            <div id="plugins" class="accordion-collapse collapse" data-bs-parent="#plugins-content">
              <div class="accordion-body">
              </div>
            </div>
          </div>

        </div>
      </div>

      <button id="top-button" class="btn btn-primary btn-sm mb-2" type="button">Top</button>
      <div id="tags-container">
      </div>

      <div class="container" id="login-container">
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
                  <button type="button" id="<iif $session.username logout login >-button" class="btn btn-primary"><iif $session.username Logout Login></button>
                </div>
              </div>
              <input type="hidden" name="action" id="login-action" value="">
            </form>
          </div>
        </div>
      </div>

      <div class="container" id="register-container">
        <div class="row mt-4">
          <div class="col-12">
            <form id='register-form' action="session.roc" method="post">
              
              <div class="row mt-4">
                <div class="col-4">
                  <span id="register-username-label">Username</span>
                </div>
                <div class="col-4">
                  <input id="register-username" type="text" name="register-username" size="16" maxlength="30" tabindex="200">
                </div>
              </div>
              
              <div class="row mt-2">
                <div class="col-4">
                  <span id="register-password-label">
                    <a href="#" class="link-opacity-0 m-0"  data-bs-toggle="tooltip" data-bs-title="Passwords should contain at least 1 digit, special character, number, lower and uppercase letter">Password</a></span>
                  </div>
                <div class="col-4">
                  <input id="register-password" type="password" name="register-password" size="16" maxlength="30" tabindex="201">
                </div>
              </div>
              
              <div class="row mt-4">
                <div class="col-4">
                  <span id="first_name-label">First Name</span>
                </div>
                <div class="col-4">
                  <input id="first_name" type="text" name="first_name" size="16" maxlength="30" tabindex="202">
                </div>
              </div>
              
              <div class="row mt-2">
                <div class="col-4">
                  <span id="last_name-label">Last Name</span>
                </div>
                <div class="col-4">
                  <input id="last_name" type="text" name="last_name" size="16" maxlength="30" tabindex="203">
                </div>
              </div>
              
              <div class="row mt-2">
                <div class="col-4">
                  <span id="email-label">E-Mail</span>
                </div>
                <div class="col-4">
                  <input id="email" type="text" name="email" size="16" maxlength="100" tabindex="204">
                </div>
              </div>
              
              <div class="row mt-4">
                <div class="col-4 offset-4">
                  <button type="button" id="register-button" class="btn btn-primary">Register</button>
                </div>
              </div>
              <input type="hidden" name="action" value="register">
            </form>
          </div>
        </div>
      </div>
      
      <div id="session-container">
        <pre>
          <trace --output $session>
        </pre>
      </div>
    </div>
  </body>
</html>
