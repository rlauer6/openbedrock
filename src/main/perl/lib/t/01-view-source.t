use strict;
use warnings;

use Test::More;
use TagX::Error;

# 1. Define a multi-line Bedrock source with a known "error" location
my $source_code = <<'EOF';
<var name="line1" ->
<var name="line2" ->
<var name="line3" -/>
<var name="line4" ->
<var name="line5" ->
EOF

# 2. Setup the Error object simulating a crash on Line 3
my $error = TagX::Error->new();
$error->source($source_code);
$error->line(3);  # <--- The crash happens here

# 3. Generate the view with 1 line of context
my $html = $error->view_source( 0, context => 1 );

# 4. DIAGNOSTIC CHECKS

# Check 1: Does it contain the error marker class?
# The original TagX::Error logic wraps the specific line number in <span class='error'>
like( $html, qr/class='error'>\s*3\|/, 'Error line (3) is explicitly marked with error class' );

# Check 2: Context lines (Upper and Lower)
# We asked for 1 line of context, so line 2 and 4 should be visible, but NOT marked as errors
like( $html, qr/2\|.*name="line2"/, 'Context line (2) is present' );
like( $html, qr/4\|.*name="line4"/, 'Context line (4) is present' );

# Check 3: Line 5 should be EXCLUDED (out of context range)
unlike( $html, qr/5\|/, 'Line (5) is correctly excluded based on context limit' );

# Check 4: HTML Structure Integrity
# A common regression in "span-heavy" parsing is breaking the table/div structure.
# We check that the source div is closed.
like( $html, qr/<\/div>\s*$/, 'Output correctly closes the main source div' );

# Check 5: Syntax Highlighting during Error
# Verify that even while displaying an error, the syntax highlighting (our new feature) still works on the error line.
like( $html, qr/class="suffix chomp-selfclose">-\//, 'Syntax highlighting applied correctly even on the error line' );

done_testing;

1;
