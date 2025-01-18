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

      <div id="abs-top"></div>
      <span id="top-button">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-up-circle-fill" viewBox="0 0 16 16">
          <path d="M16 8A8 8 0 1 0 0 8a8 8 0 0 0 16 0m-7.5 3.5a.5.5 0 0 1-1 0V5.707L5.354 7.854a.5.5 0 1 1-.708-.708l3-3a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 5.707z"/>
        </svg>
      </span>
      <span id="back-button">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-left-circle-fill" viewBox="0 0 16 16">
          <path d="M8 0a8 8 0 1 0 0 16A8 8 0 0 0 8 0m3.5 7.5a.5.5 0 0 1 0 1H5.707l2.147 2.146a.5.5 0 0 1-.708.708l-3-3a.5.5 0 0 1 0-.708l3-3a.5.5 0 1 1 .708.708L5.707 7.5z"/>
        </svg>
      </span>

      <div id="left-menu-container">
        <div class="row">
          <div class="col-auto">
            <div class="list-group">
              <a href="#" class="list-group-item list-group-item-action active" bedrock-data="welcome">Welcome</a>
              <a href="#" class="list-group-item list-group-item-action" bedrock-data="examples">Examples</a>
              <a href="#" class="list-group-item list-group-item-action" bedrock-data="bedrock-shell">Bedrock Shell</a>
              <a href="#" class="list-group-item list-group-item-action" bedrock-data="contributing">Contributing</a>
              <a href="#" class="list-group-item list-group-item-action" bedrock-data="bugs">Reporting Bugs</a>
            </div>
          </div>
          <div id='right-content' class="col" >
            <div id="docs-container" class="side-menu-item bedrock-pod" ></div>
            <div id="tags-container" class="bedrock-pod"></div>
            <div id="session-container"></div>
            <div class="container" id="login-container">
              <include "login-container" />
            </div>
            <div class="container" id="register-container">
              <include "register-container"/>
            </div>
            
            <div id="plugins-container">
              <include "plugins-container" />
            </div>
          </div>
        </div>
      </div>


      
      <footer class="fixed-bottom p-3 bg-dark-subtle">
        <span class="text-muted">Bedrock Version <var $bedrock.version()></span>
      </footer>
    </div>
  </body>
</html>
