<%@ page import="java.sql.*,db.DBConnections" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%
if(session.getAttribute("admin")==null){
    response.sendRedirect("login.jsp");
    return;
}

String email = request.getParameter("email");

if(email == null){
    out.println("No email provided.");
    return;
}

Connection con = DBConnections.getConnection();
PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email=?");
ps.setString(1, email);
ResultSet rs = ps.executeQuery();

if(!rs.next()){
    out.println("Customer not found");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Details</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;600;700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Lato', sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .card {
            background: white;
            width: 400px;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
            text-align: center;
        }
        .header {
            background: #1a1a1a;
            color: white;
            padding: 30px;
        }
        .header h2 {
            margin: 0;
            font-family: 'Cormorant Garamond', serif;
            font-size: 28px;
        }
        .header p {
            margin: 5px 0 0 0;
            color: #aaa;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .body {
            padding: 30px;
        }
        .detail-row {
            text-align: left;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }
        .detail-row:last-child { border-bottom: none; }
        .label {
            display: block;
            font-size: 12px;
            color: #888;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }
        .value {
            font-size: 18px;
            color: #2C2C2C;
            font-weight: 600;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #722F37;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
        }
    </style>
</head>
<body>

<div class="card">
    <div class="header">
        <h2>👤 Customer Profile</h2>
        <p>Registered User</p>
    </div>
    
    <div class="body">
        <div class="detail-row">
            <span class="label">Full Name</span>
            <span class="value"><%=rs.getString("name")%></span>
        </div>
        
        <div class="detail-row">
            <span class="label">Email Address</span>
            <span class="value"><%=rs.getString("email")%></span>
        </div>
        
        <div class="detail-row">
            <span class="label">Phone Number</span>
            <span class="value"><%=rs.getString("phone")%></span>
        </div>
        
        <div class="detail-row">
            <span class="label">Shipping Address</span>
            <span class="value"><%=rs.getString("address")%></span>
        </div>
        
        <a href="javascript:history.back()" class="back-link">← Back to Orders</a>
    </div>
</div>

<%
rs.close();
ps.close();
con.close();
%>
</body>
</html>