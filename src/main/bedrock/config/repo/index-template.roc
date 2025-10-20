<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Bedrock CPAN Repository</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>

    <script src="/javascript/bedrock-repo.js"></script>
    <link rel="stylesheet" href="/css/bedrock-repo.css" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
  </head>
  
  <body>
    <div style="margin-bottom:20px;">
      <img src="/img/bedrock.png">
    </div>

    <h1>Bedrock CPAN Repository</h1>
    <p>
      This is the official DarkPAN for Bedrock. Here you will find
      Bedrock and other Perl modules that support Bedrock, including
      plugins.
    </p>  
    <p>
      To download files from this repository:
      <div class="pre-wrapper">
        <pre id="copy-source">export PERL_CPANM_OPT="--mirror-only --mirror https://cpan.openbedrock.net/orepan2 --mirror https://cpan.metacpan.org"
cpanm -v Bedrock</pre>
        <span class="material-symbols-outlined copy-icon">copy_all</span>
        <div class="copy-message">Copied!</div>
      </div>
      
    </p>

    <hr>
    <h1>About This Site</h1>
    
    <p class="about">
      This site was generated using the
      <a href="https://github.com/rlauer6/s3-static-website.git">s3-static-website</a>
      and <a href="https://github.com/rlauer6/OrePAN2-S3.git">OrePAN2-S3</a>
      projects that you can find on GitHub. Perl distribution tarballs for
      Bedrock and Bedrock plugins are uploaded to this site using the
      <code>orepan2-s2></code> script.
    </p>

    <p class="about">
      The script updates the DarkPAN repo's index and tries to find
      some useful documentation that might exist in tarball. If
      there's a `README.html` file in the tarball, the script will
      extract it, convert it to HTML and provide a link to the
      README. The script will also look for some pod in plugin
      modules, convert that to HTML and provide a second link to the
      pod.
    </p>

    <p class="about">
      Links embedded in the pod will point to Bedrock's documentation
      server running in your localhost environment on port 8080. If
      you want to change the local url enter a new one below. <strong>If you
      are not running Bedrock in a local environment URLs in the
      documentation will not resolve properly.</strong>
    </p>

    <div id="base-url-config" style="margin: 1em 0; padding: 0.5em; border: 1px solid #ccc; border-radius: 4px; background: #f9f9f9;">
      <label for="doc-base-url"><strong>Local framework URL:</strong></label>
      <input type="text" id="doc-base-url" placeholder="http://localhost:8080" style="width: 300px; margin-left: 0.5em;">
      <button id="save-doc-base-url">Save</button>
      <span id="url-save-status" style="margin-left: 1em; color: green;"></span>
    </div>

    <h1>Other Bedrock Resources</h1>
    <ul class="checkmark">
      <li><a href="https://github.com/rlauer6/openbedrock.git">Bedrock's GitHub Repository</a></li>
      <li><a href="https://hub.docker.com/r/rlauer/openbedrock">Docker Images</a></li>
      <li><a href="https://github.com/rlauer6/openbedrock/wiki">Wiki</a></li>
      <li><a href="https://github.com/rlauer6/bedrock-plugin-template.git">Bedrock Plugin Template</a></li>
    </ul>

    <hr>

    <h1>Module Index</h1>
    
[% FOREACH distribution = repo.sort %]
      <h2>
       <span class="collapse-section-icon">&#9660;</span>
       [% distribution %]
       [% IF readme_links.$distribution %]
       <a title="README" class='doc-link' href="[% readme_links.$distribution %]"><span class="material-symbols-outlined">docs</span></a>
       [% END %]
       [% IF pod_links.$distribution %]
       <a title="pod" class='doc-link' href="[% pod_links.$distribution %]"><span class="material-symbols-outlined">docs</span></a>
       [% END %]
      </h2>
      <ul class="collapsable" id="[% utils.module_name(distribution) %]">
[% FOREACH module IN repo.$distribution %]
        <li>[%  module.0 %]</li>
[% END %]
      </ul>
[% END %]
   <hr>

    <h1>Application Plugin Index</h1>
    
[% FOREACH distribution = app_plugins.sort %]
      <h2>
       <span class="collapse-section-icon">&#9660;</span>
       [% distribution %]
       [% IF readme_links.$distribution %]
       <a title="README"  class='doc-link' href="[% readme_links.$distribution %]"><span class="material-symbols-outlined">docs</span></a>
       [% END %]
       [% IF pod_links.$distribution %]
       <a title="pod" class='doc-link' href="[% pod_links.$distribution %]"><span class="material-symbols-outlined">docs</span></a>
       [% END %]
      </h2>

      <ul class="collapsable" id="[% utils.module_name(distribution) %]">
[% FOREACH module IN app_plugins.$distribution %]
        <li>[%  module.0 %]</li>
[% END %]
      </ul>
[% END %]
   <hr>

   <h1>Plugin Index</h1>
    
[% FOREACH distribution = plugins.sort %]
     <h2>
       <span class="collapse-section-icon">&#9660;</span>

       [% distribution %]
       [% IF readme_links.$distribution %]
       <a title="README" class='doc-link' href="[% readme_links.$distribution %]"><span class="material-symbols-outlined">docs</span></a>
       [% END %]
       [% IF pod_links.$distribution %]
       <a title="pod" class='doc-link' href="[% pod_links.$distribution %]"><span class="material-symbols-outlined">docs</span></a>
       [% END %]
      </h2>

      <ul class="collapsable" id="[% utils.module_name(distribution) %]">
[% FOREACH module IN plugins.$distribution %]
        <li>[%  module.0 %]</li>
[% END %]
      </ul>
[% END %]
   <hr>

   <address>Generated on [% localtime %]</address>
</body>
</html>

