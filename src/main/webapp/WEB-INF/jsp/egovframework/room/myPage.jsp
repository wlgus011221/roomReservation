<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 회의실 예약 시스템</title>
    <link rel="stylesheet" href="/css/room/common.css">
    <link rel="stylesheet" href="/css/room/myPage.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- 캘린더 API -->
    <link rel="stylesheet" href="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.css" />
	<script src="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.js"></script>
</head>
<body>
    <!-- 헤더 -->
    <header class="header">
        <div class="header-left">
            <h1>회의실 예약 시스템</h1>
        </div>
        <nav class="nav-menu">
            <a href="main.do" class="active">대시보드</a>
            <a href="booking.do">예약하기</a>
            <a href="myPage.do">마이페이지</a>
            <a href="roomManagement.do">회의실 관리</a>
        </nav>
        <div class="header-right">
            <div class="notification-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                    <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                </svg>
            </div>
            <div class="user-info">
                <span>홍길동님</span>
                <span>로그아웃</span>
            </div>
        </div>
    </header>

    <!-- 메인 컨텐츠 -->
    <main class="main-container">
        <h2>마이페이지</h2>

        <!-- 탭 네비게이션 추가 -->
        <div class="tab-navigation">
            <button class="tab-btn active" onclick="showTab('profile')">
                <i class="fas fa-user"></i> 내 정보
            </button>
            <button class="tab-btn" onclick="showTab('bookings')">
                <i class="fas fa-calendar-check"></i> 내 예약관리
            </button>
            <button class="tab-btn" onclick="showTab('attendance')">
                <i class="fas fa-users"></i> 내 참석 정보
            </button>
            <button class="tab-btn" onclick="showTab('notifications')">
                <i class="fas fa-bell"></i> 알림 관리
            </button>
            <button class="tab-btn" onclick="showTab('dashboard')">
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
		                    <h4>김관리</h4>
		                    <p>개발팀 • 관리자</p>
		                </div>
		                
		                <div class="profile-details">
		                    <div>
		                        <label>이메일</label>
		                        <p>admin@company.com</p>
		                    </div>
		                    <div>
		                        <label>전화번호</label>
		                        <p>010-1234-5678</p>
		                    </div>
		                    <div>
		                        <label>가입일</label>
		                        <p>2024.01.01</p>
		                    </div>
		                </div>
		
		                <button class="btn btn-primary btn-profile-edit">
		                    <i class="fas fa-edit"></i>
		                    프로필 수정
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
		</div>


        <!-- 내 예약관리 탭 -->
		<div id="bookings-tab" class="tab-content">
		    <div class="card">
		        <div class="card-header">
		            <div class="flex items-center justify-between">
		                <h3 class="card-title">내 예약 현황</h3>
		                <div class="flex gap-2 booking-filters">
		                    <button class="btn btn-secondary">전체</button>
		                    <button class="btn btn-primary">예정</button>
		                    <button class="btn btn-secondary">완료</button>
		                    <button class="btn btn-secondary">취소</button>
		                </div>
		            </div>
		        </div>
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
		                    <tbody>
		                        <tr>
		                            <td>2024.01.15</td>
		                            <td>09:00-10:00</td>
		                            <td>컨퍼런스룸 A</td>
		                            <td>주간 기획 회의</td>
		                            <td>5명</td>
		                            <td>
		                                <span class="status-badge status-occupied">진행 중</span>
		                            </td>
		                            <td>
		                                <div class="flex gap-1">
		                                    <button class="btn btn-secondary">수정</button>
		                                    <button class="btn btn-danger">취소</button>
		                                </div>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td>2024.01.16</td>
		                            <td>14:00-15:30</td>
		                            <td>미팅룸 1</td>
		                            <td>클라이언트 미팅</td>
		                            <td>3명</td>
		                            <td>
		                                <span class="status-badge status-available">예정</span>
		                            </td>
		                            <td>
		                                <div class="flex gap-1">
		                                    <button class="btn btn-secondary">수정</button>
		                                    <button class="btn btn-danger">취소</button>
		                                </div>
		                            </td>
		                        </tr>
		                    </tbody>
		                </table>
		            </div>
		        </div>
		    </div>
		</div>


        <!-- 내 참석 정보 탭 -->
		<div id="attendance-tab" class="tab-content">
		    <div class="card">
		        <div class="card-header">
		            <h3 class="card-title">내 참석 정보</h3>
		            <p class="attendance-description">
		                다른 사람이 예약한 회의 중 내가 참석자로 등록된 회의들
		            </p>
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
		                            <td>
		                                <span class="status-badge status-available">참석 예정</span>
		                            </td>
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
		                            <td>
		                                <span class="status-badge status-success">참석 확정</span>
		                            </td>
		                            <td>
		                                <span class="text-success">
		                                    <i class="fas fa-check"></i> 참석 확정
		                                </span>
		                            </td>
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
		                    <label><input type="checkbox" checked> 예약 확인 알림</label>
		                    <label><input type="checkbox" checked> 예약 취소 알림</label>
		                    <label><input type="checkbox"> 회의실 변경 알림</label>
		                </div>
		                <div>
		                    <h4>회의 알림</h4>
		                    <label><input type="checkbox" checked> 회의 시작 10분 전 알림</label>
		                    <label><input type="checkbox"> 회의 종료 5분 전 알림</label>
		                    <label><input type="checkbox"> 주간 예약 요약</label>
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
		                    <button class="view-btn active" onclick="showView('calendar', this)">
		                        <i class="fas fa-calendar"></i> 달력뷰
		                    </button>
		                    <button class="view-btn" onclick="showView('list', this)">
		                        <i class="fas fa-list"></i> 리스트뷰
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
				        <div id="calendar" class="calendar"></div>
				    </div>
				
				    <!-- 리스트 -->
				    <div id="list-view" class="dashboard-view" style="display:none;">
				        <ul>
				            <li>회의실 A - 팀 회의 (2025-08-26 10:00)</li>
				            <li>회의실 B - 외부 미팅 (2025-08-28 14:00)</li>
				        </ul>
				    </div>
				
				    <!-- 타임라인 (같은 캘린더 div 사용) -->
				    <div id="timeline-view" class="dashboard-view" style="display:none;">
				        <div id="calendar-timeline" class="calendar"></div>
				    </div>
		        </div>
		    </div>
		</div>
    </main>

    <script>
	    let calendar;       // 캘린더 인스턴스
	    let isCalendarInit = false;
	 	
    	// 마이페이지 탭 전환
        function showTab(tabName) {
            // 모든 탭 버튼과 컨텐츠 비활성화
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
            
            // 선택된 탭 활성화
            event.target.classList.add('active');
            document.getElementById(tabName + '-tab').classList.add('active');
            
         	// 내 일정 대시보드 탭이면 캘린더 강제 렌더링
            if(tabName === 'dashboard') {
		        if(!isCalendarInit) {
		            // 캘린더 생성
		            const Calendar = tui.Calendar;
		            calendar = new Calendar('#calendar', {
		                defaultView: 'month',
		                useDetailPopup: true,
		                useCreationPopup: true,
		                calendars: [
		                    { id: 'default', name: '회의실 예약', color: '#ffffff', bgColor: '#0475f4' }
		                ]
		            });
		
		            // 테스트 이벤트 추가
		            calendar.createEvents([
		                { id: '1', calendarId: 'default', title: '팀 회의', category: 'time', start: '2025-08-26T10:00:00', end: '2025-08-26T11:00:00' },
		                { id: '2', calendarId: 'default', title: '외부 미팅', category: 'time', start: '2025-08-28T14:00:00', end: '2025-08-28T15:30:00' }
		            ]);
		
		            isCalendarInit = true;
		        }
		        // 뷰 초기화
		        showView('calendar', document.querySelector('.view-btn.active'));
		    }
        }
		
    	// 내 일정 대시보드
        function showView(viewName, btn) {
		    document.querySelectorAll('.view-btn').forEach(b => b.classList.remove('active'));
		    btn.classList.add('active');
		
		    document.getElementById('calendar-view').style.display = 'none';
		    document.getElementById('timeline-view').style.display = 'none';
		    document.getElementById('list-view').style.display = 'none';
		
		    if(viewName === 'calendar') {
		        document.getElementById('calendar-view').style.display = 'block';
		        calendar.changeView('month');
		        calendar.render();
		    } else if(viewName === 'timeline') {
		        document.getElementById('calendar-view').style.display = 'block';
		        calendar.changeView('day');
		        calendar.render();
		    } else if(viewName === 'list') {
		        document.getElementById('list-view').style.display = 'block';
		    }
		}


    </script>
</body>
</html>

