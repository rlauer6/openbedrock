<!DOCTYPE html>
<include "handler.inc" />
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

  <body class="p-3 m-0 border-0 m-0 border-0">
    <nav class="navbar navbar-expand-lg bg-body-tertiary">
      <div class="container-fluid">
        <a id="bedrock-logo" class="navbar-brand" href="#">
          <img src="/bedrock/img/bedrock.gif" alt="Bedrock">
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false"
                aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                Documentation
              </a>
              <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="#tags" data-bedrock="tags">Tags</a></li>
                <li><a class="dropdown-item" href="#plugins" data-bedrock="plugins">Plugins</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="#bedrock-modules" data-bedrock="bedrock-modules">Bedrock Modules</a></li>
                <li><a class="dropdown-item" href="#perl-modules" data-bedrock="perl-modules">Installed Perl Modules</a></li>
              </ul>
            </li>
            <li class="nav-item">
              <a href="#environment" data-bedrock="environment" class="nav-link <if $config.ALLOW_BEDROCK_ENV_INFO --eq 'no'>disabled aria-disabled=\"true\"</if>">Environment</a>
            </li>
            <li class="nav-item">
              <a href="#configuration" data-bedrock="configuration" class="nav-link <if $config.ALLOW_BEDROCK_CONFIG_INFO --eq 'no'>disabled aria-disabled=\"true\"</if>">Configuration</a>
            </li>
            <li class="nav-item">
              <a href="#login" id="login-link" class="nav-link" data-bedrock="login"><iif $session.username Logout Login></a>
            </li>
            <li class="nav-item">
              <a href="#register" id="register-link" class="nav-link" data-bedrock="register">Register</a>
            </li>
            <li class="nav-item">
              <a href="#session" id="session-link" class="nav-link" data-bedrock="session">Session</a>
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

    <div id="bedrock-error" role="alert">
      <span id="bedrock-error-message"></span>
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>

    <div id="abs-top"></div>
    <div id="body-container" class="container">
      <div class="row">
        <div class="col-auto">
          <div class="list-group">
            <a href="#welcome" class="list-group-item list-group-item-action active" data-bedrock="welcome">Welcome</a>
            <a href="#examples" class="list-group-item list-group-item-action" bedrock-data="examples">Examples</a>
            <a href="#tutorials" class="list-group-item list-group-item-action" bedrock-data="tutorials">Tutorials</a>
            <a href="#bedrock-shell" class="list-group-item list-group-item-action" bedrock-data="bedrock-shell">Bedrock Shell</a>
            <a href="#contributing" class="list-group-item list-group-item-action" bedrock-data="contributing">Contributing</a>
            <a href="#bugs" class="list-group-item list-group-item-action" bedrock-data="bugs">Reporting Bugs</a>
          </div>
        </div>

        <div class="col">
          <div id="register-container" class="container"><include "register-container"/></div>
          <div id="docs-container" class="container side-menu-item bedrock-pod" ></div>
          <div id="tags-container" class="container bedrock-pod"></div>
          <div class="container" id="session-container"></div>
          <div class="container" id="login-container"><include "login-container" /></div>
          <div class="container" id="plugins-container"><include "plugins-container" /></div>
        </div>
      </div>
    </div>
    
    <footer class="fixed-bottom p-3 bg-dark-subtle">
      <span class="text-muted">Bedrock Version <var $bedrock.version()></span>
    </footer>
  </body>
</html>
