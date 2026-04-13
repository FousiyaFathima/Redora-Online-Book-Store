<%@ page import="java.sql.*,db.DBConnections" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
if(session.getAttribute("admin")==null){
    response.sendRedirect("login.jsp");
    return;
}

String orderId = request.getParameter("order_id");

Connection con = DBConnections.getConnection();
PreparedStatement ps = con.prepareStatement("SELECT * FROM orders WHERE order_id=?");
ps.setString(1, orderId);
ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Invoice #<%= orderId %></title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;600;700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Lato', sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 40px;
            display: flex;
            justify-content: center;
        }
        
        /* Invoice Container */
        .invoice-box {
            background: white;
            width: 800px;
            padding: 50px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            border: 1px solid #eee;
        }
        
        /* Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 40px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 20px;
        }
        
        .brand h1 {
            font-family: 'Cormorant Garamond', serif;
            color: #722F37;
            margin: 0;
            font-size: 36px;
        }
        .brand p { color: #888; margin: 5px 0 0 0; }
        
        .invoice-details {
            text-align: right;
        }
        .invoice-details h2 { color: #2C2C2C; margin: 0; font-size: 20px; text-transform: uppercase; letter-spacing: 2px; }
        .invoice-details p { color: #666; margin: 5px 0 0 0; font-size: 14px; }

        /* Table */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }
        
        th {
            text-align: left;
            padding: 12px;
            background: #f8f9fa;
            color: #666;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 2px solid #dee2e6;
        }
        
        td {
            padding: 15px 12px;
            border-bottom: 1px solid #eee;
            color: #2C2C2C;
        }
        
        .text-right { text-align: right; }
        
        /* Totals */
        .totals {
            width: 300px;
            margin-left: auto;
            margin-bottom: 40px;
        }
        
        .totals-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            font-size: 15px;
        }
        
        .grand-total {
            border-top: 2px solid #2C2C2C;
            font-weight: 700;
            font-size: 20px;
            color: #000;
        }
        
        /* Footer */
        .footer {
            text-align: center;
            margin-top: 40px;
            border-top: 1px solid #eee;
            padding-top: 20px;
        }
        
        .footer p { color: #888; font-size: 13px; margin-bottom: 20px; }
        
        /* Button */
        .btn-print {
            padding: 12px 30px;
            background: #722F37;
            color: white;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            transition: 0.3s;
        }
        .btn-print:hover { background: #5a2429; }
        
        @media print {
            body { background: white; }
            .invoice-box { box-shadow: none; border: none; width: 100%; padding: 0; }
            .btn-print { display: none; }
        }
    </style>
</head>
<body>

<div class="invoice-box">
    <div class="header">
        <div class="brand">
            <h1>READORA</h1>
            <p>Official Invoice</p>
        </div>
        <div class="invoice-details">
            <h2>Invoice</h2>
            <p><strong>#<%= orderId %></strong></p>
            <p>Date: <%= new java.util.Date() %></p>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>Book Title</th>
                <th class="text-right">Price</th>
                <th class="text-right">Qty</th>
                <th class="text-right">Total</th>
            </tr>
        </thead>
        <tbody>
            <%
            int grand = 0;
            while(rs.next()){
                int total = rs.getInt("total");
                grand += total;
            %>
            <tr>
                <td><%=rs.getString("book")%></td>
                <td class="text-right">₹<%=rs.getInt("price")%></td>
                <td class="text-right"><%=rs.getInt("qty")%></td>
                <td class="text-right">₹<%=total%></td>
            </tr>
            <%
            }
            rs.close();
            ps.close();
            con.close();
            %>
        </tbody>
    </table>

    <div class="totals">
        <div class="totals-row grand-total">
            <span>Grand Total</span>
            <span>₹ <%=grand%></span>
        </div>
    </div>

    <div class="footer">
        <p>Thank you for shopping with Readora!</p>
        <button class="btn-print" onclick="window.print()">Download PDF</button>
    </div>
</div>

</body>
</html>