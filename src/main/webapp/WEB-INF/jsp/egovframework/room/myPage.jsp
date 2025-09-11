<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>마이페이지 - 회의실 예약 시스템</title>
<link rel="stylesheet" href="/css/room/common.css">
<link rel="stylesheet" href="/css/room/myPage.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">
<!-- 캘린더 API -->
<link rel="stylesheet"
	href="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.css" />
<script
	src="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.js"></script>
</head>
<body>
	<!-- 헤더 -->
	<%@ include file="/WEB-INF/jsp/egovframework/room/header.jsp"%>

	<!-- 메인 컨텐츠 -->
	<main class="main-container">
		<h2>마이페이지</h2>

		<!-- 탭 네비게이션 추가 -->
		<div class="tab-navigation">
			<button class="tab-btn active" onclick="showTab(this, 'profile')">
				<i class="fas fa-user"></i> 내 정보
			</button>
			<button class="tab-btn" onclick="showTab(this, 'bookings')">
				<i class="fas fa-calendar-check"></i> 내 예약관리
			</button>
			<button class="tab-btn" onclick="showTab(this, 'attendance')">
				<i class="fas fa-users"></i> 내 참석 정보
			</button>
			<button class="tab-btn" onclick="showTab(this, 'notifications')">
				<i class="fas fa-bell"></i> 알림 관리
			</button>
			<button class="tab-btn" onclick="showTab(this, 'dashboard')">
				<i class="fas fa-chart-line"></i> 내 일정 대시보드
			</button>
		</div>

		<!-- 내 정보 탭 -->
		<div id="profile-tab" class="tab-content active">
			<div class="grid grid-cols-3 gap-6">
				<!-- 프로필 정보 -->
				<div class="card">
					<div class="card-header">
						<h3 class="card-title">프로필 정보</h3>
					</div>
					<div class="card-content">
						<div class="profile-info">
							<div class="user-avatar"></div>
							<h4>${userDetails.name}</h4>
							<p>${userDetails.departmentName}•${userDetails.userType}</p>
						</div>

						<div class="profile-details">
							<div>
								<label>사번</label>
								<p>${userDetails.id}</p>
							</div>
							<div>
								<label>이메일</label>
								<p>${userDetails.email}</p>
							</div>
							<div>
								<label>전화번호</label>
								<p>${userDetails.phone}</p>
							</div>
						</div>

						<button class="btn btn-primary btn-profile-edit"
							onclick="openModal()">
							<i class="fas fa-edit"></i> 프로필 수정
						</button>
					</div>
				</div>

				<!-- 통계 -->
				<div style="grid-column: span 2;">
					<div class="card">
						<div class="card-header">
							<h3 class="card-title">이용 통계</h3>
						</div>
						<div class="card-content stats-grid">
							<div class="stats-item">
								<div class="stat-number" style="color: var(--primary-color);">24</div>
								<div class="stat-label">이번 달 예약</div>
							</div>
							<div class="stats-item">
								<div class="stat-number" style="color: var(--success-color);">18</div>
								<div class="stat-label">완료된 회의</div>
							</div>
							<div class="stats-item">
								<div class="stat-number" style="color: var(--warning-color);">2</div>
								<div class="stat-label">취소된 예약</div>
							</div>
							<div class="stats-item">
								<div class="stat-number" style="color: var(--gray-700);">36h</div>
								<div class="stat-label">총 이용 시간</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- 내 정보 수정 모달 -->
			<div id="profileEditModal" class="modal-overlay hidden">
				<div class="card">
					<div class="card-header">
						<div class="flex items-center justify-between">
							<h3 class="card-title">프로필 수정</h3>
							<button type="button" onclick="closeModal()">×</button>
						</div>
					</div>
					<div class="card-content">
						<form id="profileEditForm" action="updateProfile.do" method="post">
							<div class="form-group">
								<label class="form-label">이름 *</label> <input type="text"
									name="name" id="userName" class="form-input" required>
							</div>
							<div class="form-group">
								<label class="form-label">부서 *</label> <select
									name="departmentIdx" id="departmentSelect" class="form-select"
									required>
									<option value="">부서 선택</option>
									<c:forEach var="dept" items="${deptList}">
										<option value="${dept.departmentIdx}">${dept.name}</option>
									</c:forEach>
								</select>
							</div>
							<div class="form-group">
								<label class="form-label">이메일 *</label> <input type="email"
									name="email" id="editEmail" class="form-input" required>
							</div>
							<div class="form-group">
								<label class="form-label">전화번호 *</label> <input type="tel"
									name="phone" id="editPhone" class="form-input" required>
							</div>
							<div class="flex justify-end gap-3">
								<button type="button" class="btn btn-warning"
									onclick="openPasswordModal()">비밀번호 변경</button>
								<button type="button" class="btn btn-secondary"
									onclick="closeModal()">취소</button>
								<button type="submit" class="btn btn-primary">저장</button>
							</div>
						</form>
					</div>
				</div>
			</div>

			<!-- 별도 비밀번호 변경 모달 -->
			<div id="passwordEditModal" class="modal-overlay hidden">
				<div class="card">
					<div class="card-header">
						<h3 class="card-title">비밀번호 변경</h3>
					</div>
					<div class="card-content">
						<form id="passwordEditForm" action="updatePassword.do"
							method="post">
							<div class="form-group">
								<label>현재 비밀번호</label> <input type="password"
									name="currentPassword" class="form-input" required>
							</div>
							<div class="form-group">
								<label>새 비밀번호</label> <input type="password" name="newPassword"
									class="form-input" required>
							</div>
							<div class="form-group">
								<label>새 비밀번호 확인</label> <input type="password"
									name="confirmPassword" class="form-input" required>
							</div>
							<div class="flex justify-end gap-3">
								<button type="button" class="btn btn-secondary"
									onclick="closePasswordModal()">취소</button>
								<button type="submit" class="btn btn-primary">변경</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>


		<!-- 내 예약관리 탭 -->
		<div id="bookings-tab" class="tab-content">
		    <div class="card">
		        <div class="card-content">
		            <div class="overflow-x-auto">
		                <table class="booking-table">
		                    <thead>
		                        <tr>
		                            <th>날짜</th>
		                            <th>시간</th>
		                            <th>회의실</th>
		                            <th>제목</th>
		                            <th>참석자</th>
		                            <th>상태</th>
		                            <th>관리</th>
		                        </tr>
		                    </thead>
		                    <tbody id="myBookingsTableBody">
		                        </tbody>
		                </table>
		            </div>
		            <div id="myBookingsPagination" class="pagination-container mt-4"></div>
		        </div>
		    </div>
		    
		    <!-- 예약 정보 수정 -->
			<div id="editReservationModal" class="modal-overlay hidden">
			    <div class="card">
			        <div class="card-header">
			            <h3 class="card-title">예약 수정</h3>
			            <button type="button" onclick="closeEditModal()">×</button>
			        </div>
			        <div class="card-content">
			            <form id="editReservationForm" action="updateReservation.do" method="post">
			                <input type="hidden" id="editReservationIdx" name="reservationIdx">
			                
			                <div class="grid grid-cols-2 gap-6">
			                    <div class="form-group">
			                        <label class="form-label">회의 제목 *</label>
			                        <input type="text" id="editTitle" name="title" class="form-input" required>
			                    </div>
			                    <div class="form-group">
			                        <label class="form-label">회의실 *</label>
			                        <select class="form-select" id="editRoomIdx" name="roomIdx" required>
			                            <option value="">회의실을 선택하세요</option>
			                            <c:forEach var="room" items="${roomList}">
			                                <option value="${room.roomIdx}">${room.name} (${room.capacity}명)</option>
			                            </c:forEach>
			                        </select>
			                    </div>
			                </div>
			
			                <div class="grid grid-cols-2 gap-6">
			                    <div class="form-group">
			                        <label class="form-label">참석 인원 *</label>
			                        <input type="number" id="editAttendees" name="attendees" min="1" max="50" class="form-input" required>
			                    </div>
			                    <div class="form-group">
			                        <label class="form-label">예약 날짜 *</label>
			                        <input type="date" id="editDate" name="date" class="form-input" required>
			                    </div>
			                </div>
			
			                <div class="form-group">
			                    <label class="form-label">예약 시간 *</label>
			                    <div class="flex gap-2">
			                        <input type="time" id="editStartTime" name="startTime" class="form-input" required>
			                        <span class="flex items-center">~</span>
			                        <input type="time" id="editEndTime" name="endTime" class="form-input" required>
			                    </div>
			                </div>
			                
			                <div class="form-group">
			                    <label class="form-label">회의 내용</label>
			                    <textarea class="form-textarea" id="editContent" name="content"></textarea>
			                </div>
			                
			                <div class="flex justify-end gap-3">
			                    <button type="button" class="btn btn-secondary" onclick="closeEditModal()">취소</button>
			                    <button type="submit" class="btn btn-primary">수정</button>
			                </div>
			            </form>
			        </div>
			    </div>
			</div>
		</div>
		

		<!-- 내 참석 정보 탭 -->
		<div id="attendance-tab" class="tab-content">
			<div class="card">
				<div class="card-header">
					<h3 class="card-title">내 참석 정보</h3>
					<p class="attendance-description">다른 사람이 예약한 회의 중 내가 참석자로 등록된
						회의들</p>
				</div>
				<div class="card-content">
					<div class="overflow-x-auto">
						<table class="attendance-table">
							<thead>
								<tr>
									<th>날짜</th>
									<th>시간</th>
									<th>회의실</th>
									<th>제목</th>
									<th>주최자</th>
									<th>참석 상태</th>
									<th>응답</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>2024.01.17</td>
									<td>10:00-11:00</td>
									<td>컨퍼런스룸 B</td>
									<td>월간 전체 회의</td>
									<td>박팀장</td>
									<td><span class="status-badge status-available">참석
											예정</span></td>
									<td>
										<div class="flex gap-1">
											<button class="btn btn-success">참석</button>
											<button class="btn btn-danger">불참</button>
										</div>
									</td>
								</tr>
								<tr>
									<td>2024.01.18</td>
									<td>15:00-16:00</td>
									<td>미팅룸 2</td>
									<td>프로젝트 킥오프</td>
									<td>이과장</td>
									<td><span class="status-badge status-success">참석 확정</span>
									</td>
									<td><span class="text-success"> <i
											class="fas fa-check"></i> 참석 확정
									</span></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>


		<!-- 알림 관리 탭 -->
		<div id="notifications-tab" class="tab-content">
			<div class="card">
				<div class="card-header">
					<h3 class="card-title">알림 설정</h3>
				</div>
				<div class="card-content notification-section">
					<div class="grid grid-cols-2 gap-6">
						<div>
							<h4>예약 관련 알림</h4>
							<label><input type="checkbox" checked> 예약 확인 알림</label> <label><input
								type="checkbox" checked> 예약 취소 알림</label> <label><input
								type="checkbox"> 회의실 변경 알림</label>
						</div>
						<div>
							<h4>회의 알림</h4>
							<label><input type="checkbox" checked> 회의 시작 10분
								전 알림</label> <label><input type="checkbox"> 회의 종료 5분 전
								알림</label> <label><input type="checkbox"> 주간 예약 요약</label>
						</div>
					</div>
					<button class="btn btn-primary">설정 저장</button>
				</div>
			</div>

			<!-- 알림 히스토리 -->
			<div class="card" style="margin-top: 1.5rem;">
				<div class="card-header">
					<h3 class="card-title">최근 알림</h3>
				</div>
				<div class="card-content">
					<div class="notification-list">
						<div class="notification-item">
							<div class="notification-icon primary">
								<i class="fas fa-calendar-check"></i>
							</div>
							<div style="flex: 1;">
								<p>회의 시작 10분 전입니다</p>
								<p>주간 기획 회의 - 컨퍼런스룸 A</p>
								<p>5분 전</p>
							</div>
						</div>
						<div class="notification-item">
							<div class="notification-icon success">
								<i class="fas fa-check"></i>
							</div>
							<div style="flex: 1;">
								<p>예약이 확정되었습니다</p>
								<p>클라이언트 미팅 - 미팅룸 1</p>
								<p>1시간 전</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>


		<!-- 내 일정 대시보드 탭 추가 -->
		<div id="dashboard-tab" class="tab-content">
			<div class="card">
				<div class="card-header">
					<div class="flex items-center justify-between">
						<h3 class="card-title">내 일정 대시보드</h3>
						<div class="view-toggle">
							<button class="view-btn active"
								onclick="showView('calendar', this)">
								<i class="fas fa-calendar"></i> 달력뷰
							</button>
							<button class="view-btn" onclick="showView('timeline', this)">
								<i class="fas fa-chart-gantt"></i> 타임라인뷰
							</button>
						</div>
					</div>
				</div>
				<div class="card-content">
					<!-- 캘린더 -->
					<div id="calendar-view" class="dashboard-view active">
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
					</div>

					<!-- 타임라인 (같은 캘린더 div 사용) -->
					<div id="timeline-view" class="dashboard-view"
						style="display: none;">
						<div id="calendar-timeline" class="calendar"></div>
					</div>
				</div>
			</div>
		</div>
	</main>

	<script>
		let isCalendarInit = false;
	    let calendar; // 캘린더 인스턴스를 전역 변수로 선언
	    const Calendar = tui.Calendar;
	    
	    const PAGE_UNIT = 10;
		const PAGE_SIZE = 5;
	    
	 	// 마이페이지 탭 전환
        function showTab(btn, tabName) {
		    // 모든 탭 버튼과 컨텐츠 비활성화
		    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
		    document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
		    
		    // 선택된 탭 활성화
		    btn.classList.add('active'); // ✅ event.target 대신 btn 사용
		    document.getElementById(tabName + '-tab').classList.add('active');
		    
		 	// '내 예약관리' 탭을 선택하면 목록을 불러옵니다.
		    if(tabName === 'bookings') {
		        fetchMyReservations(1);
		    }
		 
		    // 내 일정 대시보드 탭이면 캘린더 강제 렌더링
		    if(tabName === 'dashboard' && !isCalendarInit) {
		        setTimeout(() => {
		            initCalendar();
		            isCalendarInit = true;
		            showView('calendar', document.querySelector('.view-btn.active'));
		        }, 50);
		    }
		}
	 	
     	// 내 일정 대시보드 뷰 전환
        function showView(viewName, btn) {
            if(!btn) return; // 안전 처리

            document.querySelectorAll('.view-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            document.getElementById('calendar-view').style.display = 'none';
            document.getElementById('timeline-view').style.display = 'none';

            if(viewName === 'calendar') {
                document.getElementById('calendar-view').style.display = 'block';
                calendar.changeView('month');
                setRenderRangeText();
                calendar.render();
            } else if(viewName === 'timeline') {
                document.getElementById('calendar-view').style.display = 'block';
                calendar.changeView('day');
                setRenderRangeText();
                calendar.render();
            } 
        }
	    
	 	// 랜덤 색상 생성 함수
	    function getRandomColor() {
	        const letters = '0123456789ABCDEF';
	        let color = '#';
	        for (let i = 0; i < 6; i++) {
	            color += letters[Math.floor(Math.random() * 16)];
	        }
	        return color;
	    }
	    
	 	// 캘린더 초기화
	    function initCalendar() {
	        // 회의실 목록
	        const roomList = [
	            <c:forEach var="room" items="${roomList}" varStatus="status">
	                {
	                    id: '${room.roomIdx}',
	                    name: '${room.name}',
	                    color: '#ffffff',
	                    backgroundColor: getRandomColor(),
	                    dragBackgroundColor: getRandomColor(),
	                    borderColor: getRandomColor()
	                }<c:if test="${!status.last}">,</c:if>
	            </c:forEach>
	        ];

	        // 전역 calendar 생성
	        calendar = new Calendar('#calendar', {
	            defaultView: 'month',
	            useDetailPopup: true,
	            isReadOnly: true,
	            gridSelection: false,
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
			                start: new Date('<fmt:formatDate value="${res.startDatetime}" pattern="yyyy-MM-dd\'T\'HH:mm:ss"/>'), // ✅ ISO 8601 문자열을 JS Date로 변환
			                end: new Date('<fmt:formatDate value="${res.endDatetime}" pattern="yyyy-MM-dd\'T\'HH:mm:ss"/>'),     // ✅ JS Date
			                backgroundColor: room.backgroundColor,
			                dragBackgroundColor: room.backgroundColor,
			                borderColor: room.backgroundColor,
			                color: '#fff',
			                attendees: ['${res.userName}']
			            };
			        })()<c:if test="${!status.last}">,</c:if>
			    </c:forEach>
			];

	        // 이벤트 추가
	        calendar.createEvents(reservations);
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
	 
    	// 내 정보 수정
    	// 모달 DOM 요소 가져오기
	    const profileEditModal = document.getElementById('profileEditModal');
	    const userNameInput = document.getElementById('userName');
	    const departmentSelect = document.getElementById('departmentSelect');
	    const editEmailInput = document.getElementById('editEmail');
	    const editPhoneInput = document.getElementById('editPhone');
	
	    // 내 정보 수정 모달 열기 함수
	    function openModal() {
	    	// 1. 일반 input 필드에 값 채우기
	        userNameInput.value = '${userDetails.name}';
	        editEmailInput.value = '${userDetails.email}';
	        editPhoneInput.value = '${userDetails.phone}';
	        
	        // 2. <select> 필드에서 현재 사용자의 부서를 선택하도록 처리
	        departmentSelect.value = '${userDetails.departmentIdx}';
	        
	        // 모달을 보이게 함
	        profileEditModal.classList.remove('hidden');
	    }
	
	    // 내정보 수정 모달 닫기 함수
	    function closeModal() {
	    	profileEditModal.classList.add('hidden');
	    }
	    
		
	    const passwordEditModal = document.getElementById('passwordEditModal');
	    const passwordEditForm = document.getElementById('passwordEditForm');
	    
	    // 비밀번호 변경 모달 열기 함수
	    function openPasswordModal() {
	    	passwordEditForm.reset(); // 폼 내용 초기화
	        passwordEditModal.classList.remove('hidden');
	    }

	    // 비밀번호 변경 모달 닫기 함수
	    function closePasswordModal() {
	    	passwordEditModal.classList.add('hidden');
	    }
	    
	    passwordEditForm.addEventListener('submit', function(event) {
	        const newPassword = this.newPassword.value;
	        const confirmPassword = this.confirmPassword.value;

	        // 새 비밀번호와 확인 비밀번호가 일치하는지 검사
	        if (newPassword !== confirmPassword) {
	            alert('새 비밀번호가 일치하지 않습니다.');
	            event.preventDefault(); 
	            return false; // 폼 제출 중지
	        }
	    });
	    
	    // 내 예약 관리
		function fetchMyReservations(pageIndex) {
			$.ajax({
				url: '/getMyReservations.do',
				type: 'GET',
				data: {
					pageIndex: pageIndex,
					pageUnit: PAGE_UNIT
				},
				dataType: 'json',
				success: function(response) {
					renderMyReservations(response.list);
					renderMyBookingsPagination(response.totalCount, pageIndex);
				},
				error: function(xhr, status, error) {
					console.error("내 예약 목록 조회 실패:", error);
					$('#myBookingsTableBody').html('<tr><td colspan="7" style="text-align: center; padding: 20px;">예약 내역을 불러오는 데 실패했습니다.</td></tr>');
				}
			});
		}

		function renderMyReservations(list) {
			const tbody = $('#myBookingsTableBody');
			tbody.empty();

			if (list && list.length > 0) {
				const now = new Date();
				list.forEach(res => {
					const startDatetime = new Date(res.startDatetime);
					const endDatetime = new Date(res.endDatetime);
					
					let statusHtml = '';
					if (endDatetime < now) {
						statusHtml = `<span class="status-badge status-used">사용 완료</span>`;
					} else if (startDatetime < now && endDatetime > now) {
						statusHtml = `<span class="status-badge status-in-progress">진행중</span>`;
					} else {
						statusHtml = `<span class="status-badge status-available">예정</span>`;
					}
					
					const row = `
						<tr>
							<td>\${startDatetime.toLocaleDateString()}</td>
							<td>\${startDatetime.toTimeString().slice(0, 5)} - \${endDatetime.toTimeString().slice(0, 5)}</td>
							<td>\${res.roomName}</td>
							<td>\${res.title}</td>
							<td>\${res.attendees}명</td>
							<td>\${statusHtml}</td>
							<td>
								<div class="flex gap-1">
									<button class="btn btn-secondary" onclick="editReservation('\${res.reservationIdx}')">
										수정
									</button>
									<button class="btn btn-danger" onclick="deleteReservation('\${res.reservationIdx}')">
										취소
									</button>
								</div>
							</td>
						</tr>
					`;
					tbody.append(row);
				});
			} else {
				tbody.append('<tr><td colspan="7" style="text-align: center; padding: 20px;">예약 내역이 없습니다.</td></tr>');
			}
		}

		function renderMyBookingsPagination(totalCount, currentPage) {
			const paginationContainer = $('#myBookingsPagination');
			paginationContainer.empty();

			const totalPages = Math.ceil(totalCount / PAGE_UNIT);
			if (totalPages <= 1) {
				paginationContainer.hide();
				return;
			}
			paginationContainer.show();

			const startPage = Math.max(1, currentPage - Math.floor(PAGE_SIZE / 2));
			const endPage = Math.min(totalPages, startPage + PAGE_SIZE - 1);

			let html = '';
			if (currentPage > 1) {
				html += `<span class="page-link" onclick="fetchMyReservations(\${currentPage - 1})">이전</span>`;
			}

			for (let i = startPage; i <= endPage; i++) {
				if (i === currentPage) {
					html += `<span class="page-link active">\${i}</span>`;
				} else {
					html += `<span class="page-link" onclick="fetchMyReservations(\${i})">\${i}</span>`;
				}
			}

			if (currentPage < totalPages) {
				html += `<span class="page-link" onclick="fetchMyReservations(\${currentPage + 1})">다음</span>`;
			}

			paginationContainer.html(html);
		}
		
		// 모달 DOM 요소 가져오기
		const editReservationModal = document.getElementById('editReservationModal');
		const editReservationForm = document.getElementById('editReservationForm');
		
		// 모달 열기 함수
		function openEditModal() {
		    editReservationModal.classList.remove('hidden');
		}
		
		// 모달 닫기 함수
		function closeEditModal() {
		    editReservationModal.classList.add('hidden');
		}
		
		// 폼에 데이터 채우기 함수
		function fillEditForm(data) {
		    document.getElementById('editReservationIdx').value = data.reservationIdx;
		    document.getElementById('editTitle').value = data.title;
		    document.getElementById('editRoomIdx').value = data.roomIdx;
		    document.getElementById('editAttendees').value = data.attendees;
		    document.getElementById('editContent').value = data.content || '';
		
		    // 날짜와 시간 필드 채우기
		    const startDate = new Date(data.startDatetime);
		    const endDate = new Date(data.endDatetime);
		
		    document.getElementById('editDate').value = startDate.toISOString().slice(0,10);
		    document.getElementById('editStartTime').value = startDate.toTimeString().slice(0,5);
		    document.getElementById('editEndTime').value = endDate.toTimeString().slice(0,5);
		}
		
		// 예약 정보 수정
	    function editReservation(id) {
		    $.ajax({
		        url: '/selectReservation.do',
		        type: 'GET',
		        data: { reservationIdx: id },
		        success: function(response) {
		            
		            // 응답이 문자열인 경우 JSON 파싱 시도
		            if (typeof response === 'string') {
		                try {
		                    response = JSON.parse(response);
		                } catch (e) {
		                    console.error("JSON 파싱 실패:", e);
		                    return;
		                }
		            }
		            
		            if (response.result === 'success') {
		            	fillEditForm(response.data);
		                openEditModal();
		            } else {
		                alert("실패: " + response.msg);
		            }
		        },
		        error: function(xhr, status, error) {
		            console.log("에러:", error);
		            
		            alert("에러 발생: " + xhr.status + " - " + error);
		        }
		    });
		}
		
	 	// 예약 취소
	    function deleteReservation(id) {
			if (confirm('예약 취소 하시겠습니까?')) {
				$.ajax({
					// 컨트롤러의 @RequestMapping 경로를 올바르게 지정
					url : '/deleteReservation.do',
					type : 'POST',
					data : {
						reservationIdx : id
					}, // 컨트롤러로 보낼 데이터
					success : function(response) {
						// 서버로부터 'success' 문자열을 받으면 성공 처리
						if (response === 'success') {
							alert('예약이 성공적으로 취소되었습니다.');
							window.location.reload(); // 페이지 새로고침
						} else {
							alert('예약 취소 중 오류가 발생했습니다.');
						}
					},
					error : function() {
						alert('서버와 통신 중 오류가 발생했습니다.');
					}
				});
			}
		}
    </script>
</body>
</html>

