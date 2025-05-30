# Examples

* [Variables](#variables)
* [Looping](#looping)
* [Conditionals](#conditionals)
* [Plugins](#plugins)

---

# Variables

Bedrock variables start with the '$' sigil just like Perl scalars. To
insert variables into a Bedrock template use the `<var>` tag:

```
<var $HelloWorld>
```

You can create scalars, arrays and hashes...

## A Scalar

```
<null:label Fruits>
```

## An Array

```
<array:fruits apple orange pear grape>
```

## A Hash

```
<hash:prices apple .59 orange .99 pear .79 grape .69>
```

---

# Looping

You can loop over hashes or arrays.

## Looping Over an Array

```
<array:fruits apple orange pear grape>

<foreach $fruits>
  <var $_>
</foreach>

<foreach --define-var="item" $fruits>
 <var $item>
</foreach>

<foreach --start-index=0 --define-index=i $fruits>
  Item <var $i> : <var $item>
</foreach>
```

## Looping Over Hashes

```
<hash:prices apple .59 orange .99 pear .79 grape .69>

<foreach $prices>
<var $_.key> $<var $_.value>/lb
</foreach>

```

# Conditionals

The conditionals include:

* `<if/else/elsif>`
* `<unless/else/elsif>`
* `<while>`

## Conditional Operators

Learn more about conditionals (here)[#tag-if].

* `--eq`
* `--gt`
* `--ge`
* `--lt`
* `--le`
* `--re`
* `--ref`
* `--reftype`
* `--file`
* `--not`
* `--exists`
* `--defined`
* `--scalar`
* `--array`
* `--plugin`
* `--cached`

