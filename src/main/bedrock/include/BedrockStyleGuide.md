# The Bedrock Style Guide (BSG)

## Last Updated: January 2026

...a guide to creating maintainable code the Bedrock way.

## Introduction

Many of the suggestions and style guidelines presented in this
document are influenced heavily by Damian Conway's [Perl Best
Practices](https://www.oreilly.com/library/view/perl-best-practices/0596001738/). As
the book suggests, just because an aspirin can cure a headache does
not mean you should consume the entire bottle! As always your mileage
may vary. Your situation may dictate deviating from the best practices
but keep in mind that you are writing your code for at least two
people...you and your future self!

Perl code should be easy to read. Why? Because we read code more than
we write it. Therefore, we should have a bias toward readability.

The Bedrock project includes a default `.perlcriticrc` and
`.perltidyrc` to help you reinforce these best practices. Hopefully,
you are using an editor that can consume these and provide linting and
formatting.

---

# 1. Core Philosophy

* **Readability First:** Favor readability over performance. It's almost always too early to optimize.
* **DRY (Don't Repeat Yourself):** Be on the lookout for useful snippets that should be utilities.
* **Contextual Comments:** Add comments that explain *business context* and *reasoning*, not just steps or language syntax.
* **No Zombie Code:** Remove code rather than "commenting it out". Use source control appropriately to retrieve history if you ever need it back.
* **Future-Proofing:** Code for your future self. Clever code is almost always forgotten code.
* **YAGNI (You Ain't Gonna Need It):** Solve today's problems. Unless you have a set-in-stone roadmap, design for the future but code for today.
* **Testing:** Write unit tests aggressively. Ask AI to lint your program before YOU even test it.

# 2. Code Layout & Formatting

* **Whitespace:** Whitespace is your friend. But be brief in your code.
* **Paragraphs:** Write code in paragraphs. Group code that belongs together, separate new ideas with blank lines.
* **Subroutine Headers:** Place a string of `########################################################################` (72 chars) before and after the first line of subs.
* **Argument Unpacking:** Place a new line after unpacking arguments
  in a sub:
  
  ```
  sub foo {
    my ($self) = @_;

     # code starts here
  ```
* **Braces:**
    * Use braces to dereference scalar references (`@{$x}`, not `@$x`).
    * Use braces when printing to a file handle: `print {$fh} "output";`.
    * Do not compress `if` blocks on one line like `if () { }`.
* **POD:** Documentation belongs at the end of the file, after `__END__`.

# 3. Control Flow

* **Postfix `if`:** Use postfix syntax for flow control, but strictly
  in this form:
  
   ```
   return {value}
       if {condition};
   ```
   * *Bad:* `return $x if $y;` (Hard to scan)
   * *Bad:* `if ($y) { return $x; }` (Verbose for single statements)
* **Avoid `unless`:** It is confusing, especially in compound expressions. Prefer `if (! $condition)`.
* **No `do {}` Blocks:** Avoid `do {}`. It's a syntactic booby trap. Prefer `eval {}` or our `choose {}` blocks.
* **Short Circuiting:** A subroutine almost never needs to end with an `if/else` block. Return early:

  ```
  if ( $condition ) {
    # ...
    return;
  }
  # Main logic continues...
  return;
  ```
* **Cascading Logic:** Avoid cascading `if/elsif`. Prefer **Dispatch Tables** (hash maps of `path => method_name`).
* **Iterators:**
    * Use `pairs` instead of `each`.
    * Use `any` and `none` (from `List::Util`) instead of `grep` for boolean checks.
* **Map Purity:** Keep `map {}` pure. Don't modify the value inside a map. If you need side effects or more than one statement, use a `for` loop.

# 4. Variables & Data Structures

* **Atomic Assignment (`choose`):** Combine declaration and assignment.
    * *Good:*
    
    ```
    my $x = choose {
        return 1 if $foo;
        return 2;
    };
    ```
* Hint: `choose` can be imported from Bedrock
  ```
  use Bedrock qw(choose);
  ```
* **Ternary Operator:** Use ternaries only when the choice is between two terse, single statements.
* **Constants:**
    * Use constants (e.g., `$EMPTY`, `$SLASH`) from `Bedrock::Constants` or `q{}` instead of literal strings.
    * Prefer `Readonly` over `use constant`. It allows interpolation and protects references.
* **Strings:**
    * Do not use useless interpolation: `"Hello"` $\to$ `'Hello'`.
    * Use `sprintf` for string construction if it makes the structure more obvious than concatenation.
* **Lists & Arrays:** Add a comma to the last item in a multi-line list.
* **Hashes:**
    * Use fat commas (`=>`).
    * Use **Hash Slices** for bulk assignment: `my ($conf, $file) = @{$options}{qw(config config_file)};`.
* **Tied Hashes:** When implementing `TIEHASH`, use the **Snapshot Approach** for `FIRSTKEY`. Capture keys into an array property to prevent "iterator reset" bugs.
* **Scope Safety:** Always `local`ize global variables (like `%ENV`, `$/`, or `$_`) when modifying them.

# 5. Subroutines & Modules

* **Return Values:** Always place a `return` at the end of a subroutine. Do not return `undef` explicitly, just `return`.
* **Private Methods:** Prefix private (internal) methods with an underscore `_`.
* **Modularity:** Create a subroutine when the code performs a specific action or the line count becomes unwieldy.
* **Roles:** Use `Role::Tiny` for composition. Prefer `with 'Role::Name'` over inheritance (`parent`) unless strictly specializing.
* **Accessors:** Use `Class::Accessor::Fast` if you need to encapsulate attributes.
* **The "Modulino" Pattern:**
    Write scripts as packages to enable testing:
    
    ```
    package Foo;
    use parent qw(CLI::Simple);
    caller or __PACKAGE__->main();
    ```

# 6. Error Handling & Robustness

* **Exceptions:** Prefer `Carp::croak` (usage errors) or `Carp::confess` (internal errors) over `die` in modules.
* **Eval Blocks:**
    * Almost always return a value from an `eval` block.
    * **Always** check `$EVAL_ERROR` (or `$@`) immediately after the block.
* **Fail Early:** Validate preconditions and die/return as early as possible.
* **Regex:**
    * Use `m{...}xms` modifiers.
    * Prefer `\A` (start) and `\z` (end) over `^` and `$`.
* **Ref Checking:** Prefer `Scalar::Util::reftype` over `ref` to look past blessings.
* **Monkey Patching:** If necessary, wrap redefinitions in a bare block `{ no warnings 'redefine'; ... }` to localize the effect.

# 7. Configuration & Environment

* **Precedence:** Follow "Cloud-Native" priority:
    1.  **Environment Variables** (Secrets/Container injects)
    2.  **Configuration Files**
    3.  **Defaults**
* **Boolean Flags:** Use `Bedrock::to_boolean` for flags. It handles `false`, `no`, `off`, and `0` correctly.

# 8. Tools & Libraries

* **Logging:** Use `Log::Log4perl` or `Bedrock::Logger` for production
  logging (see not on logging in the Scripts section)
* **Debugging:** Use `Data::Dumper` for ad-hoc debugging (but remove before commit, or log at DEBUG level).
* **CLI:** Use `CLI::Simple` for writing scripts.

# 9. Scripts
* **Standard Modules:** All scripts should include at a minimum
  `Data::Dumper` and `English` (`use English qw(-no_match_vars)
* **POD:** Add at least a stub for POD
* **Logging:** Any sufficiently complex script should include logging
  use the `Bedrock::Logger` role.
  ```
  use Role::Tiny::With;
  with 'Bedrock::Logger';
  
  my $logger = get_logger();
  ...
  ```
* **main():** Scripts should generally follow the modulino pattern by
  creating a class and using `CLI::Simple`. However at the very
  minimum a script should include a `main()` subroutine.
  ```
  sub main {
    # do work
    return $SUCCESS;
  }
  
  exit main();
  ```

---

# Appendix: Reference Documentation

## Note for AI Assistants and Developers regarding `eva {}`

`eval {}` blocks **DO NOT** exit the enclosing subroutine. They trap errors.

* **String Eval:** Parses and executes string content at runtime.
* **Block Eval:** Parses code at compile time, executes within current
  context. Traps exceptions.

In both forms, the value returned is the value of the last expression
evaluated inside the block.

## Why Avoid the `do {}` Block

Developers often mistake `do {}` for a specialized scope or
pseudo-subroutine (like `eval` or `choose`). However, unlike those
blocks, a `return` statement inside a `do` block **exits the entire
enclosing subroutine**, not just the block.

Here is the snippet to justify the warning:

```
sub calculate_status {
    my ($is_error) = @_;

    # THE TRAP:
    # The developer expects this logic to assign "Error" to $status.
    # Instead, the 'return' exits the entire calculate_status() subroutine immediately!
    my $status = do {
        return 'Error' if $is_error;  # <--- BUG! Exits the sub, not the do block.
        'Success';
    };

    # UNREACHABLE CODE (if $is_error is true):
    # This logging line will never execute, and any cleanup logic below is skipped.
    $self->log("Calculation finished with status: $status");

    return $status;
}
```
