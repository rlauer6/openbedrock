<html>
  <head>
    <title>Bedrock Error</title>
    <link rel="stylesheet" href="<var $config.BEDROCK_SOURCE_CSS_URL>" type="text/css" />
    <plugin:Timenow>
    
    <style>
      body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        background-color: #f4f7f6;
        color: #333;
        margin: 0;
        padding: 40px;
      }

      .container {
        max-width: 900px;
        margin: 0 auto;
        background: #ffffff;
        border-radius: 12px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        overflow: hidden;
      }

      /* Header Section */
      .header {
        background-color: #ffffff;
        padding: 20px 40px;
        text-align: center;
        border-bottom: 4px solid #e74c3c;
      }

      .header img.logo {
        max-width: 250px;
        height: auto;
        display: block;
        margin: 0 auto 10px auto;
      }

      .meta {
        color: #555;
        font-size: 0.85rem;
        opacity: 0.8;
      }

      /* Hero Section with Caveman */
      .hero {
        display: flex;
        align-items: flex-start;
        padding: 40px;
        gap: 30px;
        background-color: #fff5f5;
        border-bottom: 1px solid #eee;
      }

      .caveman-wrapper {
        flex: 0 0 150px;
        text-align: center;
      }

      .caveman-wrapper img {
        width: 100%;
        height: auto;
        transform: rotate(-5deg);
      }

      .error-content {
        flex: 1;
      }

      h1 {
        margin: 0 0 15px 0;
        color: #c0392b;
        font-size: 2rem;
      }

      .error-box {
        background: #ffffff;
        border: 2px solid #f5c6cb;
        border-radius: 6px;
        padding: 20px;
        font-family: 'Consolas', 'Monaco', monospace;
        color: #721c24;
        font-size: 1.1em;
        line-height: 1.5;
        box-shadow: 0 2px 4px rgba(0,0,0,0.03);
      }

      /* Stack Trace Section */
      .stack-trace {
        padding: 40px;
      }

      h2 {
        font-size: 1.2rem;
        color: #555;
        border-bottom: 2px solid #eee;
        padding-bottom: 10px;
        margin-top: 0;
      }

      .trace-item {
        margin-bottom: 25px;
        border: 1px solid #e0e0e0;
        border-radius: 6px;
        overflow: hidden;
      }

      .trace-header {
        background: #f8f9fa;
        padding: 10px 15px;
        border-bottom: 1px solid #e0e0e0;
        font-family: 'Consolas', 'Monaco', monospace;
        font-size: 0.9rem;
        color: #555;
      }

      .trace-file {
        color: #2980b9;
        font-weight: bold;
      }

      .trace-line {
        color: #e74c3c;
        font-weight: bold;
      }

      /* FIXED: Using pre tag to preserve whitespace/newlines */
      pre.code-view {
        padding: 15px;
        background: #fff;
        overflow-x: auto;
        font-size: 0.9rem;
        margin: 0;
        font-family: 'Consolas', 'Monaco', monospace;
      }

      /* Original Bedrock Doc Links */
      a { color: #2980b9; text-decoration: none; }
      a:hover { text-decoration: underline; }
      
      /* Utilities */
      .pebble { font-weight: bold; color: #27ae60; }
    </style>
  </head>

  <body>
    <div class="container">
      
      <div class="header">
        <img src="/bedbug.png" alt="Bedrock" class="logo">
        <div class="meta">
          Version: <var $bedrock.version()> &nbsp;&bull;&nbsp; 
          Timestamp: <var $Timenow.ctime>
        </div>
      </div>

      <div class="hero">
        <div class="caveman-wrapper">
          <img src="/caveman.png" alt="Yabba Dabba Oops!">
        </div>
        <div class="error-content">
          <h1>Yabba Dabba Oops!</h1>
          <div class="error-box">
            <null:msg $ERROR.mesg()>
            
            <if $msg --re "^(PebbleDoc|BedrockDoc|BLMDoc)">
              <span class="pebble"><var $msg.replace("^(PebbleDoc|BedrockDoc|BLMDoc)")></span>
            <elseif $msg --re "^(PebbleDocRef|BedrockDocRef|BLMDocRef)">
              <a href="<var $msg.replace(q{(.*?):\s*})>"><var $msg></a>
            <else>
              <var --HTMLEncode $ERROR.mesg()>
            </if>
          </div>
        </div>
      </div>

      <div class="stack-trace">
        <h2>Stack Trace</h2>
        
        <foreach --define-index="i" $ERROR>
          <div class="trace-item">
            <div class="trace-header">
              <span class="trace-file"><var $file></span> : Line <span class="trace-line"><var --default="???" $line></span>
            </div>
            
            <pre class="code-view"><var $ERROR.view_source($i, "context", 2, "compact", 0)></pre>
          </div>
        </foreach>
      </div>

    </div>
  </body>
</html>
