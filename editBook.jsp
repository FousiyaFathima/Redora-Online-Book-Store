<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DBConnections" %>

<%
if(session.getAttribute("admin")==null){
    response.sendRedirect("login.jsp");
    return;
}

String id = request.getParameter("id");
Connection con = DBConnections.getConnection();
PreparedStatement ps = con.prepareStatement("SELECT * FROM books WHERE id=?");
ps.setString(1, id);
ResultSet rs = ps.executeQuery();

if(rs.next()){
    String title = rs.getString("title");
    int price = rs.getInt("price");
    int stock = rs.getInt("stock");
    String image = rs.getString("image");
    String type = rs.getString("type");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Book | Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
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
            --shadow-lg: 0 10px 40px rgba(0,0,0,0.5);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, var(--bg-dark) 0%, var(--bg-darker) 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
            position: relative;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: 
                radial-gradient(ellipse at 20% 80%, rgba(155, 93, 229, 0.1) 0%, transparent 50%),
                radial-gradient(ellipse at 80% 20%, rgba(241, 91, 181, 0.1) 0%, transparent 50%);
            pointer-events: none;
        }

        .form-container {
            background: var(--bg-card);
            border-radius: 24px;
            box-shadow: var(--shadow-lg);
            width: 100%;
            max-width: 520px;
            position: relative;
            overflow: hidden;
            border: 1px solid var(--border-color);
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--accent-purple), var(--accent-pink));
        }

        .form-header {
            padding: 40px 40px 30px;
            text-align: center;
            border-bottom: 1px solid var(--border-color);
        }

        .form-icon {
            width: 72px;
            height: 72px;
            background: linear-gradient(135deg, rgba(155, 93, 229, 0.2) 0%, rgba(241, 91, 181, 0.2) 100%);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 28px;
            color: var(--accent-purple);
            box-shadow: 0 0 30px rgba(155, 93, 229, 0.2);
        }

        .form-header h2 {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 28px;
            font-weight: 700;
            color: var(--text-bright);
            margin-bottom: 8px;
        }

        .form-header p {
            font-size: 14px;
            color: var(--text-muted);
        }

        .form-body {
            padding: 30px 40px 40px;
        }

        .form-group {
            margin-bottom: 24px;
        }

        label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-secondary);
            margin-bottom: 10px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--accent-purple);
            font-size: 14px;
        }

        input[type="text"],
        input[type="number"] {
            width: 100%;
            padding: 14px 16px 14px 44px;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            font-size: 15px;
            font-family: inherit;
            transition: var(--transition);
            background: var(--bg-input);
            color: var(--text-primary);
        }

        input:focus {
            outline: none;
            border-color: var(--accent-purple);
            background: var(--bg-darker);
            box-shadow: 0 0 20px rgba(155, 93, 229, 0.15);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .btn-submit {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, var(--accent-purple) 0%, var(--accent-pink) 100%);
            color: var(--text-bright);
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-top: 10px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(155, 93, 229, 0.4);
        }

        .back-link {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 24px;
            font-size: 14px;
            color: var(--text-muted);
            text-decoration: none;
            transition: var(--transition);
        }

        .back-link:hover {
            color: var(--accent-purple);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-container {
            animation: fadeIn 0.5s ease forwards;
        }

        @media (max-width: 520px) {
            .form-header, .form-body { padding-left: 24px; padding-right: 24px; }
            .form-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<div class="form-container">
    <div class="form-header">
        <div class="form-icon">
            <i class="fas fa-edit"></i>
        </div>
        <h2>Edit Book</h2>
        <p>Update the book information below</p>
    </div>

    <div class="form-body">
        <form action="editBookDB.jsp" method="post">
            <input type="hidden" name="id" value="<%= id %>">
            
            <div class="form-group">
                <label>Book Title</label>
                <div class="input-wrapper">
                    <i class="fas fa-book"></i>
                    <input type="text" name="title" value="<%= title %>" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Price (₹)</label>
                    <div class="input-wrapper">
                        <i class="fas fa-rupee-sign"></i>
                        <input type="number" name="price" value="<%= price %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Stock</label>
                    <div class="input-wrapper">
                        <i class="fas fa-boxes"></i>
                        <input type="number" name="stock" value="<%= stock %>" required>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label>Image URL</label>
                <div class="input-wrapper">
                    <i class="fas fa-image"></i>
                    <input type="text" name="image" value="<%= image %>">
                </div>
            </div>

            <div class="form-group">
                <label>Category</label>
                <div class="input-wrapper">
                    <i class="fas fa-tag"></i>
                    <input type="text" name="type" value="<%= type %>" required>
                </div>
            </div>

            <button type="submit" class="btn-submit">
                <i class="fas fa-save"></i>
                Save Changes
            </button>
        </form>

        <a href="viewBooks.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i>
            Back to Book Management
        </a>
    </div>
</div>

</body>
</html>

<%
}
rs.close();
ps.close();
con.close();
%>