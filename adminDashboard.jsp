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

/* FETCH STORIES FOR DASHBOARD */
PreparedStatement psStories = con.prepareStatement("SELECT * FROM stories ORDER BY date DESC");
ResultSet rsStories = psStories.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Readora</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-dark: #0d1b2a;
            --bg-darker: #0a1420;
            --bg-card: #1b2838;
            --bg-card-hover: #243447;
            --bg-sidebar: #0a1420;
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
            --glow-blue: 0 0 30px rgba(0, 187, 249, 0.3);
            --sidebar-width: 280px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, var(--bg-dark) 0%, var(--bg-darker) 100%);
            min-height: 100vh;
            display: flex;
            color: var(--text-primary);
            overflow-x: hidden;
        }

        /* Ambient Glow Effects */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: 
                radial-gradient(ellipse at 10% 90%, rgba(0, 245, 212, 0.08) 0%, transparent 50%),
                radial-gradient(ellipse at 90% 10%, rgba(0, 187, 249, 0.08) 0%, transparent 50%),
                radial-gradient(ellipse at 50% 50%, rgba(155, 93, 229, 0.04) 0%, transparent 60%);
            pointer-events: none;
            z-index: 0;
        }

        /* SIDEBAR */
        .sidebar {
            width: var(--sidebar-width);
            background: var(--bg-sidebar);
            position: fixed;
            height: 100vh;
            display: flex;
            flex-direction: column;
            z-index: 1000;
            overflow: hidden;
            border-right: 1px solid var(--border-color);
        }

        .sidebar::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(180deg, rgba(0, 245, 212, 0.02) 0%, transparent 40%);
            pointer-events: none;
        }

        .sidebar-header {
            padding: 32px 24px;
            border-bottom: 1px solid var(--border-color);
            position: relative;
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
            box-shadow: 0 0 20px var(--accent-cyan), 0 0 40px var(--accent-cyan), 0 0 60px var(--accent-cyan);
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.8; transform: scale(1.3); }
        }

        .sidebar-nav {
            flex: 1;
            padding: 24px 16px;
            overflow-y: auto;
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
            overflow: hidden;
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
            font-size: 16px;
        }

        .nav-item .nav-badge {
            margin-left: auto;
            background: var(--accent-pink);
            color: white;
            font-size: 10px;
            padding: 2px 8px;
            border-radius: 10px;
            font-weight: 600;
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
            font-family: inherit;
            cursor: pointer;
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
            margin-bottom: 8px;
        }

        .page-header p {
            color: var(--text-secondary);
            font-size: 15px;
        }

        .header-date {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 20px;
            background: var(--bg-card);
            border-radius: 12px;
            border: 1px solid var(--border-color);
            font-size: 14px;
            color: var(--text-secondary);
        }

        .header-date i {
            color: var(--accent-cyan);
        }

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
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--accent-cyan), var(--accent-blue));
        }

        .stat-card:hover {
            transform: translateY(-4px);
            border-color: var(--accent-cyan);
            box-shadow: var(--glow-cyan);
        }

        .stat-card.sales::before {
            background: linear-gradient(90deg, var(--accent-cyan), var(--accent-blue));
        }

        .stat-card.orders::before {
            background: linear-gradient(90deg, var(--accent-purple), var(--accent-pink));
        }

        .stat-card.orders:hover {
            border-color: var(--accent-purple);
            box-shadow: 0 0 30px rgba(155, 93, 229, 0.3);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .stat-icon {
            width: 56px;
            height: 56px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
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

        .stat-trend {
            display: flex;
            align-items: center;
            gap: 4px;
            font-size: 12px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 20px;
        }

        .stat-trend.up {
            background: rgba(0, 245, 212, 0.15);
            color: var(--accent-cyan);
        }

        .stat-trend.down {
            background: rgba(241, 91, 181, 0.15);
            color: var(--accent-pink);
        }

        .stat-content h3 {
            font-size: 13px;
            font-weight: 500;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }

        .stat-content p {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 36px;
            font-weight: 700;
            color: var(--text-bright);
        }

        /* SPLIT LAYOUT */
        .split-layout {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 30px;
            align-items: start;
        }

        @media (max-width: 1200px) {
            .split-layout {
                grid-template-columns: 1fr;
            }
        }

        /* STORIES SECTION */
        .stories-section {
            background: var(--bg-card);
            border-radius: 20px;
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 24px 28px;
            border-bottom: 1px solid var(--border-color);
        }

        .section-title {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 20px;
            font-weight: 600;
            color: var(--text-bright);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: var(--accent-cyan);
        }

        .section-link {
            font-size: 13px;
            color: var(--accent-blue);
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: var(--transition);
        }

        .section-link:hover {
            color: var(--accent-cyan);
        }

        .story-list {
            max-height: 520px;
            overflow-y: auto;
            padding: 20px;
        }

        .story-list::-webkit-scrollbar {
            width: 6px;
        }

        .story-list::-webkit-scrollbar-track {
            background: var(--bg-darker);
            border-radius: 3px;
        }

        .story-list::-webkit-scrollbar-thumb {
            background: var(--border-light);
            border-radius: 3px;
        }

        .story-card {
            background: var(--bg-darker);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 16px;
            transition: var(--transition);
            position: relative;
        }

        .story-card:hover {
            border-color: var(--accent-blue);
            box-shadow: 0 4px 20px rgba(0, 187, 249, 0.15);
        }

        .story-card.winner {
            background: linear-gradient(135deg, rgba(0, 245, 212, 0.08) 0%, rgba(0, 187, 249, 0.08) 100%);
            border-color: var(--accent-cyan);
        }

        .story-card.winner::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background: linear-gradient(180deg, var(--accent-cyan), var(--accent-blue));
            border-radius: 16px 0 0 16px;
        }

        .story-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }

        .story-author {
            font-size: 12px;
            font-weight: 600;
            color: var(--accent-cyan);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .story-author i {
            font-size: 10px;
        }

        .story-date {
            font-size: 11px;
            color: var(--text-muted);
        }

        .story-title {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 17px;
            font-weight: 600;
            color: var(--text-bright);
            margin-bottom: 10px;
            line-height: 1.4;
        }

        .story-content {
            font-size: 14px;
            color: var(--text-secondary);
            line-height: 1.6;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            margin-bottom: 16px;
        }

        .story-actions {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .btn-set-winner {
            padding: 8px 16px;
            background: linear-gradient(135deg, var(--accent-cyan) 0%, var(--accent-blue) 100%);
            color: var(--bg-dark);
            border: none;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: var(--transition);
            font-family: inherit;
        }

        .btn-set-winner:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0, 245, 212, 0.4);
        }

        .winner-badge {
            background: linear-gradient(135deg, var(--accent-cyan) 0%, var(--accent-blue) 100%);
            color: var(--bg-dark);
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        /* ACTIONS SECTION */
        .actions-section {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .actions-title {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 20px;
            font-weight: 600;
            color: var(--text-bright);
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .actions-title i {
            color: var(--accent-purple);
        }

        .action-card {
            background: var(--bg-card);
            border-radius: 16px;
            padding: 24px;
            border: 1px solid var(--border-color);
            text-decoration: none;
            color: inherit;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .action-card:hover {
            transform: translateY(-4px);
            border-color: var(--accent-cyan);
            box-shadow: var(--glow-cyan);
        }

        .action-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            margin-bottom: 16px;
        }

        .action-card:nth-child(2) .action-icon {
            background: rgba(0, 245, 212, 0.15);
            color: var(--accent-cyan);
        }

        .action-card:nth-child(3) .action-icon {
            background: rgba(0, 187, 249, 0.15);
            color: var(--accent-blue);
        }

        .action-card:nth-child(4) .action-icon {
            background: rgba(155, 93, 229, 0.15);
            color: var(--accent-purple);
        }

        .action-card:nth-child(5) .action-icon {
            background: rgba(241, 91, 181, 0.15);
            color: var(--accent-pink);
        }

        .action-card h3 {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 18px;
            font-weight: 600;
            color: var(--text-bright);
            margin-bottom: 6px;
        }

        .action-card p {
            font-size: 13px;
            color: var(--text-muted);
            line-height: 1.5;
        }

        .action-arrow {
            position: absolute;
            right: 24px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            transition: var(--transition);
        }

        .action-card:hover .action-arrow {
            color: var(--accent-cyan);
            transform: translateY(-50%) translateX(4px);
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .stat-card, .stories-section, .action-card {
            animation: fadeInUp 0.5s ease forwards;
        }

        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stories-section { animation-delay: 0.3s; }
        .action-card:nth-child(2) { animation-delay: 0.35s; }
        .action-card:nth-child(3) { animation-delay: 0.4s; }
        .action-card:nth-child(4) { animation-delay: 0.45s; }
        .action-card:nth-child(5) { animation-delay: 0.5s; }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                animation-duration: 0.01ms !important;
                transition-duration: 0.01ms !important;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 20px;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }
            
            .page-header h1 {
                font-size: 28px;
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
            <a href="adminDashboard.jsp" class="nav-item active">
                <i class="fas fa-th-large"></i>
                <span>Dashboard</span>
            </a>
            <a href="addBook.jsp" class="nav-item">
                <i class="fas fa-plus-circle"></i>
                <span>Add Book</span>
            </a>
            <a href="viewBooks.jsp" class="nav-item">
                <i class="fas fa-book"></i>
                <span>Manage Books</span>
            </a>
        </div>
        
        <div class="nav-section">
            <div class="nav-section-title">Operations</div>
            <a href="adminOrders.jsp" class="nav-item">
                <i class="fas fa-shopping-bag"></i>
                <span>Orders</span>
                <span class="nav-badge">5</span>
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
        <div>
            <h1>Welcome back, Admin</h1>
            <p>Here's what's happening with your store today.</p>
        </div>
        <div class="header-date">
            <i class="fas fa-calendar-alt"></i>
            <span><%= new java.text.SimpleDateFormat("EEEE, MMMM d, yyyy").format(new java.util.Date()) %></span>
        </div>
    </div>

    <!-- STATS -->
    <div class="stats-grid">
        <div class="stat-card sales">
            <div class="stat-header">
                <div class="stat-icon">
                    <i class="fas fa-rupee-sign"></i>
                </div>
                <span class="stat-trend up">
                    <i class="fas fa-arrow-up"></i> 12%
                </span>
            </div>
            <div class="stat-content">
                <h3>Total Sales</h3>
                <p><%= totalSales %></p>
            </div>
        </div>
        
        <div class="stat-card orders">
            <div class="stat-header">
                <div class="stat-icon">
                    <i class="fas fa-box"></i>
                </div>
                <span class="stat-trend up">
                    <i class="fas fa-arrow-up"></i> 8%
                </span>
            </div>
            <div class="stat-content">
                <h3>Total Orders</h3>
                <p><%= totalOrders %></p>
            </div>
        </div>
    </div>

    <!-- SPLIT LAYOUT -->
    <div class="split-layout">
        
        <!-- LEFT: STORIES -->
        <div class="stories-section">
            <div class="section-header">
                <h2 class="section-title">
                    <i class="fas fa-feather-alt"></i>
                    Recent Stories
                </h2>
                <a href="adminStory.jsp" class="section-link">
                    View All <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            
            <div class="story-list">
                <%
                while(rsStories.next()){
                    int storyId = rsStories.getInt("id");
                    String storyTitle = rsStories.getString("title");
                    String storyAuthor = rsStories.getString("email");
                    String storyContent = rsStories.getString("content");
                    boolean isWinner = rsStories.getInt("is_winner") == 1;
                %>
                
                <div class="story-card <%= isWinner ? "winner" : "" %>">
                    <div class="story-meta">
                        <span class="story-author">
                            <i class="fas fa-circle"></i> <%= storyAuthor %>
                        </span>
                        <span class="story-date"><%= rsStories.getString("date") %></span>
                    </div>
                    <h4 class="story-title"><%= storyTitle %></h4>
                    <div class="story-content"><%= storyContent %></div>
                    
                    <div class="story-actions">
                        <% if(isWinner){ %>
                            <span class="winner-badge">
                                <i class="fas fa-trophy"></i> Winner
                            </span>
                        <% } else { %>
                            <a href="selectWinner.jsp?id=<%= storyId %>" class="btn-set-winner" onclick="return confirm('Set this story as winner?')">
                                <i class="fas fa-crown"></i> Set as Winner
                            </a>
                        <% } %>
                    </div>
                </div>
                
                <%
                }
                rsStories.close();
                psStories.close();
                con.close();
                %>
            </div>
        </div>

        <!-- RIGHT: QUICK ACTIONS -->
        <div class="actions-section">
            <h2 class="actions-title">
                <i class="fas fa-bolt"></i>
                Quick Actions
            </h2>
            
            <a href="addBook.jsp" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-plus"></i>
                </div>
                <h3>Add New Book</h3>
                <p>Add new titles to your inventory collection</p>
                <i class="fas fa-arrow-right action-arrow"></i>
            </a>

            <a href="viewBooks.jsp" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-books"></i>
                </div>
                <h3>Manage Books</h3>
                <p>Edit, update or remove existing books</p>
                <i class="fas fa-arrow-right action-arrow"></i>
            </a>

            <a href="adminOrders.jsp" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-truck"></i>
                </div>
                <h3>Process Orders</h3>
                <p>View and manage customer orders</p>
                <i class="fas fa-arrow-right action-arrow"></i>
            </a>

            <a href="adminStory.jsp" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-feather-alt"></i>
                </div>
                <h3>Review Stories</h3>
                <p>Manage user submitted stories</p>
                <i class="fas fa-arrow-right action-arrow"></i>
            </a>
        </div>

    </div>

</main>

</body>
</html>