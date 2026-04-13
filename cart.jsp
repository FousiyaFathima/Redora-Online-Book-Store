<%@ page import="java.sql.*, db.DBConnections" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
// Prevent caching
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

String email = (String) session.getAttribute("email");
if(email == null){
    response.sendRedirect("login.jsp");
    return;
}

// Calculate Nav Cart Count
int count = 0;
Connection conNav = null;
try {
    conNav = DBConnections.getConnection();
    PreparedStatement psNav = conNav.prepareStatement("SELECT SUM(qty) FROM cart WHERE email=?");
    psNav.setString(1, email);
    ResultSet rsNav = psNav.executeQuery();
    if(rsNav.next()){ count = rsNav.getInt(1); }
    psNav.close();
} catch(Exception e){ e.printStackTrace(); }
finally { if(conNav != null) conNav.close(); }


Connection con = DBConnections.getConnection();
PreparedStatement ps = con.prepareStatement("SELECT * FROM cart WHERE email=?");
ps.setString(1,email);
ResultSet rs = ps.executeQuery();

int total = 0;
%>
<!DOCTYPE html>
<html>
<head>
<title>My Cart</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;0,700;1,400&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<style>
/* --- VARIABLES --- */
:root {
    --primary-bg: #F9F7F2;
    --text-dark: #2C2C2C;
    --accent-wine: #722F37;
    --accent-gold: #C5A059;
}

* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: 'Lato', sans-serif;
    background-color: var(--primary-bg);
    background-image: url('https://www.transparenttextures.com/patterns/cream-paper.png');
    color: var(--text-dark);
    min-height: 100vh;
}

/* --- NAVBAR --- */
.navbar{
    display: flex; justify-content: space-between; align-items: center;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
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

/* --- CONTAINER --- */
.main-container {
    max-width: 900px;
    margin: 120px auto 50px auto;
    padding: 0 20px;
}

.page-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 42px;
    color: var(--accent-wine);
    text-align: center;
    margin-bottom: 50px;
}

/* --- CART ITEMS --- */
.cart-item {
    background: white;
    border-radius: 10px;
    padding: 25px;
    margin-bottom: 25px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.05);
    display: flex;
    align-items: center;
    gap: 30px;
    transition: transform 0.3s;
    border: 1px solid rgba(197, 160, 89, 0.1);
}

.cart-item:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
}

.item-image {
    width: 100px;
    height: 140px;
    object-fit: cover;
    border-radius: 6px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}

.item-details {
    flex-grow: 1;
}

.item-details h3 {
    font-family: 'Cormorant Garamond', serif;
    font-size: 24px;
    margin-bottom: 5px;
    color: var(--text-dark);
}

.item-price {
    font-size: 16px;
    color: #666;
    margin-bottom: 15px;
}

.item-total {
    font-weight: 700;
    color: var(--accent-wine);
    font-size: 18px;
    margin-top: 10px;
}

/* --- QUANTITY CONTROLS --- */
.qty-controls {
    display: flex;
    align-items: center;
    gap: 15px;
    margin-top: 10px;
}

.qty-btn {
    width: 32px;
    height: 32px;
    border: 1px solid #ddd;
    background: white;
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
    transition: all 0.2s;
    text-decoration: none;
    color: var(--text-dark);
    display: flex;
    align-items: center;
    justify-content: center;
}

.qty-btn:hover {
    background: var(--accent-gold);
    color: white;
    border-color: var(--accent-gold);
}

.qty-display {
    font-size: 18px;
    font-weight: 600;
    min-width: 30px;
    text-align: center;
}

/* --- REMOVE BUTTON --- */
.remove-btn {
    background: transparent;
    color: #D32F2F;
    border: 1px solid #D32F2F;
    padding: 8px 20px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    transition: all 0.3s;
    margin-left: auto; 
    align-self: center;
}

.remove-btn:hover {
    background: #D32F2F;
    color: white;
}

