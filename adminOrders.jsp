<%@ page import="java.sql.*,db.DBConnections" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
if(session.getAttribute("admin")==null){
    response.sendRedirect("login.jsp");
    return;
}

Connection con = DBConnections.getConnection();

/* TOTAL SALES */
PreparedStatement ps1 = con.prepareStatement("SELECT SUM(total) FROM orders");
ResultSet rs1 = ps1.executeQuery();
int totalSales = 0;
if(rs1.next()) totalSales = rs1.getInt(1);

/* TOTAL ORDERS */
PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(DISTINCT order_id) FROM orders");
ResultSet rs2 = ps2.executeQuery();
int totalOrders = 0;
if(rs2.next()) totalOrders = rs2.getInt(1);

/* ALL ORDERS */
PreparedStatement ps = con.prepareStatement("SELECT * FROM orders ORDER BY order_date DESC");
ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Orders Management | Readora</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --sidebar-width: 280px;
            --bg-dark: #0d1b2a;
            --bg-darker: #0a1420;
            --bg-card: #1b2838;
            --bg-input: #0f1c2e;
            --accent-cyan: #00f5d4;
            --accent-blue: #00bbf9;
            --accent-purple: #9b5de5;
            --accent-pink: #f15bb5;
            --accent-gold: #fbbf24;
            --text-bright: #ffffff;
            --text-primary: #e8ecf1;
            --text-secondary: #b8c5d6;
            --text-muted: #8a9bb0;
            --border-color: #2a3f55;
            --border-light: #3d5a73;
            --shadow-md: 0 4px 20px rgba(0,0,0,0.4);
            --shadow-lg: 0 10px 40px rgba(0,0,0,0.5);
            --glow-cyan: 0 0 30px rgba(0, 245, 212, 0.3);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, var(--bg-dark) 0%, var(--bg-darker) 100%);
            min-height: 100vh;
            display: flex;
            color: var(--text-primary);
        }

        body::before {
            content: '';
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background-image: 
                radial-gradient(ellipse at 20% 80%, rgba(0, 245, 212, 0.06) 0%, transparent 50%),
                radial-gradient(ellipse at 80% 20%, rgba(0, 187, 249, 0.06) 0%, transparent 50%);
            pointer-events: none;
            z-index: 0;
        }

        /* SIDEBAR */
        .sidebar {
            width: var(--sidebar-width);
            background: var(--bg-darker);
            position: fixed;
            height: 100vh;
            display: flex;
            flex-direction: column;
            z-index: 1000;
            border-right: 1px solid var(--border-color);
        }

        .sidebar-header { padding: 32px 24px; border-bottom: 1px solid var(--border-color); }
        .sidebar-logo {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 28px; font-weight: 700;
            color: var(--text-bright);
            text-decoration: none;
            letter-spacing: 3px;
            display: flex; align-items: center; gap: 12px;
        }
        .sidebar-logo .logo-dot {
            width: 10px; height: 10px;
            background: var(--accent-cyan);
            border-radius: 50%;
            box-shadow: 0 0 20px var(--accent-cyan), 0 0 40px var(--accent-cyan);
            animation: pulse 2s ease-in-out infinite;
        }
        @keyframes pulse { 0%, 100% { opacity: 1; transform: scale(1); } 50% { opacity: 0.8; transform: scale(1.3); } }

        .sidebar-nav { flex: 1; padding: 24px 16px; }
        .nav-section { margin-bottom: 32px; }
        .nav-section-title {
            font-size: 11px; font-weight: 600;
            text-transform: uppercase; letter-spacing: 2px;
            color: var(--text-muted);
            padding: 0 16px; margin-bottom: 12px;
        }
        .nav-item {
            display: flex; align-items: center; gap: 14px;
            padding: 14px 16px;
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 14px; font-weight: 500;
            border-radius: 12px;
            transition: var(--transition);
            margin-bottom: 4px;
            position: relative;
        }
        .nav-item::before {
            content: '';
            position: absolute; left: 0; top: 0; bottom: 0;
            width: 3px;
            background: var(--accent-cyan);
            transform: scaleY(0);
            transition: var(--transition);
            border-radius: 0 3px 3px 0;
        }
        .nav-item:hover { background: rgba(0, 245, 212, 0.08); color: var(--text-bright); }
        .nav-item:hover::before { transform: scaleY(1); }
        .nav-item.active {
            background: linear-gradient(90deg, rgba(0, 245, 212, 0.15) 0%, rgba(0, 245, 212, 0.05) 100%);
            color: var(--accent-cyan);
        }
        .nav-item.active::before { transform: scaleY(1); box-shadow: 0 0 15px var(--accent-cyan); }
        .nav-item i { width: 20px; text-align: center; }

        .sidebar-footer { padding: 20px; border-top: 1px solid var(--border-color); }
        .logout-btn {
            display: flex; align-items: center; justify-content: center; gap: 10px;
            width: 100%; padding: 14px;
            background: rgba(241, 91, 181, 0.15);
            color: var(--accent-pink);
            border: 1px solid rgba(241, 91, 181, 0.3);
            border-radius: 12px;
            font-size: 13px; font-weight: 600;
            text-decoration: none;
            transition: var(--transition);
        }
        .logout-btn:hover { background: var(--accent-pink); color: var(--bg-dark); box-shadow: 0 0 25px rgba(241, 91, 181, 0.4); }

        /* MAIN CONTENT */
        .main-content {
            margin-left: var(--sidebar-width);
            flex: 1;
            padding: 40px 50px;
            position: relative;
            z-index: 1;
        }

        .page-header { margin-bottom: 40px; }
        .page-header h1 {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 36px; font-weight: 700;
            color: var(--text-bright);
            margin-bottom: 8px;
        }
        .page-header p { color: var(--text-secondary); font-size: 15px; }

        /* STATS GRID */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: var(--bg-card);
            border-radius: 20px;
            padding: 28px;
            border: 1px solid var(--border-color);
            position: relative;
            overflow: hidden;
            transition: var(--transition);
        }
        .stat-card::before {
            content: '';
            position: absolute; top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--accent-blue), var(--accent-cyan));
        }
        .stat-card:hover { transform: translateY(-4px); border-color: var(--accent-blue); box-shadow: var(--glow-cyan); }
        .stat-card.sales::before { background: linear-gradient(90deg, var(--accent-cyan), var(--accent-blue)); }
        .stat-card.orders::before { background: linear-gradient(90deg, var(--accent-purple), var(--accent-pink)); }
        .stat-card.orders:hover { border-color: var(--accent-purple); box-shadow: 0 0 30px rgba(155, 93, 229, 0.3); }

        .stat-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
        .stat-icon {
            width: 56px; height: 56px;
            border-radius: 16px;
            display: flex; align-items: center; justify-content: center;
            font-size: 24px;
        }
        .stat-card.sales .stat-icon {
            background: linear-gradient(135deg, rgba(0, 245, 212, 0.2) 0%, rgba(0, 187, 249, 0.2) 100%);
            color: var(--accent-cyan);
        }
        .stat-card.orders .stat-icon {
            background: linear-gradient(135deg, rgba(155, 93, 229, 0.2) 0%, rgba(241, 91, 181, 0.2) 100%);
            color: var(--accent-purple);
        }

        .stat-content h3 {
            font-size: 13px; font-weight: 500;
            color: var(--text-muted);
            text-transform: uppercase; letter-spacing: 1px;
            margin-bottom: 8px;
        }
        .stat-content p {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 36px; font-weight: 700;
            color: var(--text-bright);
        }

        /* TABLE CARD */
        .table-card {
            background: var(--bg-card);
            border-radius: 20px;
            border: 1px solid var(--border-color);
            overflow: hidden;
        }
        .table-header {
            padding: 24px 28px;
            border-bottom: 1px solid var(--border-color);
            display: flex; justify-content: space-between; align-items: center;
        }
        .table-title {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 18px; font-weight: 600;
            color: var(--text-bright);
            display: flex; align-items: center; gap: 10px;
        }
        .table-title i { color: var(--accent-cyan); }

        .table-wrapper { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; min-width: 900px; }
        thead { background: var(--bg-darker); }
        th {
            padding: 16px 24px;
            text-align: left;
            font-size: 11px; font-weight: 600;
            text-transform: uppercase; letter-spacing: 1px;
            color: var(--text-muted);
            border-bottom: 1px solid var(--border-color);
        }
        td {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
            color: var(--text-primary);
        }
        tr:hover td { background: rgba(0, 245, 212, 0.02); }
        tr:last-child td { border-bottom: none; }

        .order-id {
            font-family: 'Space Grotesk', sans-serif;
            font-weight: 600;
            color: var(--accent-cyan);
        }
        .book-info { display: flex; align-items: center; gap: 16px; }
        .book-img {
            width: 50px; height: 70px;
            object-fit: cover;
            border-radius: 8px;
            border: 2px solid var(--border-color);
        }
        .book-title { font-weight: 600; color: var(--text-bright); }
        .book-title small { color: var(--text-muted); font-weight: 400; }

        /* Status Badges */
        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }
        .status-processing { background: rgba(251, 191, 36, 0.15); color: var(--accent-gold); }
        .status-packed { background: rgba(0, 187, 249, 0.15); color: var(--accent-blue); }
        .status-shipped { background: rgba(155, 93, 229, 0.15); color: var(--accent-purple); }
        .status-delivered { background: rgba(0, 245, 212, 0.15); color: var(--accent-cyan); }
        .status-cancelled { background: rgba(241, 91, 181, 0.15); color: var(--accent-pink); }

        /* Action Buttons */
        .action-buttons { display: flex; gap: 8px; margin-bottom: 10px; }
        .btn-action {
            padding: 8px 14px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: var(--transition);
        }
        .btn-customer {
            background: rgba(155, 93, 229, 0.15);
            color: var(--accent-purple);
        }
        .btn-customer:hover {
            background: var(--accent-purple);
            color: var(--text-bright);
            box-shadow: 0 4px 15px rgba(155, 93, 229, 0.3);
        }
        .btn-info {
            background: rgba(0, 187, 249, 0.15);
            color: var(--accent-blue);
        }
        .btn-info:hover {
            background: var(--accent-blue);
            color: var(--bg-dark);
            box-shadow: 0 4px 15px rgba(0, 187, 249, 0.3);
        }

        /* Form Elements */
        .update-form {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        select {
            padding: 8px 12px;
            background: var(--bg-input);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: var(--text-primary);
            font-size: 13px;
            font-family: inherit;
            cursor: pointer;
            transition: var(--transition);
        }
        select:focus {
            outline: none;
            border-color: var(--accent-cyan);
            box-shadow: 0 0 10px rgba(0, 245, 212, 0.2);
        }
        .btn-update {
            padding: 8px 16px;
            background: linear-gradient(135deg, var(--accent-cyan), var(--accent-blue));
            color: var(--bg-dark);
            border: none;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: var(--transition);
            font-family: inherit;
        }
        .btn-update:hover { transform: translateY(-2px); box-shadow: 0 4px 15px rgba(0, 245, 212, 0.3); }

        /* Animations */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .stat-card, .table-card { animation: fadeInUp 0.5s ease forwards; }
        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .table-card { animation-delay: 0.3s; }

        @media (max-width: 1024px) { .main-content { padding: 24px; } }
        @media (prefers-reduced-motion: reduce) {
            * { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; }
        }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
    <div class="sidebar-header">
        <a href="adminDashboard.jsp" class="sidebar-logo">READORA<span class="logo-dot"></span></a>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-section">
            <div class="nav-section-title">Main Menu</div>
            <a href="adminDashboard.jsp" class="nav-item"><i class="fas fa-th-large"></i><span>Dashboard</span></a>
            <a href="addBook.jsp" class="nav-item"><i class="fas fa-plus-circle"></i><span>Add Book</span></a>
            <a href="viewBooks.jsp" class="nav-item"><i class="fas fa-book"></i><span>Manage Books</span></a>
        </div>
        <div class="nav-section">
            <div class="nav-section-title">Operations</div>
            <a href="adminOrders.jsp" class="nav-item active"><i class="fas fa-shopping-bag"></i><span>Orders</span></a>
            <a href="adminStory.jsp" class="nav-item"><i class="fas fa-feather-alt"></i><span>Stories</span></a>
        </div>
    </nav>
    <div class="sidebar-footer">
        <a href="adminLogout.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
    </div>
</aside>

<!-- MAIN CONTENT -->
<main class="main-content">
    <div class="page-header">
        <h1>Orders Management</h1>
        <p>Track, manage, and update customer orders efficiently.</p>
    </div>

    <!-- STATS -->
    <div class="stats-grid">
        <div class="stat-card orders">
            <div class="stat-header">
                <div class="stat-icon"><i class="fas fa-box"></i></div>
            </div>
            <div class="stat-content">
                <h3>Total Orders</h3>
                <p><%= totalOrders %></p>
            </div>
        </div>
        <div class="stat-card sales">
            <div class="stat-header">
                <div class="stat-icon"><i class="fas fa-rupee-sign"></i></div>
            </div>
            <div class="stat-content">
                <h3>Total Sales</h3>
                <p><%= totalSales %></p>
            </div>
        </div>
    </div>

    <!-- ORDERS TABLE -->
    <div class="table-card">
        <div class="table-header">
            <h3 class="table-title"><i class="fas fa-receipt"></i> Order History</h3>
        </div>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Product</th>
                        <th>Customer</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    while(rs.next()){
                        int id = rs.getInt("id");
                        String orderId = rs.getString("order_id");
                        String book = rs.getString("book");
                        String image = rs.getString("image");
                        int price = rs.getInt("price");
                        int qty = rs.getInt("qty");
                        int total = price * qty;
                        String status = rs.getString("delivery_status");
                        String email = rs.getString("email");
                        
                        String statusClass = "status-processing";
                        if(status.equals("Packed")) statusClass = "status-packed";
                        else if(status.equals("Shipped")) statusClass = "status-shipped";
                        else if(status.equals("Delivered")) statusClass = "status-delivered";
                        else if(status.equals("Cancelled")) statusClass = "status-cancelled";
                    %>
                    <tr>
                        <td class="order-id">#<%= orderId %></td>
                        <td>
                            <div class="book-info">
                                <img class="book-img" src="<%= image %>" alt="<%= book %>">
                                <span class="book-title"><%= book %><br><small>Qty: <%= qty %></small></span>
                            </div>
                        </td>
                        <td><%= email %></td>
                        <td style="font-weight: 600;">₹<%= total %></td>
                        <td><span class="status-badge <%= statusClass %>"><%= status %></span></td>
                        <td>
                            <div class="action-buttons">
                                <a href="customerDetails.jsp?email=<%= email %>" class="btn-action btn-customer">
                                    <i class="fas fa-user"></i> Customer
                                </a>
                                <a href="invoice.jsp?order_id=<%= orderId %>" class="btn-action btn-info">
                                    <i class="fas fa-file-invoice"></i> Invoice
                                </a>
                            </div>
                            <form action="updateStatus.jsp" method="post" class="update-form">
                                <input type="hidden" name="id" value="<%= id %>">
                                <select name="status">
                                    <option <%=status.equals("Processing")?"selected":""%>>Processing</option>
                                    <option <%=status.equals("Packed")?"selected":""%>>Packed</option>
                                    <option <%=status.equals("Shipped")?"selected":""%>>Shipped</option>
                                    <option <%=status.equals("Delivered")?"selected":""%>>Delivered</option>
                                    <option <%=status.equals("Cancelled")?"selected":""%>>Cancelled</option>
                                </select>
                                <button type="submit" class="btn-update">Update</button>
                            </form>
                        </td>
                    </tr>
                    <%
                    }
                    rs.close();
                    ps.close();
                    con.close();
                    %>
                </tbody>
            </table>
        </div>
    </div>
</main>

</body>
</html>