<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    String loginType = request.getParameter("type");
    if (loginType == null) loginType = "junior";
    request.setAttribute("loginType", loginType);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${loginType == 'senior' ? 'Senior Admin' : 'Staff'} Login - KS.Studio</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Poppins:wght@300;400;500;600;700&family=Josefin+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --senior-color: #ff6b6b;
            --junior-color: #ffd93d;
        }
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .login-container {
            background: #fff;
            border-radius: 25px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.4);
            overflow: hidden;
            width: 100%;
            max-width: 420px;
        }
        .login-header {
            padding: 40px;
            text-align: center;
            color: #fff;
        }
        .login-header.senior {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a5a 100%);
        }
        .login-header.junior {
            background: linear-gradient(135deg, #ffd93d 0%, #ffcd00 100%);
        }
        .login-header.junior h1, .login-header.junior p {
            color: #333;
        }
        .login-header .icon-wrapper {
            width: 80px;
            height: 80px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 2rem;
        }
        .login-header h1 {
            font-family: 'Josefin Sans', sans-serif;
            font-size: 1.6rem;
            margin-bottom: 5px;
        }
        .login-body { padding: 40px; }
        .form-group { margin-bottom: 20px; }
        .form-group label {
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
            display: block;
        }
        .form-control {
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            padding: 14px 18px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        .form-control:focus.senior-focus {
            border-color: var(--senior-color);
            box-shadow: 0 0 0 4px rgba(255, 107, 107, 0.1);
        }
        .form-control:focus.junior-focus {
            border-color: var(--junior-color);
            box-shadow: 0 0 0 4px rgba(255, 217, 61, 0.1);
        }
        .btn-login {
            color: #fff;
            border: none;
            border-radius: 12px;
            padding: 16px;
            font-size: 1rem;
            font-weight: 600;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .btn-login.senior {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a5a 100%);
        }
        .btn-login.junior {
            background: linear-gradient(135deg, #ffd93d 0%, #ffcd00 100%);
            color: #333;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .alert { border-radius: 12px; margin-bottom: 20px; }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 25px;
            color: #666;
            text-decoration: none;
            font-family: 'Poppins', sans-serif;
        }
        .back-link:hover { color: #333; }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header ${loginType}">
            <div class="icon-wrapper">
                <i class="bi ${loginType == 'senior' ? 'bi-shield-check' : 'bi-camera-reels'}"></i>
            </div>
            <h1>KS.STUDIO</h1>
            <p>${loginType == 'senior' ? 'Senior Admin Portal' : 'Staff Portal'}</p>
        </div>
        
        <div class="login-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/login" method="post">
                <input type="hidden" name="loginType" value="${loginType}">
                
                <div class="form-group">
                    <label for="email"><i class="bi bi-envelope"></i> Email Address</label>
                    <input type="email" class="form-control ${loginType}-focus" id="email" name="email" placeholder="Enter your email" required>
                </div>
                
                <div class="form-group">
                    <label for="password"><i class="bi bi-lock"></i> Password</label>
                    <input type="password" class="form-control ${loginType}-focus" id="password" name="password" placeholder="Enter your password" required>
                </div>
                
                <button type="submit" class="btn-login ${loginType}">
                    <i class="bi bi-box-arrow-in-right"></i> Sign In
                </button>
            </form>
            
            <a href="${pageContext.request.contextPath}/" class="back-link">
                <i class="bi bi-arrow-left"></i> Back to Home
            </a>
        </div>
    </div>
</body>
</html>
