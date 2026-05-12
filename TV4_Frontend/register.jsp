<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản</title>
    <style>
        body { margin: 0; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f0f2f5; font-family: Arial, sans-serif; }
        .login-card { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 350px; text-align: center; }
        input { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background-color: #28a745; border: none; border-radius: 5px; color: white; cursor: pointer; font-size: 16px; }
        .error { color: red; font-size: 14px; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="login-card">
        <h2>Đăng ký</h2>
        <div class="error">${error}</div>
        <form action="RegisterServlet" method="POST">
            <input type="text" name="user" placeholder="Username" required>
            <input type="email" name="email" placeholder="Email (ví dụ: hieu@gmail.com)" required>
            <input type="password" name="pass" placeholder="Password" required>
            <input type="password" name="repass" placeholder="Nhập lại Password" required>
            <button type="submit">Đăng ký ngay</button>
        </form>
        <p style="margin-top:15px; font-size:14px;">
            Đã có tài khoản? <a href="login.jsp" style="text-decoration:none;">Đăng nhập</a>
        </p>
    </div>
</body>
</html>