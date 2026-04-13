<%-- 
    Document   : logout
    Created on : 19 Mar, 2026, 4:41:41 PM
    Author     : acer
--%>
<%
session.invalidate();
response.sendRedirect("login.jsp");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>logout</title>
    </head>
    <body>
        <h1>Logout !</h1>
    </body>
</html>
