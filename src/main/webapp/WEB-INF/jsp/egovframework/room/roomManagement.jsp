<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회의실 관리 - 회의실 예약 시스템</title>
    <link rel="stylesheet" href="/css/room/common.css">
    <link rel="stylesheet" href="/css/room/roomManagement.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- 헤더 -->
    <%@ include file="/WEB-INF/jsp/egovframework/room/header.jsp" %>

    <!-- 메인 컨텐츠 -->
    <main class="main-container">
        <div class="flex items-center justify-between mb-4">
            <div>
                <h2>회의실 관리</h2>
                <p>회의실을 등록, 수정, 삭제할 수 있습니다.</p>
            </div>
            <button class="btn btn-primary" onclick="openAddModal()">
                <i class="fas fa-plus"></i>
                회의실 추가
            </button>
        </div>

        <!-- 검색 및 필터 -->
        <div class="card">
            <div class="card-content">
                <div class="grid grid-cols-3 gap-4">
                    <div class="form-group">
                        <input type="text" class="form-input" placeholder="회의실 이름 검색...">
                    </div>
                    <div class="form-group">
                        <select class="form-select">
                            <option value="">모든 상태</option>
                            <option value="available">사용 가능</option>
                            <option value="maintenance">점검 중</option>
                            <option value="disabled">사용 불가</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <select class="form-select">
                            <option value="">모든 층</option>
                            <option value="1">1층</option>
                            <option value="2">2층</option>
                            <option value="3">3층</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <!-- 회의실 목록 -->
        <div class="card">
	        <div class="card-content">
	            <div>
	                <table>
	                    <thead>
	                        <tr>
	                            <th>회의실명</th>
	                            <th>위치</th>
	                            <th>수용인원</th>
	                            <th>시설</th>
	                            <th>상태</th>
	                            <th>관리</th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                        <c:choose>
	                            <c:when test="${not empty roomList}">
	                                <c:forEach var="room" items="${roomList}">
	                                    <tr>
	                                        <td>
	                                            <div class="name-cell"><c:out value="${room.name}" /></div>
	                                        </td>
	                                        <td><c:out value="${room.floor}" />층 <c:out value="${room.number}" /></td>
	                                        <td class="capacity-cell"><c:out value="${room.capacity}" />명</td>
	                                        <td>
	                                            <div class="room-facility-container">
	                                                <c:forEach var="facility" items="${room.facilities}">
	                                                    <span class="room-facility"><c:out value="${facility.name}" /></span>
	                                                </c:forEach>
	                                            </div>
	                                        </td>
	                                        <td>
	                                            <span class="status-badge status-${room.status}">
	                                                <c:choose>
	                                                    <c:when test="${room.status eq 'available'}">사용 가능</c:when>
	                                                    <c:when test="${room.status eq 'maintenance'}">점검 중</c:when>
	                                                    <c:when test="${room.status eq 'disabled'}">사용 불가</c:when>
	                                                    <c:otherwise><c:out value="${room.status}" /></c:otherwise>
	                                                </c:choose>
	                                            </span>
	                                        </td>
	                                        <td>
	                                            <div class="flex gap-2">
	                                                <button class="btn btn-secondary" onclick="editRoom('<c:out value="${room.roomIdx}" />')">
	                                                    <i class="fas fa-edit"></i>
	                                                </button>
	                                                <button class="btn btn-danger" onclick="deleteRoom('<c:out value="${room.roomIdx}" />')">
	                                                    <i class="fas fa-trash"></i>
	                                                </button>
	                                            </div>
	                                        </td>
	                                    </tr>
	                                </c:forEach>
	                            </c:when>
	                            <c:otherwise>
	                                <tr>
	                                    <td colspan="6" class="text-center">등록된 회의실이 없습니다.</td>
	                                </tr>
	                            </c:otherwise>
	                        </c:choose>
	                    </tbody>
	                </table>
	            </div>
	        </div>
	    </div>
    </main>

    <!-- 회의실 추가/수정 모달 -->
    <div id="roomModal" class="hidden">
        <div class="card">
            <div class="card-header">
                <div class="flex items-center justify-between">
                    <h3 class="card-title" id="modalTitle">회의실 추가</h3>
                    <button onclick="closeModal()">×</button>
                </div>
            </div>
            <div class="card-content">
                <form id="roomAddForm" action="addRoom.do" method="post">
                    <div class="grid grid-cols-2 gap-4">
                        <div class="form-group">
                            <label class="form-label">회의실명 *</label>
                            <input type="text" name="name" class="form-input" placeholder="회의실명" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">수용인원 *</label>
                            <input type="number" name="capacity" class="form-input" placeholder="인원수" min="1" required>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div class="form-group">
                            <label class="form-label">층 *</label>
                            <select class="form-select" name="floor" required>
                                <option value="">층 선택</option>
                                <option value="1">1층</option>
                                <option value="2">2층</option>
                                <option value="3">3층</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">호실 *</label>
                            <input type="text" name="number" class="form-input" placeholder="예: 201호" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">시설</label>
                        <div class="checkbox-group">
                            <c:forEach var="facility" items="${facilityList}">
							    <div class="checkbox-item">
							        <input type="checkbox" id="facility_${facility.facilityIdx}" name="facilities" value="${facility.facilityIdx}">
							        <label for="facility_${facility.facilityIdx}">${facility.name}</label>
							    </div>
							</c:forEach>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">상태</label>
                        <select class="form-select" name="status">
                            <option value="available">사용 가능</option>
                            <option value="maintenance">점검 중</option>
                            <option value="disabled">사용 불가</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">설명</label>
                        <textarea class="form-textarea" name="description" placeholder="회의실에 대한 추가 설명"></textarea>
                    </div>

                    <div class="flex justify-end gap-3">
                        <button type="button" class="btn btn-secondary" onclick="closeModal()">취소</button>
                        <button type="submit" class="btn btn-primary">저장</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
	 	// 서버에서 전달된 'msg' 값이 있는지 확인
	    const message = '${msg}';
	    
	    // 메시지가 비어있지 않거나 'null'이 아니면 알림창 띄우기
	    if (message && message !== 'null' && message.trim() !== '') {
	        alert(message);
	    }
    
        function openAddModal() {
            document.getElementById('modalTitle').textContent = '회의실 추가';
            document.getElementById('roomModal').classList.remove('hidden');
        }

        function editRoom(id) {
            document.getElementById('modalTitle').textContent = '회의실 수정';
            document.getElementById('roomModal').classList.remove('hidden');
            // 실제로는 여기서 해당 회의실 데이터를 로드해야 함
        }

        function deleteRoom(id) {
            if (confirm('정말로 이 회의실을 삭제하시겠습니까?')) {
                // 실제로는 여기서 삭제 처리
                alert('회의실이 삭제되었습니다.');
            }
        }

        function closeModal() {
            document.getElementById('roomModal').classList.add('hidden');
        }
    </script>
</body>
</html>
