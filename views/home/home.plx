<html>
<head><title>BaConPLX Test Page</title></head>
<body>
<% print($$); %><br>
'this is a test'<br>
ID = <!id!><br>
name = <!name!><br>
<% if(1) {
  print 'test1';
} %><br>
<% if(1) {
  print $title ;
} %><br>
<% if(0) { %>
  <!id!> - <!name!>
<% } %><br>
<%if(1){%>
  <!id!> - <!name!>
<%}%><br>
</body>
</html>
