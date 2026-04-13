<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Admin Login</title>

<style>

body{
margin:0;
font-family:'Segoe UI';
height:100vh;
display:flex;
justify-content:center;
align-items:center;
background:linear-gradient(135deg,#020617,#0f172a);
color:white;
}

/* LOGIN BOX */
.login-box{
background:#1e293b;
padding:40px;
width:320px;
border-radius:12px;
box-shadow:0 10px 30px rgba(0,0,0,0.7);
text-align:center;
border:1px solid #334155;
}

/* TITLE */
.login-box h2{
margin-bottom:25px;
color:#38bdf8;
}

/* INPUT */
input{
width:100%;
padding:12px;
margin:10px 0;
border-radius:6px;
border:2px solid #334155;
background:#020617;
color:white;
font-size:14px;
}

/* FOCUS EFFECT */
input:focus{
outline:none;
border:2px solid #38bdf8;
}

/* BUTTON */
button{
width:100%;
padding:12px;
margin-top:15px;
background:#d4af37;
border:none;
border-radius:8px;
font-size:16px;
cursor:pointer;
font-weight:bold;
}

button:hover{
background:#b8962e;
}

/* OPTIONAL ERROR MESSAGE */
.error{
color:red;
font-size:13px;
margin-top:10px;
}

</style>

</head>

<body>

<div class="login-box">

<form action="AdminLoginServlet" method="post">

<h2>Admin Login 🔐</h2>

<input type="text" name="username" placeholder="Username" required>

<input type="password" name="password" placeholder="Password" required>

<button type="submit">Login</button>

<!-- Optional error -->
<!-- <div class="error">Invalid login</div> -->

</form>

</div>

</body>
</html>