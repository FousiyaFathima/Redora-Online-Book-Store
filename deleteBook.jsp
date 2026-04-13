<%-- 
    Document   : deleteBook
    Created on : 27 Mar, 2026, 7:38:26 PM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DBConnections" %>
<%
String id = request.getParameter("id");
if(id != null){
    Connection con = DBConnections.getConnection();
    PreparedStatement ps = con.prepareStatement("DELETE FROM books WHERE id=?");
    ps.setInt(1, Integer.parseInt(id));
    ps.executeUpdate();
    ps.close();
    con.close();
}
response.sendRedirect("viewBooks.jsp");
%>