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
<!-- <link rel="stylesheet" href="/css/room/calendar.css"> -->
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
		<div id="calendar-container">
  			<!-- 네비게이션 -->
		  	<div id="calendar-navi">
			    <button id="btn-prev">◀</button>
			    <button id="btn-today">오늘</button>
			    <button id="btn-next">▶</button>
		  	</div>
		  	<div id="renderRange"></div>
		
			<!-- 달력 본체 -->
			<div id="calendar"></div>
		</div>
	</main>

	<script>
		const Calendar = tui.Calendar;
	
	    // 랜덤 색상 생성 함수
	    function getRandomColor() {
	        const letters = '0123456789ABCDEF';
	        let color = '#';
	        for (let i = 0; i < 6; i++) {
	            color += letters[Math.floor(Math.random() * 16)];
	        }
	        return color;
	    }
	    
	    // DB에서 가져온 회의실 목록 데이터를 JavaScript 배열로 변환
	    const roomList = [
	        <c:forEach var="room" items="${roomList}" varStatus="status">
	            {
	                id: '${room.roomIdx}',
	                name: '${room.name}',
	                color: '#ffffff', // 캘린더 텍스트 색상
	                backgroundColor: getRandomColor(), // 배경색
	                dragBackgroundColor: getRandomColor(),
	                borderColor: getRandomColor() // 테두리 색상 (월간 뷰 dot 색상)
	            }<c:if test="${!status.last}">,</c:if>
	        </c:forEach>
	    ];
	
	    const calendar = new Calendar('#calendar', {
	        defaultView: 'month',
	        useDetailPopup: true,
	        isReadOnly: true,
	        gridSelection: false,
	        // 회의실 목록을 calendars 옵션에 전달
	        calendars: roomList
	    });
	    
	 	// 예약 목록
	    const reservations = [
	        <c:forEach var="res" items="${reservationList}" varStatus="status">
	            (function() {
	                const room = roomList.find(r => r.id === '${res.roomIdx}');
	                return {
	                    id: '${res.reservationIdx}',
	                    calendarId: '${res.roomIdx}',
	                    title: '[${res.roomName}] ${res.title}',
	                    category: 'time',
	                    start: '<fmt:formatDate value="${res.startDatetime}" pattern="yyyy-MM-dd'T'HH:mm:ss"/>',
	                    end: '<fmt:formatDate value="${res.endDatetime}" pattern="yyyy-MM-dd'T'HH:mm:ss"/>',
	                    backgroundColor: room.backgroundColor,  // ✅ 회의실 색상 가져오기
	                    dragBackgroundColor: room.backgroundColor,
	                    borderColor: room.backgroundColor,      // ✅ border-left도 동일하게
	                    color: '#fff',
	                    attendees: ['${res.userName}']
	                };
	            })()<c:if test="${!status.last}">,</c:if>
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
            
            setRenderRangeText();
        }
        
     	// 이전 / 다음 / 오늘 버튼
        document.getElementById('btn-prev').addEventListener('click', () => {
          calendar.prev();
          setRenderRangeText();
        });

        document.getElementById('btn-next').addEventListener('click', () => {
          calendar.next();
          setRenderRangeText();
        });

        document.getElementById('btn-today').addEventListener('click', () => {
          calendar.today();
          setRenderRangeText();
        });
        
     	// 현재 달력 범위 표시
        function setRenderRangeText() {
        	const viewName = calendar.getViewName();
          	const start = calendar.getDateRangeStart();
         	const end = calendar.getDateRangeEnd();
         	let text = '';

         	if (viewName === 'month') {
           		text = start.toDate().toLocaleDateString('ko-KR', { year: 'numeric', month: 'long' });
         	} else if (viewName === 'week' || viewName === 'day') {
           		text =
             	start.toDate().toLocaleDateString('ko-KR') +
           		' ~ ' +
             	end.toDate().toLocaleDateString('ko-KR');
          }

          document.getElementById('renderRange').innerText = text;
        }

        // 초기 세팅
        setRenderRangeText();
    </script>
</body>
</html>
