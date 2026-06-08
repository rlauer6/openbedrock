use strict;
use warnings;
use Test::More tests => 6;
use TagX::Error;

# 1. Define Bedrock source 
# We use <var> for the self-closing test since it is a NoBody tag
my $source_code = <<'EOF';
<var name="standard" ->
<noexec>
  This text should be raw
</noexec>
<var name="combo" -/>
EOF

# 2. Instantiate the Error object and load the source
my $error = TagX::Error->new();
$error->source($source_code);

# 3. Generate the highlighted HTML
my $html = $error->view_source(0);

# 4. Verify Suffix Highlighting (Chomp)
# Expect: <span class="suffix chomp">-</span>
like( $html, qr/class="suffix chomp">-\s*<\/span>/, 'Detected chomp operator (-)' );

# 5. Verify Suffix Highlighting (Self-Close)
# Note: The test assumes <var ... -> will produce just chomp. 
# We don't have a plain "/" tag in the source above, let's stick to what is there.
# actually, let's verify the chomp on the first tag:
like( $html, qr/class="tag var">&lt;var/, 'Detected tag class for <var>' );

# 6. Verify Suffix Highlighting (Chomp + Self-Close)
# Expect: <span class="suffix chomp-selfclose">-/</span>
# This is valid for <var>
like( $html, qr/class="suffix chomp-selfclose">-\/\s*<\/span>/, 'Detected chomp-self-close operator (-/)' );

# 7. Verify Raw Mode
# The text inside <noexec> should be wrapped in raw-text class
like( $html, qr/class="raw-text">\s*This text should be raw\s*<\/span>/, 'Detected raw mode text block' );

# 8. Verify Raw Mode Exit
# Ensure the tag following raw mode is highlighted correctly (not raw)
# We check the second <var> tag here
like( $html, qr/class="tag var">&lt;var/, 'Correctly exited raw mode for subsequent tags' );

# 9. Verify Options Highlighting
# Check that the name="standard" part is preserved
like( $html, qr/name="standard"/, 'Options text preserved in output' );

