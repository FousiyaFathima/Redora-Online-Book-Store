<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,db.DBConnections" %>

<%
if(session.getAttribute("admin")==null){
    response.sendRedirect("login.jsp");
    return;
}

Connection con = DBConnections.getConnection();
Statement st = con.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM books");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Books | Admin</title>
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
            --text-bright: #ffffff;
            --text-primary: #e8ecf1;
            --text-secondary: #b8c5d6;
            --text-muted: #8a9bb0;
            --border-color: #2a3f55;
            --border-light: #3d5a73;
            --shadow-sm: 0 2px 8px rgba(0,0,0,0.3);
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
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
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

        .sidebar-header {
            padding: 32px 24px;
            border-bottom: 1px solid var(--border-color);
        }

        .sidebar-logo {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 28px;
            font-weight: 700;
            color: var(--text-bright);
            text-decoration: none;
            letter-spacing: 3px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .sidebar-logo .logo-dot {
            width: 10px;
            height: 10px;
            background: var(--accent-cyan);
            border-radius: 50%;
            box-shadow: 0 0 20px var(--accent-cyan), 0 0 40px var(--accent-cyan);
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.8; transform: scale(1.3); }
        }

        .sidebar-nav {
            flex: 1;
            padding: 24px 16px;
        }

        .nav-section {
            margin-bottom: 32px;
        }

        .nav-section-title {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: var(--text-muted);
            padding: 0 16px;
            margin-bottom: 12px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 16px;
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            border-radius: 12px;
            transition: var(--transition);
            margin-bottom: 4px;
            position: relative;
        }

        .nav-item::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 3px;
            background: var(--accent-cyan);
            transform: scaleY(0);
            transition: var(--transition);
            border-radius: 0 3px 3px 0;
        }

        .nav-item:hover {
            background: rgba(0, 245, 212, 0.08);
            color: var(--text-bright);
        }

        .nav-item:hover::before {
            transform: scaleY(1);
        }

        .nav-item.active {
            background: linear-gradient(90deg, rgba(0, 245, 212, 0.15) 0%, rgba(0, 245, 212, 0.05) 100%);
            color: var(--accent-cyan);
        }

        .nav-item.active::before {
            transform: scaleY(1);
            box-shadow: 0 0 15px var(--accent-cyan);
        }

        .nav-item i {
            width: 20px;
            text-align: center;
        }

        .sidebar-footer {
            padding: 20px;
            border-top: 1px solid var(--border-color);
        }

        .logout-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 14px;
            background: rgba(241, 91, 181, 0.15);
            color: var(--accent-pink);
            border: 1px solid rgba(241, 91, 181, 0.3);
            border-radius: 12px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: var(--transition);
        }

        .logout-btn:hover {
            background: var(--accent-pink);
            color: var(--bg-dark);
            box-shadow: 0 0 25px rgba(241, 91, 181, 0.4);
        }

        /* MAIN CONTENT */
        .main-content {
            margin-left: var(--sidebar-width);
            flex: 1;
            padding: 40px 50px;
            position: relative;
            z-index: 1;
        }

        .page-header {
            margin-bottom: 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-header h1 {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 36px;
            font-weight: 700;
            color: var(--text-bright);
        }

        .btn-add-new {
            padding: 14px 28px;
            background: linear-gradient(135deg, var(--accent-cyan) 0%, var(--accent-blue) 100%);
            color: var(--bg-dark);
            text-decoration: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: var(--transition);
        }

        .btn-add-new:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0, 245, 212, 0.4);
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
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-title {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 18px;
            font-weight: 600;
            color: var(--text-bright);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .table-title i {
            color: var(--accent-cyan);
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: var(--bg-darker);
        }

        th {
            padding: 16px 24px;
            text-align: left;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-muted);
            border-bottom: 1px solid var(--border-color);
        }

        td {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        tr:hover td {
            background: rgba(0, 245, 212, 0.03);
        }

        tr:last-child td {
            border-bottom: none;
        }

        .book-info {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .book-img {
            width: 56px;
            height: 75px;
            object-fit: cover;
            border-radius: 8px;
            border: 2px solid var(--border-color);
        }

        .book-details h4 {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 15px;
            font-weight: 600;
            color: var(--text-bright);
            margin-bottom: 4px;
        }

        .book-details p {
            font-size: 12px;
            color: var(--text-muted);
        }

        .category-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            background: rgba(0, 187, 249, 0.15);
            color: var(--accent-blue);
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .price-text {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 16px;
            font-weight: 700;
            color: var(--text-bright);
        }

        .stock-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .stock-badge.in-stock {
            background: rgba(0, 245, 212, 0.15);
            color: var(--accent-cyan);
        }

        .stock-badge.low-stock {
            background: rgba(251, 191, 36, 0.15);
            color: #fbbf24;
        }

        .stock-badge.out-stock {
            background: rgba(241, 91, 181, 0.15);
            color: var(--accent-pink);
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-action {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: var(--transition);
            font-size: 14px;
        }

        .btn-edit {
            background: rgba(155, 93, 229, 0.15);
            color: var(--accent-purple);
        }

        .btn-edit:hover {
            background: var(--accent-purple);
            color: var(--text-bright);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(155, 93, 229, 0.4);
        }

        .btn-delete {
            background: rgba(241, 91, 181, 0.15);
            color: var(--accent-pink);
        }

        .btn-delete:hover {
            background: var(--accent-pink);
            color: var(--text-bright);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(241, 91, 181, 0.4);
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .table-card {
            animation: fadeInUp 0.5s ease forwards;
        }

        @media (max-width: 1024px) {
            .main-content {
                padding: 24px;
            }
        }

        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }

            .page-header h1 {
                font-size: 28px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            * {
                animation-duration: 0.01ms !important;
                transition-duration: 0.01ms !important;
            }
        }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
    <div class="sidebar-header">
        <a href="adminDashboard.jsp" class="sidebar-logo">
            READORA<span class="logo-dot"></span>
        </a>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-section">
            <div class="nav-section-title">Main Menu</div>
            <a href="adminDashboard.jsp" class="nav-item">
                <i class="fas fa-th-large"></i>
                <span>Dashboard</span>
            </a>
            <a href="addBook.jsp" class="nav-item">
                <i class="fas fa-plus-circle"></i>
                <span>Add Book</span>
            </a>
            <a href="viewBooks.jsp" class="nav-item active">
                <i class="fas fa-book"></i>
                <span>Manage Books</span>
            </a>
        </div>
        
        <div class="nav-section">
            <div class="nav-section-title">Operations</div>
            <a href="adminOrders.jsp" class="nav-item">
                <i class="fas fa-shopping-bag"></i>
                <span>Orders</span>
            </a>
            <a href="adminStory.jsp" class="nav-item">
                <i class="fas fa-feather-alt"></i>
                <span>Stories</span>
            </a>
        </div>
    </nav>

    <div class="sidebar-footer">
        <a href="adminLogout.jsp" class="logout-btn">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
        </a>
    </div>
</aside>

<!-- MAIN CONTENT -->
<main class="main-content">
    
    <div class="page-header">
        <h1>Manage Books</h1>
        <a href="addBook.jsp" class="btn-add-new">
            <i class="fas fa-plus"></i>
            Add New Book
        </a>
    </div>

    <div class="table-card">
        <div class="table-header">
            <h3 class="table-title">
                <i class="fas fa-book"></i>
                Book Inventory
            </h3>
        </div>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Book Details</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    while(rs.next()){
                        int id = rs.getInt("id");
                        String title = rs.getString("title");
                        String image = rs.getString("image");
                        int price = rs.getInt("price");
                        int stock = rs.getInt("stock");
                        String type = rs.getString("type");
                        
                        String stockClass = stock > 5 ? "in-stock" : (stock > 0 ? "low-stock" : "out-stock");
                        String stockText = stock > 5 ? "In Stock" : (stock > 0 ? "Low Stock" : "Out of Stock");
                    %>
                    <tr>
                        <td>
                            <div class="book-info">
                                <img class="book-img" src="<%= image %>" alt="<%= title %>" onerror="this.src='https://via.placeholder.com/56x75/1b2838/00f5d4?text=No+Image'">
                                <div class="book-details">
                                    <h4><%= title %></h4>
                                    <p>ID: #<%= id %></p>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span class="category-badge">
                                <i class="fas fa-tag"></i>
                                <%= type %>
                            </span>
                        </td>
                        <td class="price-text">₹<%= price %></td>
                        <td>
                            <span class="stock-badge <%= stockClass %>">
                                <i class="fas fa-box"></i>
                                <%= stock %> - <%= stockText %>
                            </span>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="editBook.jsp?id=<%= id %>" class="btn-action btn-edit" title="Edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="deleteBook.jsp?id=<%= id %>" class="btn-action btn-delete" title="Delete" onclick="return confirm('Are you sure you want to delete this book?');">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <%
                    }
                    rs.close();
                    st.close();
                    con.close();
                    %>
                </tbody>
            </table>
        </div>
    </div>

</main>

</body>
</html>