<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Index of <var $directory></title>
    <link rel="stylesheet" href="/bedrock/css/pod.css">
  </head>
  <body>
    <h1><var $directory></h1>
    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Last Modified</th>
          <th>Created</th>
          <th>Size</th>
        </tr>
      </thead>
      <tbody>
        <foreach $mtime_order ->
          <null:file $index.get($_)>
          <tr>
            <td><a href="<var $util.to_url($_)>"><var $_></a></td>
            <td><var $util.format_date($file.mtime)></td>
            <td><var $util.format_date($file.ctime)></td>
            <td><var $util.format_bytes($file.size)></td>
          </tr>
        </foreach>
      </tbody>
    </table>
  </body>
</html>
