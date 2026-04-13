<%-- 
    Document   : editBookDB
    Created on : 28 Mar, 2026, 1:51:45 PM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DBConnections" %>
<%
String id = request.getParameter("id");
String title = request.getParameter("title");
int price = Integer.parseInt(request.getParameter("price"));
int stock = Integer.parseInt(request.getParameter("stock"));
String image = request.getParameter("image");
String type = request.getParameter("type");

Connection con = DBConnections.getConnection();
PreparedStatement ps = con.prepareStatement("UPDATE books SET title=?, price=?, stock=?, image=?, type=? WHERE id=?");
ps.setString(1, title);
ps.setInt(2, price);
ps.setInt(3, stock);
ps.setString(4, image);
ps.setString(5, type);
ps.setString(6, id);
ps.executeUpdate();

ps.close();
con.close();
response.sendRedirect("viewBooks.jsp");
%>
