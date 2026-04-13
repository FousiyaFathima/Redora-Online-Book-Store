<%-- 
    Document   : moveToCart
    Created on : 26 Mar, 2026, 3:04:19 PM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,db.DBConnections" %>

<%
int id = Integer.parseInt(request.getParameter("id"));

Connection con = DBConnections.getConnection();

/* GET ITEM */
PreparedStatement ps = con.prepareStatement(
"SELECT * FROM wishlist WHERE id=?"
);
ps.setInt(1,id);

ResultSet rs = ps.executeQuery();

if(rs.next()){

PreparedStatement insert = con.prepareStatement(
"INSERT INTO cart(email,book,price,image,qty) VALUES(?,?,?,?,?)"
);

insert.setString(1, rs.getString("email"));
insert.setString(2, rs.getString("book"));
insert.setInt(3, rs.getInt("price"));
insert.setString(4, rs.getString("image"));
insert.setInt(5, 1);

insert.executeUpdate();

/* DELETE FROM WISHLIST */
PreparedStatement del = con.prepareStatement(
"DELETE FROM wishlist WHERE id=?"
);
del.setInt(1,id);
del.executeUpdate();
}

response.sendRedirect("cart.jsp");
%>