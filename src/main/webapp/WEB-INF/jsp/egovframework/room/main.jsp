<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회의실 예약 시스템</title>
    <link rel="stylesheet" href="/css/room/common.css">
    <link rel="stylesheet" href="/css/room/main.css">
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

    <!-- 메인 컨테이너 -->
    <main class="main-container">
        <!-- 섹션 헤더 -->
        <div class="section-header">
            <h2 class="section-title">회의실 예약 현황</h2>
            <div class="date-controls">
                <input type="date" class="date-input" value="2025-08-21">
                <button class="search-btn">조회</button>
            </div>
        </div>

        <!-- 통계 카드 -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3>전체 회의실</h3>
                <div class="stat-number">8개</div>
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
        <div class="view-tabs">
            <button class="tab active">캘린더 뷰</button>
            <button class="tab">리스트 뷰</button>
            <button class="tab">타임라인 뷰</button>
        </div>

        <!-- 캘린더 -->
        <div class="calendar-container">
            <div class="calendar-header">
                <div class="calendar-day-header">일</div>
                <div class="calendar-day-header">월</div>
                <div class="calendar-day-header">화</div>
                <div class="calendar-day-header">수</div>
                <div class="calendar-day-header">목</div>
                <div class="calendar-day-header">금</div>
                <div class="calendar-day-header">토</div>
            </div>
            <div class="calendar-grid">
                <!-- 이전 달 마지막 날들 -->
                <div class="calendar-cell other-month">
                    <div class="calendar-date">31</div>
                </div>
                
                <!-- 8월 1일~31일 -->
                <div class="calendar-cell">
                    <div class="calendar-date">1</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">2</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">3</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">4</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">5</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">6</div>
                </div>
                
                <div class="calendar-cell">
                    <div class="calendar-date">7</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">8</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">9</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">10</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">11</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">12</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">13</div>
                </div>
                
                <div class="calendar-cell">
                    <div class="calendar-date">14</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">15</div>
                    <div class="event type-meeting">팀 회의 A 09:00</div>
                    <div class="event type-conference">회의실 C 14:00</div>
                </div>
                <div class="calendar-cell" data-tooltip="프로젝트 리뷰|회의실 C|14:00-16:00|이영희(개발팀)|5명">
                    <div class="calendar-date">16</div>
                    <div class="event type-conference">프로젝트 리뷰</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">17</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">18</div>
                    <div class="event">월간 회의 15:00</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">19</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">20</div>
                </div>
                
                <div class="calendar-cell">
                    <div class="calendar-date">21</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">22</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">23</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">24</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">25</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">26</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">27</div>
                </div>
                
                <div class="calendar-cell">
                    <div class="calendar-date">28</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">29</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">30</div>
                </div>
                <div class="calendar-cell">
                    <div class="calendar-date">31</div>
                </div>
                
                <!-- 다음 달 첫 날들 -->
                <div class="calendar-cell other-month">
                    <div class="calendar-date">1</div>
                </div>
                <div class="calendar-cell other-month">
                    <div class="calendar-date">2</div>
                </div>
                <div class="calendar-cell other-month">
                    <div class="calendar-date">3</div>
                </div>
            </div>
        </div>
    </main>

    <!-- 툴팁 -->
    <div class="tooltip" id="tooltip">
        <div class="tooltip-title"></div>
        <div class="tooltip-details"></div>
    </div>

    <script>
        // 툴팁 기능
        const tooltip = document.getElementById('tooltip');
        const cells = document.querySelectorAll('[data-tooltip]');

        cells.forEach(cell => {
            cell.addEventListener('mouseenter', (e) => {
                const data = e.target.getAttribute('data-tooltip').split('|');
                const title = data[0];
                const room = data[1];
                const time = data[2];
                const organizer = data[3];
                const attendees = data[4];

                tooltip.querySelector('.tooltip-title').textContent = title;
                tooltip.querySelector('.tooltip-details').innerHTML = `
                    ${room}<br>
                    ${time}<br>
                    ${organizer}<br>
                    ${attendees}
                `;

                const rect = e.target.getBoundingClientRect();
                tooltip.style.left = rect.left + 'px';
                tooltip.style.top = (rect.top - tooltip.offsetHeight - 10) + 'px';
                tooltip.classList.add('show');
            });

            cell.addEventListener('mouseleave', () => {
                tooltip.classList.remove('show');
            });
        });

        // 탭 전환 기능
        const tabBtns = document.querySelectorAll('.tab-btn');
        tabBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                tabBtns.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
            });
        });
    </script>
</body>
</html>
