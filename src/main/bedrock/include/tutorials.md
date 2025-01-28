# Quick Tutorials

* [Templating Fundamentals](#templating_fundamentals)

## Templating Fundamentals

Bedrock is, at its core, a templating framework that allow you to
substitue variables inside of text documents. Input can come from
various sources depending on how you using Bedrock.

* Query strings attached to URLs
* POST data in the form of _application/www-form-urlencode_ input
* command line arguments when using [Bedrock Shell](#bedrock-shell)
* config files
* environment variables
* custom defined objects

However the input is received the way to include values into your text
document is through the use of the [`<var>`](#tag-var) tag.

To include values from a form or query string we use the `$input`
object and the dot notation to access an attribute of the object.

```
<var $input.foo>
```

To include values from an object that implements a method:

```
<var $session.get('session')>
```