/* --- CART SUMMARY --- */
.cart-summary {
    background: white;
    padding: 40px;
    border-radius: 10px;
    text-align: right;
    margin-top: 40px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    border-top: 3px solid var(--accent-gold);
}

.total-label {
    font-family: 'Cormorant Garamond', serif;
    font-size: 24px;
    color: #666;
}

.total-amount {
    font-family: 'Cormorant Garamond', serif;
    font-size: 36px;
    color: var(--accent-wine);
    font-weight: 700;
    margin-bottom: 30px;
}

.action-btns {
    display: flex;
    justify-content: flex-end;
    gap: 20px;
}

.btn {
    padding: 14px 40px;
    border-radius: 30px;
    text-decoration: none;
    font-weight: 600;
    font-size: 14px;
    text-transform: uppercase;
    letter-spacing: 1px;
    transition: all 0.3s;
    cursor: pointer;
    border: none;
}

.btn-primary {
    background: var(--accent-wine);
    color: white;
    box-shadow: 0 5px 15px rgba(114, 47, 55, 0.2);
}

.btn-primary:hover {
    background: #5a2429;
    transform: translateY(-2px);
}

.btn-secondary {
    background: transparent;
    color: var(--text-dark);
    border: 2px solid var(--text-dark);
}

.btn-secondary:hover {
    background: var(--text-dark);
    color: white;
}

/* Empty Cart */
.empty-cart {
    text-align: center;
    margin-top: 100px;
    font-size: 18px;
    color: #888;
}

/* Responsive */
@media (max-width: 768px) {
    .cart-item { flex-direction: column; text-align: center; }
    .item-details { width: 100%; }
    .qty-controls { justify-content: center; }
    .remove-btn { margin-left: 0; margin-top: 15px; }
    .action-btns { flex-direction: column; }
}
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
            <a href="cart.jsp" class="cart-icon">🛒
                <span class="cart-count"><%=count%></span>
            </a>
            <a href="wishlist.jsp">Wishlist</a>
            <a href="profile.jsp">👤</a>
        </div>
    </div>
</header>

<div class="main-container">
    <h1 class="page-title">My Cart</h1>

    <%
    boolean hasItems = false;
    while(rs.next()){
        hasItems = true;
        int id = rs.getInt("id");
        int price = rs.getInt("price");
        int qty = rs.getInt("qty");
        int itemTotal = price * qty;
        total += itemTotal;
    %>

    <div class="cart-item">
        <img class="item-image" src="<%=rs.getString("image")%>" alt="Book">
        
        <div class="item-details">
            <h3><%=rs.getString("book")%></h3>
            <p class="item-price">₹<%=price%></p>
            
            <div class="qty-controls">
                <a href="updateQtyDB.jsp?id=<%=id%>&action=dec" class="qty-btn">-</a>
                <span class="qty-display"><%=qty%></span>
                <a href="updateQtyDB.jsp?id=<%=id%>&action=inc" class="qty-btn">+</a>
            </div>
            
            <p class="item-total">Total: ₹<%=itemTotal%></p>
        </div>

        <a href="removeCart.jsp?id=<%=id%>"><button class="remove-btn">Remove</button></a>
    </div>

    <%
    } 
    rs.close();
    ps.close();
    con.close();
    
    if(!hasItems) {
    %>
        <div class="empty-cart">
            <h3>Your cart is empty.</h3>
            <p style="margin-top:10px;"><a href="collection.jsp" style="color:var(--accent-wine);">Start Shopping</a></p>
        </div>
    <%
    }
    %>

    <% if(hasItems) { %>
    <div class="cart-summary">
        <span class="total-label">Subtotal</span><br>
        <span class="total-amount">₹ <%=total%></span><br><br><br>
        
        <div class="action-btns">
            <a href="category.jsp" class="btn btn-secondary">Continue Shopping</a><br><br>
            <a href="order.jsp" class="btn btn-primary">Proceed to Buy</a>
        </div>
    </div>
    <% } %>

</div>

</body>
</html>