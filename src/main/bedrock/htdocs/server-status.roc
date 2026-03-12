<html>
  <head>
    <title>Bedrock Server Status</title>
    <link rel="stylesheet" href="/bedrock/css/server-status.css" />
    <style>
      @import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;600&family=IBM+Plex+Sans:wght@300;400;600&display=swap');

      *, *::before, *::after { box-sizing: border-box; }

      :root {
        --bg:        #0f1117;
        --bg-card:   #181c27;
        --bg-card2:  #1e2333;
        --border:    #2a3050;
        --amber:     #f5a623;
        --amber-dim: #7a5010;
        --green:     #4ade80;
        --blue:      #60a5fa;
        --muted:     #6b7a99;
        --text:      #cdd5e0;
        --text-bright: #f0f4ff;
        --mono:      'IBM Plex Mono', monospace;
        --sans:      'IBM Plex Sans', sans-serif;
      }

      body {
        background: var(--bg);
        color: var(--text);
        font-family: var(--sans);
        font-size: 15px;
        line-height: 1.6;
        margin: 0;
        min-height: 100vh;
      }

      /* ── Header ───────────────────────────────────────────── */
      .br-header {
        border-bottom: 1px solid var(--border);
        padding: 2rem 3rem;
        display: flex;
        align-items: center;
        gap: 2rem;
        background: linear-gradient(135deg, #0f1117 60%, #141824);
      }

      .br-header img {
        width: 100px;
        height: auto;
        filter: drop-shadow(0 0 18px rgba(245,166,35,0.35));
        flex-shrink: 0;
      }

      .br-header-text h1 {
        font-family: var(--mono);
        font-size: 1.75rem;
        font-weight: 600;
        color: var(--text-bright);
        letter-spacing: -0.02em;
        margin: 0;
      }

      .br-header-text h1 span { color: var(--amber); }

      .br-status-line {
        margin-top: 0.4rem;
        display: flex;
        align-items: center;
        gap: 1rem;
        font-family: var(--mono);
        font-size: 0.8rem;
        color: var(--muted);
        flex-wrap: wrap;
      }

      .br-pill {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        background: rgba(74,222,128,0.08);
        border: 1px solid rgba(74,222,128,0.25);
        color: var(--green);
        padding: 0.2rem 0.7rem;
        border-radius: 2rem;
        font-size: 0.75rem;
      }

      .br-pill::before {
        content: '';
        width: 6px;
        height: 6px;
        border-radius: 50%;
        background: var(--green);
        animation: pulse 2s ease-in-out infinite;
      }

      @keyframes pulse {
        0%, 100% { opacity: 1; }
        50%       { opacity: 0.3; }
      }

      .br-badge {
        background: var(--bg-card2);
        border: 1px solid var(--border);
        padding: 0.2rem 0.6rem;
        border-radius: 4px;
        font-size: 0.75rem;
        color: var(--text);
      }

      /* ── Main ─────────────────────────────────────────────── */
      .br-main {
        max-width: 1000px;
        margin: 0 auto;
        padding: 2rem 3rem;
      }

      /* ── Collapsible sections ─────────────────────────────── */
      .br-section {
        background: var(--bg-card);
        border: 1px solid var(--border);
        border-radius: 8px;
        overflow: hidden;
        margin-bottom: 1rem;
      }

      .br-section h2 {
        font-family: var(--mono);
        font-size: 0.8rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: var(--amber);
        padding: 0.75rem 1.25rem;
        margin: 0;
        background: var(--bg-card2);
        border-bottom: 1px solid var(--border);
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 0.6rem;
        user-select: none;
      }

      .br-section h2::after {
        content: '';
        display: inline-block;
        width: 6px;
        height: 6px;
        border-right: 2px solid var(--muted);
        border-bottom: 2px solid var(--muted);
        transform: rotate(45deg) translateY(-2px);
        margin-left: auto;
        flex-shrink: 0;
        transition: transform 0.2s;
      }

      .br-section h2.collapsed::after {
        transform: rotate(-45deg) translateY(1px);
      }

      .br-section-body {
        padding: 0.75rem 1.25rem;
      }

      /* ── Tables ───────────────────────────────────────────── */
      table {
        width: 100%;
        border-collapse: collapse;
        border: none;
        font-family: var(--mono);
        font-size: 0.8rem;
      }

      tr { border: none; }

      th {
        text-align: left;
        color: var(--muted);
        font-weight: 400;
        padding: 0.3rem 1.25rem;
        border: none;
        background: var(--bg-card2);
      }

      td {
        padding: 0.4rem 1.25rem;
        border: none;
        border-bottom: 1px solid var(--border);
        color: var(--text);
        vertical-align: top;
      }

      tr:last-child td { border-bottom: none; }

      .br-section-body { padding: 0.75rem 0; }

      td:first-child { color: var(--muted); }
      td code, th code { color: var(--text-bright); }

      .code-ref {
        color: var(--blue);
        font-size: 0.75rem;
      }

      /* ── Lists ────────────────────────────────────────────── */
      ul { list-style: none; padding: 0; margin: 0; }
      ul li {
        font-family: var(--mono);
        font-size: 0.8rem;
        padding: 0.3rem 0;
        border-bottom: 1px solid rgba(42,48,80,0.4);
        color: var(--text-bright);
      }
      ul li:last-child { border-bottom: none; }

      /* ── Route groups ─────────────────────────────────────── */
      .route-group { margin-bottom: 1rem; }
      .route-group h3 {
        font-family: var(--mono);
        font-size: 0.8rem;
        color: var(--muted);
        margin: 0 0 0.5rem;
        font-weight: 400;
      }

      /* ── Footer nav ───────────────────────────────────────── */
      .br-footer {
        margin-top: 1.5rem;
        display: flex;
        align-items: center;
        gap: 1rem;
        flex-wrap: wrap;
      }

      .br-nav-link {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.55rem 1.1rem;
        border-radius: 6px;
        font-family: var(--mono);
        font-size: 0.8rem;
        font-weight: 600;
        text-decoration: none;
        border: 1px solid;
        transition: background 0.15s;
      }

      .br-nav-link.primary {
        background: var(--amber);
        border-color: var(--amber);
        color: #0f1117;
      }

      .br-nav-link.primary:hover { background: #ffc04a; }

      .br-nav-link.secondary {
        background: transparent;
        border-color: var(--border);
        color: var(--text);
      }

      .br-nav-link.secondary:hover {
        background: var(--bg-card2);
        border-color: var(--muted);
      }

      .br-hint {
        margin-left: auto;
        font-family: var(--mono);
        font-size: 0.75rem;
        color: var(--muted);
      }

      .br-hint code {
        background: var(--bg-card2);
        padding: 0.15rem 0.4rem;
        border-radius: 3px;
        border: 1px solid var(--border);
      }
    </style>

    <script>
      document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('.br-section h2').forEach(header => {
          header.addEventListener('click', () => {
            header.classList.toggle('collapsed');
            const body = header.nextElementSibling;
            body.style.display = body.style.display === 'none' ? 'block' : 'none';
          });
        });
      });
    </script>
  </head>

  <body>

    <div class="br-header">
      <img src="/bedrock/img/bedrock-dino.png" alt="Bedrock">
      <div class="br-header-text">
        <h1>Bedrock <span>Server Status</span></h1>
        <div class="br-status-line">
          <span class="br-pill">running</span>
          <span class="br-badge">v<var $version></span>
          <span class="br-badge">uptime: <var $uptime></span>
          <span class="br-badge">port <var $runtime.port></span>
          <span class="br-badge">log: <var $runtime.log_level></span>
        </div>
      </div>
    </div>

    <div class="br-main">

      <div class="br-section">
        <h2 class="collapsed">Service Registry</h2>
        <div class="br-section-body" style="display:none">

            <table>
              <foreach $registry>
                <tr>
                  <td><code><var $key></code></td>
                  <td><span class="code-ref"><var $value></span></td>
                </tr>
              </foreach>
            </table>

        </div>
      </div>

      <div class="br-section">
        <h2 class="collapsed">Static Asset Aliases</h2>
        <div class="br-section-body" style="display:none">

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
      </div>

      <div class="br-section">
        <h2 class="collapsed">Directory Index</h2>
        <div class="br-section-body" style="display:none">

            <table>
              <foreach $runtime.directory_index>
                <tr>
                  <td><code><var $key></code></td>
                  <td><var $value.join(', ')></td>
                </tr>
              </foreach>
            </table>

        </div>
      </div>

      <div class="br-section">
        <h2 class="collapsed">Template Parsing</h2>
        <div class="br-section-body" style="display:none">

            <table>
              <foreach $template_extensions>
                <tr>
                  <td><code>.<var $key></code></td>
                </tr>
              </foreach>
            </table>

        </div>
      </div>

      <div class="br-section">
        <h2 class="collapsed">Active Resource Routes</h2>
        <div class="br-section-body" style="display:none">
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
    
  
          </foreach>
        </div>
      </div>

      <div class="br-section">
        <h2 class="collapsed">Environment</h2>
        <div class="br-section-body" style="display:none">

            <table>
              <foreach $runtime.env>
                <unless $key --re '/PASS|SECRET|KEY|TOKEN/'>
                  <tr>
                    <td><var $key></td>
                    <td><var $value></td>
                  </tr>
                </unless>
              </foreach>
            </table>

        </div>
      </div>

      <div class="br-section">
        <h2 class="collapsed">Global Overrides</h2>
        <div class="br-section-body" style="display:none">

            <table>
              <foreach $overrides>
                <tr>
                  <td><var $key></td>
                  <td><var $value></td>
                </tr>
              </foreach>
            </table>

        </div>
      </div>

      <div class="br-section">
        <h2 class="collapsed">MIME Types</h2>
        <div class="br-section-body" style="display:none">

            <table>
              <foreach $mime_types>
                <tr>
                  <td><code>.<var $key></code></td>
                  <td><var $value></td>
                </tr>
              </foreach>
            </table>

        </div>
      </div>

      <div class="br-footer">
        <a href="/bedrock" class="br-nav-link primary">Documentation</a>
        <a href="/" class="br-nav-link secondary">Home</a>
        <span class="br-hint">Edit <code>bedrock-miniserver.yml</code> to configure</span>
      </div>

    </div>

  </body>
</html>
