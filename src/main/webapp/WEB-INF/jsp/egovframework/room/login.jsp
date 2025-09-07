<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - 회의실 예약 시스템</title>
    <link rel="stylesheet" href="/css/room/common.css">
    <link rel="stylesheet" href="/css/room/login.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="card">
	    <div class="card-content">
	        <div class="login-header">
	            <h1>회의실 예약 시스템</h1>
	            <p>계정에 로그인하세요</p>
	        </div>
	        
	        <c:if test="${not empty message}">
	            <div class="msg">
	                ${message}
	            </div>
	        </c:if>
	
	        <form id="loginForm" action="loginProcess.do" method="post">
	            <div class="form-group">
	                <label class="form-label">사번</label>
	                <input type="text" name="id" class="form-input" placeholder="사번을 입력하세요" required>
	            </div>
	
	            <div class="form-group">
	                <label class="form-label">비밀번호</label>
	                <input type="password" name="passwd" class="form-input" placeholder="비밀번호를 입력하세요" required>
	            </div>
	
	            <button type="submit" class="btn btn-primary login-btn">
	                <i class="fas fa-sign-in-alt"></i>
	                로그인
	            </button>
	
	            <div class="login-footer">
	                <a href="register.do" class="register-link">
	                    계정이 없으신가요? 회원가입
	                </a>
	            </div>
	        </form>
	    </div>
	</div>
	
	<script>
        // 서버에서 전달된 'msg' 값이 있는지 확인
        const message = '${msg}';
        
        // 메시지가 비어있지 않거나 'null'이 아니면 알림창 띄우기
        if (message && message !== 'null' && message.trim() !== '') {
            alert(message);
        }
    </script>
</body>
</html>
