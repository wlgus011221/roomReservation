<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회의실 예약 시스템</title>
<link rel="stylesheet" href="/css/room/common.css">
<link rel="stylesheet" href="/css/room/main.css">
<!-- 캘린더 API -->
<link rel="stylesheet"
	href="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.css" />
<script
	src="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.js"></script>
</head>
<body>
	<!-- 헤더 -->
	<%@ include file="/WEB-INF/jsp/egovframework/room/header.jsp"%>

	<!-- 메인 컨테이너 -->
	<main class="main-container">
		<!-- 섹션 헤더 -->
		<div class="section-header">
			<h2 class="section-title">회의실 예약 현황</h2>
			<div class="date-controls">
				<input type="date" class="date-input"
					value="<fmt:formatDate value='${today}' pattern='yyyy-MM-dd' />">
				<button class="search-btn">조회</button>
			</div>
		</div>

		<!-- 통계 카드 -->
		<div class="stats-grid">
			<div class="stat-card">
				<h3>전체 회의실</h3>
				<div class="stat-number">${roomCount}개</div>
			</div>
			<div class="stat-card">
				<h3>예약된 회의실</h3>
				<div class="stat-number">3개</div>
			</div>
			<div class="stat-card">
				<h3>사용 가능한 회의실</h3>
				<div class="stat-number">5개</div>
			</div>
			<div class="stat-card">
				<h3>내 예약</h3>
				<div class="stat-number">1개</div>
			</div>
		</div>

		<!-- 뷰 탭 -->
		<div id="view-tabs" class="view-tabs" style="margin-bottom: 10px;">
			<button class="tab-btn active" onclick="changeView('month', this)">월간</button>
			<button class="tab-btn" onclick="changeView('week', this)">주간</button>
			<button class="tab-btn" onclick="changeView('day', this)">일간</button>
			<button class="tab-btn" onclick="changeView('list', this)">리스트</button>
			<button class="tab-btn" onclick="changeView('timeline', this)">타임라인</button>
		</div>

		<!-- 캘린더 -->
		<div id="calendar" class="calendar"></div>
	</main>

	<script>
	    const Calendar = tui.Calendar;
	    const calendar = new Calendar('#calendar', {
	      defaultView: 'month',
	      useDetailPopup: true,
	      useCreationPopup: true,
	      calendars: [
	        { id: 'default', name: '회의실 예약', color: '#ffffff', bgColor: '#0475f4' }
	      ]
	    });
	    
	 	// DB에서 가져온 예약 목록 데이터 (JSP에서 JavaScript 변수로 변환)
	    const reservations = [
	        <c:forEach var="res" items="${reservationList}" varStatus="status">
	            {
	                id: '${res.reservationIdx}',
	                calendarId: 'default',
	                title: '[${res.roomName}] ${res.title}',
	                category: 'time',
	                // 날짜와 시간을 ISO 8601 형식으로 조합
	                start: '<fmt:formatDate value="${res.date}" pattern="yyyy-MM-dd"/>T<fmt:formatDate value="${res.startTime}" pattern="HH:mm:ss"/>',
	                end: '<fmt:formatDate value="${res.date}" pattern="yyyy-MM-dd"/>T<fmt:formatDate value="${res.endTime}" pattern="HH:mm:ss"/>'
	            }<c:if test="${!status.last}">,</c:if>
	        </c:forEach>
	    ];
	 	
	    // 캘린더에 이벤트 추가
        calendar.createEvents(reservations);
	 	
        function changeView(view, btn) {
            // 달력 뷰 전환
            calendar.changeView(view);

            // 모든 탭의 active 제거
            document.querySelectorAll('#view-tabs .tab-btn').forEach(tab => {
                tab.classList.remove('active');
            });

            // 클릭한 버튼만 active 추가
            btn.classList.add('active');
        }
    </script>
</body>
</html>
