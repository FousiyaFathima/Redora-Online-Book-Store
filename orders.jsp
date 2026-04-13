<%@ page import="java.sql.*,db.DBConnections" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
// 1. CHECK LOGIN
String email = (String)session.getAttribute("email");
if(email == null){
    response.sendRedirect("login.jsp");
    return;
}

// 2. DB LOGIC
Connection con = null;
PreparedStatement ps = null;
PreparedStatement ps2 = null;
ResultSet rs = null;
int count = 0; // For navbar

try {
    con = DBConnections.getConnection();
    
    // Get Cart Count for Navbar
    PreparedStatement psNav = con.prepareStatement("SELECT SUM(qty) FROM cart WHERE email=?");
    psNav.setString(1, email);
    ResultSet rsNav = psNav.executeQuery();
    if(rsNav.next()){ count = rsNav.getInt(1); }
    rsNav.close();
    psNav.close();

    // Get Orders
    ps = con.prepareStatement("SELECT DISTINCT order_id, order_date FROM orders WHERE email=? ORDER BY order_date DESC");
    ps.setString(1, email);
    rs = ps.executeQuery();

%>

<!DOCTYPE html>
<html>
<head>
    <title>My Orders</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;600;700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
        :root {
            --primary-bg: #F9F7F2;
            --text-dark: #2C2C2C;
            --text-gray: #6c757d;
            --accent-wine: #722F37;
            --accent-gold: #C5A059;
            --neon-border: var(--accent-gold);
            --neon-glow: rgba(197, 160, 89, 0.5);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Lato', sans-serif;
            background-color: var(--primary-bg);
            background-image: url('https://www.transparenttextures.com/patterns/cream-paper.png');
            color: var(--text-dark);
            min-height: 100vh;
        }

        /* NAVBAR */
        .navbar {
            display: flex; justify-content: space-between; align-items: center;
            background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px);
            padding: 20px 60px;
            border-bottom: 1px solid rgba(197, 160, 89, 0.3);
            position: fixed; width: 100%; top: 0; z-index: 1000;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        .logo { font-family: 'Cormorant Garamond', serif; font-size: 28px; color: var(--accent-wine); text-decoration: none; font-weight: 700; }
        .nav-links a { color: var(--text-dark); margin-left: 35px; text-decoration: none; font-size: 13px; text-transform: uppercase; letter-spacing: 1.5px; transition: color 0.3s; }
        .nav-links a:hover { color: var(--accent-wine); }
        .cart-icon { position: relative; }
        .cart-count { position: absolute; top: -8px; right: -10px; background: var(--accent-wine); color: white; border-radius: 50%; padding: 2px 6px; font-size: 10px; }

        /* CONTAINER */
        .container { max-width: 900px; margin: 120px auto 50px auto; padding: 0 20px; }
        .page-header { text-align: center; margin-bottom: 50px; }
        .page-header h1 { font-family: 'Cormorant Garamond', serif; font-size: 42px; color: var(--accent-wine); margin-bottom: 10px; }
        .page-header p { color: var(--text-gray); font-size: 16px; }

        /* ORDER CARD */
        .order-card {
            background: #ffffff; border-radius: 10px; box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            margin-bottom: 30px; overflow: hidden;
            border: 1px solid var(--neon-border);
            box-shadow: 0 0 15px var(--neon-glow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .order-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0 25px var(--neon-glow), 0 0 50px rgba(197, 160, 89, 0.2);
            border-color: var(--accent-gold);
        }

        .order-meta {
            display: flex; justify-content: space-between; align-items: center;
            background: #f9f9f9; padding: 18px 25px; border-bottom: 1px solid #eee;
        }
        .order-id { font-family: 'Cormorant Garamond', serif; font-size: 20px; font-weight: 700; color: var(--accent-wine); }
        .order-date { font-size: 13px; color: var(--text-gray); }

        .item-row { display: flex; align-items: center; padding: 20px 25px; gap: 20px; border-bottom: 1px solid #f0f0f0; }
        .item-row:last-child { border-bottom: none; }

        .item-img { width: 70px; height: 90px; object-fit: cover; border-radius: 6px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .item-details { flex: 1; }
        .item-title { font-family: 'Cormorant Garamond', serif; font-size: 20px; font-weight: 600; color: var(--text-dark); margin-bottom: 5px; }
        .item-sub { font-size: 14px; color: var(--text-gray); margin-bottom: 12px; }

        /* STATUS & BUTTONS */
        .status-badge { display: inline-block; padding: 6px 16px; border-radius: 4px; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
        .processing { color: #856404; background: #fff3cd; border: 1px solid #ffeeba; }
        .delivered { color: #155724; background: #d4edda; border: 1px solid #c3e6cb; }
        .cancelled { color: #721c24; background: #f8d7da; border: 1px solid #f5c6cb; }

        .btn-cancel {
            background: transparent; color: var(--accent-wine); border: 1px solid var(--accent-wine);
            padding: 8px 20px; border-radius: 4px; font-weight: 600; cursor: pointer; transition: all 0.3s;
            text-decoration: none; display: inline-block; font-size: 12px; text-transform: uppercase;
        }
        .btn-cancel:hover { background: var(--accent-wine); color: white; }
        
        .btn-invoice {
            background: transparent; color: var(--text-dark); border: 1px solid var(--text-dark);
            padding: 8px 20px; border-radius: 4px; font-weight: 600; cursor: pointer; transition: all 0.3s;
            text-decoration: none; display: inline-block; font-size: 12px; text-transform: uppercase;
        }
        .btn-invoice:hover { background: var(--text-dark); color: white; }

        /* EMPTY STATE */
        .empty-state {
            text-align: center; margin-top: 50px; padding: 50px;
            background: white; border-radius: 10px; border: 2px dashed #ddd;
        }
        .empty-state h3 { color: var(--text-gray); margin-bottom: 10px; }
        .empty-state a { color: var(--accent-wine); text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <header>
        <div class="navbar">
            <a href="index.jsp" class="logo">READORA</a>
            <div class="nav-links">
                <a href="index.jsp">Home</a>
                <a href="collection.jsp">Collection</a>
                <a href="cart.jsp" class="cart-icon">🛒 <span class="cart-count"><%=count%></span></a>
                <a href="wishlist.jsp">Wishlist</a>
                <a href="profile.jsp">👤</a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="page-header">
            <h1>My Orders</h1>
            <p>Track the status of your recent orders</p>
        </div>

        <%
        boolean hasOrders = false;
        while(rs.next()){
            hasOrders = true;
            String oid = rs.getString("order_id");
        %>

        <div class="order-card">
            <div class="order-meta">
                <span class="order-id">Order #<%= oid %></span>
                <span class="order-date"><%= rs.getTimestamp("order_date") %></span>
            </div>

            <%
            // QUERY ITEMS FOR THIS ORDER
            ps2 = con.prepareStatement("SELECT * FROM orders WHERE order_id=?");
            ps2.setString(1, oid);
            ResultSet rs2 = ps2.executeQuery();

            while(rs2.next()){
                String status = rs2.getString("delivery_status");
                String statusClass = status.equals("Delivered") ? "delivered" : 
                                     status.equals("Cancelled") ? "cancelled" : "processing";
        %>

            <div class="item-row">
                <img class="item-img" src="<%= rs2.getString("image") %>" alt="Book">
                
                <div class="item-details">
                    <div class="item-title"><%= rs2.getString("book") %></div>
                    <div class="item-sub">₹<%= rs2.getInt("price") %> &bull; Qty: <%= rs2.getInt("qty") %></div>
                    
                    <!-- ACTION BUTTONS AREA -->
                    <div style="display: flex; justify-content: space-between; align-items: center; gap: 10px;">
                        <span class="status-badge <%= statusClass %>"><%= status %></span>
                        
                        <div style="display: flex; gap: 10px;">
                            <!-- INVOICE BUTTON -->
                            <a href="invoice.jsp?order_id=<%= oid %>" class="btn-invoice">
                                <i class="fa fa-file-text"></i> Invoice
                            </a>

                            <% if(!status.equals("Delivered") && !status.equals("Cancelled")){ %>
                                <a href="cancelOrder.jsp?order_id=<%= oid %>" class="btn-cancel">
                                    Cancel Item
                                </a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>

            <%
            } // end inner while
            rs2.close();
            ps2.close();
            %>

        </div> <!-- End Order Card -->

        <%
        } // end outer while
        
        if(!hasOrders) {
        %>
            <div class="empty-state">
                <h3>No orders found</h3>
                <p>Looks like you haven't placed any orders yet.</p>
                <br>
                <a href="collection.jsp">Start Shopping</a>
            </div>
        <%
        }
        
        } catch(Exception e) {
            // This will print the actual error if something goes wrong
            out.println("<div style='color:red; text-align:center; padding:50px; background:white; margin:20px; border-radius:10px;'><h3>Error Loading Page</h3><p>" + e.getMessage() + "</p></div>");
            e.printStackTrace();
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception e){}
            if(ps != null) try { ps.close(); } catch(Exception e){}
            if(con != null) try { con.close(); } catch(Exception e){}
        }
        %>

    </div>

</body>
</html>