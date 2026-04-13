<%-- 
    Document   : adminLogout
    Created on : 24 Mar, 2026, 11:20:02 AM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
session.removeAttribute("admin"); // only admin logout
response.sendRedirect("login.jsp");
%>