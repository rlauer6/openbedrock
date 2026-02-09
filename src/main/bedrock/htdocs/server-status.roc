<html>
  <head>
    <title>Bedrock Server Status</title>
    <link rel="stylesheet" href="/bedrock/css/server-status.css" />
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('h2').forEach(header => {
          header.addEventListener('click', () => {
            header.classList.toggle('collapsed');
            const content = header.nextElementSibling;
            if (content.style.display === 'none') {
              content.style.display = 'block';
            } else {
              content.style.display = 'none';
            }
          });
        });
      });
    </script>
  </head>

  <body>
    <h1>Bedrock Server Status</h1>

    <div>
      <span class="tag">Version: <var $version></span>
      <span class="tag tag-active">Uptime: <var $uptime></span>
    </div>
    
    <h2 class="collapsed">Service Registry</h2>
    <div class="content-wrapper" style="display:none">
      <table>
        <foreach $registry>
          <tr>
            <td><code><var $key></code></td>
            <td><span class="code-ref"><var --ref $value></span></td>
          </tr>
        </foreach>
      </table>
    </div>
    
    <h2 class="collapsed">MIME Type Mappings</h2>
    <div class="content-wrapper" style="display:none">
      <table>
        <foreach $mime_types>
          <tr>
            <td><code>.<var $key></code></td>
            <td><var $value></td>
          </tr>
        </foreach>
      </table>
    </div>

    <h2 class="collapsed">Static Asset Aliases</h2>
    <div class="content-wrapper" style="display:none">
      <table>
        <thead>
          <tr><th>URL Prefix</th><th>Physical Path</th></tr>
        </thead>
        <tbody>
          <foreach $runtime.aliases>
            <tr>
              <td><code><var $key></code></td>
              <td><var $value></td>
            </tr>
          </foreach>
        </tbody>
      </table>
    </div>
    
    <h2 class="collapsed">Environment Variables</h2>
    <div class="content-wrapper" style="display:none">
      <table>
        <foreach $env>
          <unless $key --re '/PASS|SECRET|KEY|TOKEN/'>
            <tr>
              <td><var $key></td>
              <td><var $value></td>
            </tr>
          </unless>
        </foreach>
      </table>
    </div>

    <h2 class="collapsed">Bedrock Extensions</h2>
    <div class="content-wrapper" style="display:none">
      <ul>
        <foreach $template_extensions>
          <li><code>.<var $key></code></li>
        </foreach>
      </ul>
    </div>
    
    <h2 class="collapsed">Global Overrides</h2>
    <div class="content-wrapper" style="display:none">
      <table>
        <foreach $overrides>
          <tr>
            <td><var $key></td>
            <td><var $value></td>
          </tr>
        </foreach>
      </table>
    </div>

    <h2 class="collapsed">Active Resource Routes</h2>
    <div class="content-wrapper" style="display:none">
      <foreach $runtime.routes>
        <div class="route-group">
          <h3>Mount Point: <code><var $key></code></h3>
          <table>
            <thead>
              <tr><th>Pattern</th><th>Target Template</th></tr>
            </thead>
            <tbody>
              <foreach $value>
                <tr>
                  <if $value --re '/HASH/'>
                    <td><code><var $value.pattern></code></td>
                    <td><var $value.template></td>
                  <else>
                    <td><code><var $key></code></td>
                    <td><var $value></td>
                  </if>
                </tr>
              </foreach>
            </tbody>
          </table>
        </div>
      </foreach>
    </div>

  </body>
</html>
