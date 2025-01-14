# Examples

[Looping](Looping)

## Variables

Bedrock variables start with the '$' sigil just like Perl scalars. To
add variables to a Bedrock template use the `<var>` tag:

```
<var $HelloWorld>
```

You can create scalars, arrays and hashes...

```
<null:scalar Fruits>
<array:fruits apple orange pear grape>
<hash:prices apple .59 orange .99 pear .79 grape .69>
```

## Looping

You can loop over hashes or arrays.

```
<foreach $fruits>
  <var $_>
</foreach>
```
