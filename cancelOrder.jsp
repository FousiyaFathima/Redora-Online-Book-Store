<%-- 
    Document   : cancelOrder
    Created on : 24 Mar, 2026, 10:24:11 AM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnections" %>
<%@ page import="java.sql.*,db.DBConnections" %>

<%@ page import="java.sql.*,db.DBConnections" %>

<%
String orderId = request.getParameter("order_id");

Connection con = DBConnections.getConnection();

PreparedStatement ps = con.prepareStatement(
"UPDATE orders SET delivery_status='Cancelled' WHERE order_id=?"
);

ps.setString(1, orderId);

ps.executeUpdate();

/* REDIRECT BACK */
response.sendRedirect("orders.jsp");
%>
