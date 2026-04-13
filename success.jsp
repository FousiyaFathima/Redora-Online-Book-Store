<%@ page import="java.sql.*, db.DBConnections, java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String email = (String)session.getAttribute("email");

if(email == null){
    response.sendRedirect("login.jsp");
    return;
}

Connection con = null;
PreparedStatement psCheck = null;
PreparedStatement psInsert = null;
PreparedStatement psDelete = null;
ResultSet rs = null;

try {
    con = DBConnections.getConnection();
    
    // 1. START TRANSACTION
    con.setAutoCommit(false);

    // CHECK IF CART HAS ITEMS
    psCheck = con.prepareStatement("SELECT * FROM cart WHERE email=?");
    psCheck.setString(1, email);
    rs = psCheck.executeQuery();

    if(!rs.next()){
        response.sendRedirect("cart.jsp");
        return;
    }

    // GENERATE ORDER ID
    String orderId = "ORD" + System.currentTimeMillis();
    
    // GET CURRENT TIME
    Timestamp orderDate = new Timestamp(new Date().getTime());

    // PREPARE INSERT STATEMENT
    String insertSQL = "INSERT INTO orders(order_id, email, book, price, qty, total, image, payment_status, delivery_status, order_date) VALUES(?,?,?,?,?,?,?,?,?,?)";
    psInsert = con.prepareStatement(insertSQL);

    // RE-ITERATE THROUGH CART
    do {
        int price = rs.getInt("price");
        int qty = rs.getInt("qty");
        int total = price * qty;

        psInsert.setString(1, orderId);
        psInsert.setString(2, email);
        psInsert.setString(3, rs.getString("book"));
        psInsert.setInt(4, price);
        psInsert.setInt(5, qty);
        psInsert.setInt(6, total);
        psInsert.setString(7, rs.getString("image"));
        psInsert.setString(8, "Paid");
        psInsert.setString(9, "Processing");
        psInsert.setTimestamp(10, orderDate);

        psInsert.addBatch();
        
    } while(rs.next());

    // EXECUTE BATCH
    psInsert.executeBatch();

    // CLEAR CART
    psDelete = con.prepareStatement("DELETE FROM cart WHERE email=?");
    psDelete.setString(1, email);
    psDelete.executeUpdate();

    // COMMIT
    con.commit();

%>

<!DOCTYPE html>
<html>
<head>
    <title>Order Success</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;0,700;1,400&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
    
    <style>
        /* --- VARIABLES --- */
        :root {
            --primary-bg: #F9F7F2;
            --text-dark: #2C2C2C;
            --accent-wine: #722F37;
            --accent-gold: #C5A059;
            --glow-gold: rgba(197, 160, 89, 0.6);
            --success-green: #198754;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Lato', sans-serif;
            background-color: var(--primary-bg);
            /* Light Aesthetic Background Texture */
            background-image: url('https://www.transparenttextures.com/patterns/cream-paper.png');
            color: var(--text-dark);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        /* CONTAINER */
        .container {
            text-align: center;
            animation: fadeIn 0.8s ease-out;
            padding: 20px;
            width: 100%;
            max-width: 500px;
        }

        /* --- CARD WITH NEON GOLD BORDER --- */
        .box {
            background: rgba(255, 255, 255, 0.95);
            padding: 50px 40px;
            border-radius: 12px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.08);
            
            /* NEON GOLDEN BORDER GLOW */
            border: 2px solid var(--accent-gold);
            box-shadow: 
                0 0 15px var(--glow-gold),   /* Inner Glow */
                0 0 35px rgba(197, 160, 89, 0.3), /* Outer Glow */
                0 20px 40px rgba(0,0,0,0.05);    /* Depth Shadow */
        }

        /* ANIMATED SUCCESS ICON */
        .icon-container {
            width: 90px;
            height: 90px;
            background: rgba(25, 135, 84, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            border: 2px solid var(--success-green);
            animation: scaleUp 0.5s ease-out;
        }

        .checkmark {
            width: 45px;
            height: 22px;
            border-left: 4px solid var(--success-green);
            border-bottom: 4px solid var(--success-green);
            transform: rotate(-45deg) translateY(-5px);
            animation: checkDraw 0.5s ease-out forwards;
        }

        /* TEXT STYLES */
        h1 {
            font-family: 'Cormorant Garamond', serif;
            color: var(--success-green);
            font-size: 36px;
            margin-bottom: 10px;
            font-weight: 700;
        }

        p.subtitle {
            color: #6c757d;
            margin-bottom: 35px;
            font-size: 16px;
            font-style: italic;
        }

        /* ORDER DETAILS SECTION */
        .details-box {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 8px;
            margin-bottom: 35px;
            text-align: left;
            border: 1px solid #eee;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 15px;
            border-bottom: 1px dashed #dee2e6;
            padding-bottom: 8px;
        }

        .detail-row:last-child { margin-bottom: 0; border-bottom: none; padding-bottom: 0; }
        .label { color: #6c757d; font-weight: 400; }
        .value { color: var(--text-dark); font-weight: 700; font-family: 'Lato', sans-serif; }

        /* BUTTONS */
        .actions {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .btn {
            display: block;
            padding: 16px 20px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-primary {
            background: var(--accent-wine);
            color: white;
            box-shadow: 0 4px 14px rgba(114, 47, 55, 0.2);
        }

        .btn-primary:hover {
            background: #5a2429;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(114, 47, 55, 0.3);
        }

        .btn-secondary {
            background: transparent;
            color: var(--text-dark);
            border: 2px solid #ddd;
        }

        .btn-secondary:hover {
            background: #f1f1f1;
            border-color: #ccc;
        }

        /* ANIMATIONS */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes scaleUp {
            0% { transform: scale(0); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        @keyframes checkDraw {
            0% { width: 0; height: 0; opacity: 0; }
            50% { width: 0; height: 22px; opacity: 1; }
            100% { width: 45px; height: 22px; opacity: 1; }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="box">
        
        <!-- Custom Animated Icon -->
        <div class="icon-container">
            <div class="checkmark"></div>
        </div>

        <h1>Order Placed!</h1>
        <p class="subtitle">Thank you for shopping with us. Your adventure begins now.</p>

        <div class="details-box">
            <div class="detail-row">
                <span class="label">Order ID:</span>
                <span class="value"><%= orderId %></span>
            </div>
            <div class="detail-row">
                <span class="label">Date:</span>
                <span class="value"><%= orderDate %></span>
            </div>
            <div class="detail-row">
                <span class="label">Status:</span>
                <span class="value" style="color: #d4a017;">Processing</span>
            </div>
        </div>

        <div class="actions">
            <a href="orders.jsp" class="btn btn-primary">View Orders</a>
            <a href="collection.jsp" class="btn btn-secondary">Continue Shopping</a>
        </div>

    </div>
</div>

</body>
</html>

<%
} catch(Exception e) {
    if(con != null) {
        try { con.rollback(); } catch(Exception ex) {}
    }
    out.println("<div style='color:#721c24; text-align:center; margin-top:50px; background:#f8d7da; padding:20px; border-radius:10px; border:1px solid #f5c6cb; max-width:400px; margin:auto;'><h3>Error Occurred</h3><p>" + e.getMessage() + "</p></div>");
    e.printStackTrace();
} finally {
    if(rs != null) try { rs.close(); } catch(Exception e){}
    if(psCheck != null) try { psCheck.close(); } catch(Exception e){}
    if(psInsert != null) try { psInsert.close(); } catch(Exception e){}
    if(psDelete != null) try { psDelete.close(); } catch(Exception e){}
    if(con != null) try { con.close(); } catch(Exception e){}
}
%>