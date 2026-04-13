<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,db.DBConnections" %>

<%
// 1. Security Check
if(session.getAttribute("admin")==null){
    response.sendRedirect("login.jsp");
    return;
}

// 2. Get Parameters
String idStr = request.getParameter("id");
String status = request.getParameter("status");

if(idStr != null && status != null){
    
    Connection con = null;
    PreparedStatement ps = null; // Declared here

    try {
        int id = Integer.parseInt(idStr);
        
        con = DBConnections.getConnection();
        
        // 3. Update Query
        // REMOVED 'PreparedStatement' type from the start of this line
        ps = con.prepareStatement("UPDATE orders SET delivery_status=? WHERE id=?");
        
        ps.setString(1, status);
        ps.setInt(2, id);
        
        ps.executeUpdate();
        
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(ps != null) try { ps.close(); } catch(Exception e){}
        if(con != null) try { con.close(); } catch(Exception e){}
    }
}

// 4. Redirect back to Orders Page
response.sendRedirect("adminOrders.jsp");
%>