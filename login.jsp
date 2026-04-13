<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Login</title>

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;600;700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">

<!-- Font Awesome for Eye Icon -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
/* --- VARIABLES --- */
:root {
    --primary-bg: #F9F7F2;
    --text-dark: #2C2C2C;
    --accent-wine: #722F37;
    --accent-gold: #C5A059;
    --input-bg: #FFFFFF;
}

body{
    font-family: 'Lato', sans-serif;
    background-color: var(--primary-bg);
    margin: 0;
    padding: 0;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background-image: url('https://www.toptal.com/designers/subtlepatterns/patterns/cream_paper.png');
}

/* Main Container holding Image and Form */
.main-container {
    display: flex;
    width: 900px;
    height: 550px;
    background: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 20px 60px rgba(0,0,0,0.15);
}

/* Left Side Image */
.image-side {
    flex: 1;
    background-image: url('https://images.unsplash.com/photo-1512820790803-83ca734da794?ixlib=rb-4.0.3&auto=format&fit=crop&w=680&q=80');
    background-size: cover;
    background-position: center;
    position: relative;
}

.image-side::after {
    content: '';
    position: absolute;
    top: 0; left: 0; width: 100%; height: 100%;
    background: linear-gradient(to right, rgba(0,0,0,0.1), rgba(0,0,0,0.4));
}

/* Right Side Form */
.form-side {
    flex: 1;
    padding: 60px 50px;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

h2{
    font-family: 'Cormorant Garamond', serif;
    font-size: 36px;
    color: var(--accent-wine);
    text-align: center;
    margin-bottom: 30px;
    font-weight: 700;
}

.input-group {
    margin-bottom: 20px;
    position: relative;
}

input{
    width: 100%;
    padding: 14px 20px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-family: 'Lato', sans-serif;
    font-size: 14px;
    transition: all 0.3s;
    box-sizing: border-box; /* Important for padding */
}

input:focus {
    outline: none;
    border-color: var(--accent-gold);
    box-shadow: 0 0 10px rgba(197, 160, 89, 0.2);
}

/* Password Toggle Styling */
.password-wrapper {
    position: relative;
}

.password-wrapper input {
    padding-right: 45px; /* Space for icon */
}

.toggle-password {
    position: absolute;
    top: 50%;
    right: 15px;
    transform: translateY(-50%);
    cursor: pointer;
    color: #999;
    font-size: 16px;
    transition: color 0.3s;
}

.toggle-password:hover {
    color: var(--accent-wine);
}

/* Buttons */
button{
    width: 100%;
    padding: 14px;
    background: var(--accent-wine);
    color: white;
    border: none;
    border-radius: 30px;
    font-weight: 600;
    font-size: 14px;
    text-transform: uppercase;
    letter-spacing: 2px;
    cursor: pointer;
    transition: all 0.3s;
    margin-top: 10px;
}

button:hover{
    background: #5a2429;
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(114, 47, 55, 0.3);
}

p{
    text-align: center;
    margin-top: 25px;
    font-size: 14px;
    color: #666;
}

a{
    color: var(--accent-wine);
    text-decoration: none;
    font-weight: 700;
    border-bottom: 1px solid transparent;
    transition: border 0.3s;
}

a:hover {
    border-bottom: 1px solid var(--accent-wine);
}

.error{
    color: #D32F2F;
    text-align: center;
    margin-bottom: 15px;
    font-size: 13px;
    background: rgba(211, 47, 47, 0.05);
    padding: 10px;
    border-radius: 4px;
}

/* Responsive */
@media (max-width: 768px) {
    .main-container {
        flex-direction: column;
        width: 90%;
        height: auto;
    }
    .image-side {
        min-height: 200px;
    }
    .form-side {
        padding: 40px 30px;
    }
}
</style>

</head>

<body>

<div class="main-container">
    <!-- Left Side Image -->
    <div class="image-side"></div>

    <!-- Right Side Form -->
    <div class="form-side">
        <h2>Welcome Back</h2>

        <%
        String error=request.getParameter("error");
        if(error!=null){
        %>
        <p class="error">Invalid Login! Please Register</p>
        <%
        }
        %>
        
        <form action="<%=request.getContextPath()%>/LoginServlet" method="post">
            <div class="input-group">
                <input type="email" name="email" placeholder="Email Address" required>
            </div>
            
            <div class="input-group password-wrapper">
                <input type="password" id="passwordInput" name="password" placeholder="Password" required>
                <i class="toggle-password fas fa-eye-slash" onclick="togglePassword()"></i>
            </div>

            <button type="submit">Login</button>
        </form>

        <p>New user? <a href="register.jsp">Register here</a></p>
    </div>
</div>

<script>
function togglePassword() {
    var x = document.getElementById("passwordInput");
    var icon = document.querySelector(".toggle-password");
    if (x.type === "password") {
        x.type = "text";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    } else {
        x.type = "password";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    }
}
</script>

</body>
</html>