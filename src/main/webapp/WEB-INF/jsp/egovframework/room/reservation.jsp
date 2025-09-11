<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회의실 예약 - Meeting Room Booking</title>
    <link rel="stylesheet" href="/css/room/common.css">
    <link rel="stylesheet" href="/css/room/reservation.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- 헤더 -->
    <%@ include file="/WEB-INF/jsp/egovframework/room/header.jsp" %>

    <!-- 메인 컨텐츠 -->
    <main class="main-container">
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">회의실 예약</h2>
            </div>
            <div class="card-content">
                <form class="flex flex-col gap-6" id="reservationForm" action="addReservation.do" method="post">
                    <!-- 기본 정보 -->
                    <div class="grid grid-cols-2 gap-6">
                        <div class="form-group">
                            <label class="form-label">회의 제목 *</label>
                            <input type="text" name="title" class="form-input" placeholder="회의 제목을 입력하세요" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">회의실 *</label>
                            <select class="form-select" name="roomIdx" required>
                                <option value="">회의실을 선택하세요</option>
                                <c:forEach var="room" items="${roomList}">
		                            <option value="${room.roomIdx}">${room.name} (${room.capacity}명)</option>
		                        </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-6">
                        <div class="form-group">
                            <label class="form-label">예약자 (소속) *</label>
                            <input type="text" class="form-input" value="${name} (${department})" readonly>
                        	<input type="hidden" name="userIdx" value="${userIdx}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">참석 인원 *</label>
                            <input type="number" name="attendees" min="1" max="50" class="form-input" placeholder="5" required>
                        </div>
                    </div>

                    <!-- 반복 예약 옵션 -->
                    <div class="border-top">
                    	<!-- 
                        <div class="flex items-center gap-3">
                            <input type="checkbox" id="recurring" name="isRecurring" onchange="toggleRecurring()">
                            <label for="recurring" class="form-label">반복 예약</label>
                        </div>
						-->
						
                        <!-- 일회성 예약 (기본) -->
                        <div id="single-booking" class="flex flex-col gap-4">
                            <div class="grid grid-cols-2 gap-6">
                                <div class="form-group">
                                    <label class="form-label">예약 날짜 *</label>
                                    <input type="date" name="date" class="form-input" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">예약 시간 *</label>
                                    <div class="flex gap-2">
                                        <input type="time" name="startTime" class="form-input" required>
                                        <span class="flex items-center">~</span>
                                        <input type="time" name="endTime" class="form-input" required>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 반복 예약 설정 -->
                        <div id="recurring-booking" class="flex flex-col gap-4 hidden">
                            <div class="form-group">
                                <label class="form-label">반복 주기 *</label>
                                <select class="form-select">
                                    <option value="daily">매일</option>
                                    <option value="weekly">매주</option>
                                    <option value="monthly">매월</option>
                                    <option value="yearly">매년</option>
                                </select>
                            </div>

                            <!-- 요일 선택 -->
                            <div class="form-group">
                                <label class="form-label">요일 선택 *</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" value="monday">
                                        <span>월</span>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" value="tuesday">
                                        <span>화</span>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" value="wednesday">
                                        <span>수</span>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" value="thursday">
                                        <span>목</span>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" value="friday">
                                        <span>금</span>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" value="saturday">
                                        <span>토</span>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" value="sunday">
                                        <span>일</span>
                                    </div>
                                </div>
                            </div>

                            <!-- 시간 설정 -->
                            <div class="form-group">
                                <label class="form-label">시간 *</label>
                                <div class="flex gap-2">
                                    <input type="time" class="form-input" placeholder="시작 시간">
                                    <span class="flex items-center">~</span>
                                    <input type="time" class="form-input" placeholder="종료 시간">
                                </div>
                            </div>

                            <!-- 반복 기간 -->
                            <div class="grid grid-cols-2 gap-6">
                                <div class="form-group">
                                    <label class="form-label">시작일 *</label>
                                    <input type="date" class="form-input">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">종료일 *</label>
                                    <input type="date" class="form-input">
                                </div>
                            </div>

                            <!-- 반복 예약 미리보기 -->
                            <div class="alert alert-info">
                                <h4>반복 예약 미리보기</h4>
                                <div style="font-size: 0.875rem;">
                                    <p>• 매주 월, 수, 금요일</p>
                                    <p>• 09:00 ~ 10:00</p>
                                    <p>• 2024.01.01 ~ 2024.03.31 (총 39회)</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 회의 내용 -->
                    <div class="form-group">
                        <label class="form-label">회의 내용</label>
                        <textarea class="form-textarea" name="content" placeholder="회의 안건이나 내용을 입력하세요"></textarea>
                    </div>

                    <!-- 관리자 전용 기능 -->
                    <!-- 
                    <c:if test="${userType eq 'ADMIN'}">
	                    <div class="border-top">
	                        <div class="flex items-center gap-3">
	                            <i class="fas fa-crown" style="color: var(--warning-color);"></i>
	                            <span class="form-label">관리자 전용 기능</span>
	                        </div>
	                        
	                        <div class="alert alert-warning">
	                            <h4>엑셀 파일 업로드 (통합 예약)</h4>
	                            <div class="flex flex-col gap-3">
	                                <input type="file" accept=".xlsx,.xls" class="form-input">
	                                <p style="font-size: 0.75rem;">
	                                    엑셀 파일 형식: 제목, 회의실, 예약자, 날짜, 시작시간, 종료시간, 참석인원, 회의내용
	                                </p>
	                                <button type="button" class="btn btn-warning" style="width: fit-content;">
	                                    <i class="fas fa-download"></i> 템플릿 다운로드
	                                </button>
	                            </div>
	                        </div>
	                    </div>
                    </c:if>
					 -->
					 
                    <!-- 버튼 -->
                    <div class="flex justify-end gap-4">
                        <button type="button" class="btn btn-secondary">취소</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-calendar-plus"></i> 예약하기
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script>    
        function toggleRecurring() {
            const recurringCheckbox = document.getElementById('recurring');
            const singleBooking = document.getElementById('single-booking');
            const recurringBooking = document.getElementById('recurring-booking');
            
            if (recurringCheckbox.checked) {
                singleBooking.classList.add('hidden');
                recurringBooking.classList.remove('hidden');
            } else {
                singleBooking.classList.remove('hidden');
                recurringBooking.classList.add('hidden');
            }
        }
    </script>
</body>
</html>
