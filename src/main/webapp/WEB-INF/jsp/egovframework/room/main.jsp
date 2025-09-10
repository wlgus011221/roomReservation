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
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
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
				<input type="date" class="date-input" value="${today}">
				<button class="search-btn">조회</button>
			</div>
		</div>

		<!-- 통계 카드 -->
		<div class="stats-grid">
			<div class="stat-card">
				<i class="fas fa-building" style="font-size: 2.5rem; color: var(--primary-color);"></i>
				<div class="stat-content">
					<h3>전체 회의실</h3>
					<div class="stat-number">${roomCount}개</div>
				</div>
			</div>
			<div class="stat-card">
			    <i class="fas fa-calendar-check" style="font-size: 2.5rem; color: var(--success-color);"></i>
			    <div class="stat-content">
			        <h3>예약</h3>
			        <div class="stat-number" id="totalReservations">${totalReservations}건</div>
			    </div>
			</div>
			<div class="stat-card">
			    <i class="fas fa-calendar-alt" style="font-size: 2.5rem; color: var(--warning-color);"></i>
			    <div class="stat-content">
			        <h3>내 예약</h3>
			        <div class="stat-number" id="myReservations">${myReservations}건</div>
			    </div>
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
		
		<!-- 리스트 뷰 -->
		<div id="list-view-container" style="display: none;">
		    <div class="list-container">
		        <c:choose>
		            <c:when test="${empty todayReservationList}">
		                <p class="no-reservation-text">해당 날짜에 예약이 없습니다.</p>
		            </c:when>
		            <c:otherwise>
		                <c:forEach var="res" items="${todayReservationList}" varStatus="status">
		                    <div class="reservation-card">
		                        <div class="card-header">
		                            <h3 class="card-title">${res.title}</h3>
		                        </div>
		                        <div class="card-body">
		                            <div class="card-detail">
		                                <i class="fas fa-building"></i>
		                                <span>${res.roomName}</span>
		                            </div>
		                            <div class="card-detail">
		                                <i class="far fa-clock"></i>
		                                <span>
		                                    <fmt:formatDate value="${res.startDatetime}" pattern="HH:mm"/> - 
		                                    <fmt:formatDate value="${res.endDatetime}" pattern="HH:mm"/>
		                                </span>
		                            </div>
		                            <div class="card-detail">
		                                <i class="fas fa-user"></i>
		                                <span>${res.userName}</span>
		                            </div>
		                            <div class="card-detail">
		                                <i class="fas fa-users"></i>
		                                <span>${res.attendees}명</span>
		                            </div>
		                        </div>
		                    </div>
		                </c:forEach>
		            </c:otherwise>
		        </c:choose>
		    </div>
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
        	// 모든 탭의 active 클래스 제거
            document.querySelectorAll('#view-tabs .tab-btn').forEach(tab => {
                tab.classList.remove('active');
            });

            // 클릭한 버튼에 active 클래스 추가
            btn.classList.add('active');

            const calendarContainer = document.getElementById('calendar-container');
            const listViewContainer = document.getElementById('list-view-container');

            if (view === 'list') {
                // 리스트 뷰 버튼 클릭 시
                calendarContainer.style.display = 'none';
                listViewContainer.style.display = 'block';
            } else {
                // 다른 캘린더 뷰 버튼 클릭 시
                calendarContainer.style.display = 'block';
                listViewContainer.style.display = 'none';
                calendar.changeView(view); // 캘린더 뷰 전환
                setRenderRangeText(); // 현재 날짜 범위 업데이트 (기존 함수)
            }
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
        
        $('.search-btn').on('click', function() {
            const selectedDate = $('.date-input').val();
            if (selectedDate) {
            	// 통계 데이터 조회
                $.ajax({
                    url: '/getStats.do',
                    type: 'GET',
                    data: { date: selectedDate }, // 문자열 그대로 전달
                    dataType: 'json',
                    success: function(data) {
                        $('#totalReservations').text(data.totalReservations + '건');
                        $('#myReservations').text(data.myReservations + '건');
                    },
                    error: function(xhr, status, error) {
                        console.error('예약 통계 조회 실패:', error);
                    }
                });
            	
            	// 예약 목록 데이터 조회
                $.ajax({
                    url: '/getReservationsByDate.do',
                    type: 'GET',
                    data: { date: selectedDate },
                    dataType: 'json',
                    success: function(data) {                       
                        const listViewContainer = document.getElementById('list-view-container');
                        let html = '';

                        if (data.length === 0) {
                            html = '<p class="no-reservation-text">해당 날짜에 예약이 없습니다.</p>';
                        } else {
                        	data.forEach(function(res) {
                        		console.log("받아온 데이터:", res);
                                console.log("제목:", res.title);
                                console.log("회의실 이름:", res.roomName);
                                console.log("시작 시간 타임스탬프:", res.startDatetime);
                                console.log("종료 시간 타임스탬프:", res.endDatetime);
                                console.log("시작 시간 타임스탬프:", typeof(res.startDatetime));
                                console.log("종료 시간 타임스탬프:", typeof(res.endDatetime));
                                console.log("예약자 이름:", res.userName);
                                console.log("참석 인원:", res.attendees);
                                
                                // ✅ 타임스탬프 → Date 변환
                                const startDate = new Date(res.startDatetime);
                                const endDate = new Date(res.endDatetime);

                                // ✅ "HH:mm" 포맷 (24시간제)
                                const startTimeStr = startDate.toLocaleTimeString('ko-KR', {
                                    hour: '2-digit',
                                    minute: '2-digit',
                                    hour12: false
                                });
                                const endTimeStr = endDate.toLocaleTimeString('ko-KR', {
                                    hour: '2-digit',
                                    minute: '2-digit',
                                    hour12: false
                                });

                                // 참석 인원 처리
                                const attendeesCount = res.attendees ? res.attendees : 0;

                                html += `
                                    <div class="reservation-card">
                                        <div class="card-header">
                                            <h3 class="card-title">\${res.title}</h3>  
                                        </div>
                                        <div class="card-body">
                                            <div class="card-detail">
                                                <i class="fas fa-building"></i>
                                                <span>\${res.roomName}</span>    
                                            </div>
                                            <div class="card-detail">
                                                <i class="far fa-clock"></i>
                                                <span>\${startTimeStr} - \${endTimeStr}</span>
                                            </div>
                                            <div class="card-detail">
                                                <i class="fas fa-user"></i>
                                                <span>\${res.userName}</span>   
                                            </div>
                                            <div class="card-detail">
                                                <i class="fas fa-users"></i>
                                                <span>\${attendeesCount}명</span>
                                            </div>
                                        </div>
                                    </div>
                                `;
                            });
                        }
                        listViewContainer.innerHTML = html;
                    },
                    error: function(xhr, status, error) {
                        console.error('예약 목록 조회 실패:', error);
                    }
                });
            }
        });

    </script>
</body>
</html>
