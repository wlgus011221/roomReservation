<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="/css/room/header.css">

<header class="header">
    <div class="header-left">
        <h1>회의실 예약 시스템</h1>
    </div>
    <nav class="nav-menu">
        <a href="main.do" class="active">대시보드</a>
        <c:if test="${not empty sessionScope.name}">
        	<a href="reservation.do">예약하기</a>
        	<a href="myPage.do">마이페이지</a>
        </c:if>
        <c:if test="${sessionScope.userType eq 'ADMIN'}">
	    	<a href="roomManagement.do">회의실 관리</a>
	    </c:if>
    </nav>
    <div class="header-right">
        <div class="header-notification-icon">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
            </svg>
        </div>
        <div class="user-profile">
            <c:if test="${not empty sessionScope.name}">
                <span>${sessionScope.name}님 환영합니다</span>
                <a href="logout.do">로그아웃</a>
            </c:if>
            <c:if test="${empty sessionScope.name}">
                <a href="login.do">로그인</a>
                <a href="register.do">회원가입</a>
            </c:if>
        </div>
    </div>
</header>

<script>
	//서버에서 전달된 'msg' 값이 있는지 확인
	const message = '${msg}';
	
	// 메시지가 비어있지 않거나 'null'이 아니면 알림창 띄우기
	if (message && message !== 'null' && message.trim() !== '') {
	    alert(message);
	}
</script>