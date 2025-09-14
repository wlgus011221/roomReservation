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
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
	<!-- 헤더 -->
	<%@ include file="/WEB-INF/jsp/egovframework/room/header.jsp"%>

	<!-- 메인 컨텐츠 -->
	<main class="main-container">
		<div class="flex items-center justify-between mb-4">
			<div>
				<h2>회의실 관리</h2>
				<p>회의실을 등록, 수정, 삭제할 수 있습니다.</p>
			</div>
			<button class="btn btn-primary" onclick="openAddModal()">
				<i class="fas fa-plus"></i> 회의실 추가
			</button>
		</div>

		<!-- 검색 및 필터 -->
		<div class="card">
			<div class="card-content">
				<div class="grid grid-cols-3 gap-4">
					<div class="form-group">
						<input type="text" id="searchName" class="form-input" placeholder="회의실 이름 검색...">
					</div>
					<div class="form-group">
						<select class="form-select" id="searchStatus">
							<option value="">모든 상태</option>
							<option value="available">사용 가능</option>
							<option value="maintenance">점검 중</option>
							<option value="disabled">사용 불가</option>
						</select>
					</div>
					<div class="form-group">
						<select class="form-select" id="searchFloor">
							<option value="">모든 층</option>
							<option value="1">1층</option>
							<option value="2">2층</option>
							<option value="3">3층</option>
						</select>
					</div>
				</div>
				<button class="btn btn-primary mt-2" onclick="searchRooms()">검색</button>
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
												<div class="">
													<c:out value="${room.name}" />
												</div>
											</td>
											<td><c:out value="${room.floor}" />층 <c:out
													value="${room.number}" /></td>
											<td class="capacity-cell"><c:out
													value="${room.capacity}" />명</td>
											<td>
												<div class="room-facility-container">
													<c:forEach var="facility" items="${room.facilities}">
														<span class="room-facility"><c:out
																value="${facility.name}" /></span>
													</c:forEach>
												</div>
											</td>
											<td><span class="status-badge status-${room.status}">
													<c:choose>
														<c:when test="${room.status eq 'available'}">사용 가능</c:when>
														<c:when test="${room.status eq 'maintenance'}">점검 중</c:when>
														<c:when test="${room.status eq 'disabled'}">사용 불가</c:when>
														<c:otherwise>
															<c:out value="${room.status}" />
														</c:otherwise>
													</c:choose>
											</span></td>
											<td>
												<div class="flex gap-2">
													<button class="btn btn-secondary"
														onclick="editRoom('<c:out value="${room.roomIdx}" />')">
														<i class="fas fa-edit"></i>
													</button>
													<button class="btn btn-danger"
														onclick="deleteRoom('<c:out value="${room.roomIdx}" />')">
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
							<label class="form-label">회의실명 *</label> <input type="text"
								name="name" class="form-input" placeholder="회의실명" required>
						</div>
						<div class="form-group">
							<label class="form-label">수용인원 *</label> <input type="number"
								name="capacity" class="form-input" placeholder="인원수" min="1"
								required>
						</div>
					</div>

					<div class="grid grid-cols-2 gap-4">
						<div class="form-group">
							<label class="form-label">층 *</label> <select class="form-select"
								name="floor" required>
								<option value="">층 선택</option>
								<option value="1">1층</option>
								<option value="2">2층</option>
								<option value="3">3층</option>
							</select>
						</div>
						<div class="form-group">
							<label class="form-label">호실 *</label> <input type="text"
								name="number" class="form-input" placeholder="예: 201호" required>
						</div>
					</div>

					<div class="form-group">
						<label class="form-label">시설</label>
						<div class="checkbox-group">
							<c:forEach var="facility" items="${facilityList}">
								<div class="checkbox-item">
									<input type="checkbox" id="facility_${facility.facilityIdx}"
										name="facilities" value="${facility.facilityIdx}"> <label
										for="facility_${facility.facilityIdx}">${facility.name}</label>
								</div>
							</c:forEach>
						</div>
					</div>

					<div class="form-group">
						<label class="form-label">상태</label> <select class="form-select"
							name="status">
							<option value="available">사용 가능</option>
							<option value="maintenance">점검 중</option>
							<option value="disabled">사용 불가</option>
						</select>
					</div>

					<div class="form-group">
						<label class="form-label">설명</label>
						<textarea class="form-textarea" name="description"
							placeholder="회의실에 대한 추가 설명"></textarea>
					</div>

					<div class="flex justify-end gap-3">
						<button type="button" class="btn btn-secondary"
							onclick="closeModal()">취소</button>
						<button type="submit" class="btn btn-primary">저장</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<script>
		function searchRooms() {
		    const name = $('#searchName').val();
		    const status = $('#searchStatus').val();
		    const floor = $('#searchFloor').val();
	
		    $.ajax({
		        url: '/getRoomList.do',
		        type: 'GET',
		        data: {
		            name: name,
		            status: status,
		            floor: floor
		        },
		        success: function(response) {
		            renderRoomTable(response.list);
		        },
		        error: function() {
		            alert('회의실 목록 조회 중 오류가 발생했습니다.');
		        }
		    });
		}
	
		function renderRoomTable(roomList) {
		    const tbody = $('table tbody');
		    tbody.empty();
	
		    if (roomList.length === 0) {
		        tbody.append('<tr><td colspan="6" class="text-center">등록된 회의실이 없습니다.</td></tr>');
		        return;
		    }
	
		    roomList.forEach(room => {
		        let facilities = '';
		        room.facilities?.forEach(f => {
		            facilities += `<span class="room-facility">\${f.name}</span> `;
		        });
				
		        let statusText = '';
		        switch(room.status) {
		            case 'available':
		                statusText = '사용 가능';
		                break;
		            case 'maintenance':
		                statusText = '점검 중';
		                break;
		            case 'disabled':
		                statusText = '사용 불가';
		                break;
		            default:
		                statusText = room.status;
		        }
		        
		        tbody.append(`
		            <tr>
		                <td>\${room.name}</td>
		                <td>\${room.floor}층 \${room.number}</td>
		                <td class="capacity-cell">\${room.capacity}명</td>
		                <td>\${facilities}</td>
		                <td><span class="status-badge status-\${room.status}">\${statusText}</span></td>
		                <td>
		                    <div class="flex gap-2">
		                        <button class="btn btn-secondary" onclick="editRoom(\${room.roomIdx})"><i class="fas fa-edit"></i></button>
		                        <button class="btn btn-danger" onclick="deleteRoom(\${room.roomIdx})"><i class="fas fa-trash"></i></button>
		                    </div>
		                </td>
		            </tr>
		        `);
		    });
		}
		
		function openAddModal() {
			resetForm();
		    document.getElementById('modalTitle').textContent = '회의실 추가';
		    const form = document.getElementById('roomAddForm');
		    form.action = 'addRoom.do';
		    document.getElementById('roomModal').classList.remove('hidden');
		}
		
		function openUpdateModal() {
			document.getElementById('modalTitle').textContent = '회의실 수정';
			const form = document.getElementById('roomAddForm');
		    form.action = 'updateRoom.do';
			document.getElementById('roomModal').classList.remove('hidden');
		}

		function redirectToMain(message) {
			alert(message);
		    window.location.href = '/main.do';
		}

		function resetForm() {
			const form = document.getElementById('roomAddForm');
			form.reset();
			
			// hidden 필드 제거 (수정 모드에서 추가되는 roomIdx 필드)
			const hiddenInput = form.querySelector('input[name="roomIdx"]');
			if (hiddenInput) {
				hiddenInput.remove();
			}
			
			// 모든 체크박스 초기화
			form.querySelectorAll('input[name="facilities"]').forEach(checkbox => {
				checkbox.checked = false;
			});
		}

		function editRoom(id) {
		    // console.log("editRoom 호출됨, id:", id);
		    
		    $.ajax({
		        url: '/selectRoom.do',
		        type: 'GET',
		        data: { roomIdx: id },
		        success: function(response) {
		            // console.log("AJAX 성공!");
		            // console.log("응답 타입:", typeof response);
		            // console.log("응답 내용:", response);
		            
		            // 응답이 문자열인 경우 JSON 파싱 시도
		            if (typeof response === 'string') {
		                try {
		                    response = JSON.parse(response);
		                    // console.log("JSON 파싱 후:", response);
		                } catch (e) {
		                    console.error("JSON 파싱 실패:", e);
		                    // console.log("원본 응답:", response);
		                    return;
		                }
		            }
		            
		            if (response.result === 'success') {
		                // console.log("성공 응답 - 데이터:", response.data);
		                // alert("데이터 로드 성공!\n회의실명: " + response.data.name);
		                fillModalForm(response.data);
		                openUpdateModal();
		            } else {
		                // console.log("실패 응답:", response.msg);
		                alert("실패: " + response.msg);
		            }
		        },
		        error: function(xhr, status, error) {
		            // console.log("AJAX 에러 발생");
		            // console.log("상태:", xhr.status);
		            // console.log("응답 텍스트:", xhr.responseText);
		            console.log("에러:", error);
		            
		            alert("에러 발생: " + xhr.status + " - " + error);
		        }
		    });
		}
		
		function fillModalForm(roomData) {
		    const form = document.getElementById('roomAddForm');

		    // 일반 텍스트 및 숫자 필드 채우기
		    form.querySelector('input[name="name"]').value = roomData.name || '';
		    form.querySelector('input[name="capacity"]').value = roomData.capacity || '';
		    form.querySelector('select[name="floor"]').value = roomData.floor || '';
		    form.querySelector('input[name="number"]').value = roomData.number || '';
		    form.querySelector('select[name="status"]').value = roomData.status || '';
		    form.querySelector('textarea[name="description"]').value = roomData.description || '';

		    // 체크박스 필드 처리 (중요)
		    const facilities = roomData.facilities || [];
		    form.querySelectorAll('input[name="facilities"]').forEach(checkbox => {
		        // 기존 선택 상태 초기화
		        checkbox.checked = false;
		        // 서버에서 받은 시설 목록에 해당 체크박스의 value가 포함되어 있으면 체크
		        facilities.forEach(facility => {
		            if (String(facility.facilityIdx) === checkbox.value) {
		                checkbox.checked = true;
		            }
		        });
		    });

		    // 수정 모드임을 나타내는 hidden 필드 추가
		    let hiddenInput = form.querySelector('input[name="roomIdx"]');
		    if (!hiddenInput) {
		        hiddenInput = document.createElement('input');
		        hiddenInput.type = 'hidden';
		        hiddenInput.name = 'roomIdx';
		        form.appendChild(hiddenInput);
		    }
		    hiddenInput.value = roomData.roomIdx;
		}

		function deleteRoom(id) {
			if (confirm('정말로 이 회의실을 삭제하시겠습니까?')) {
				$.ajax({
					// 컨트롤러의 @RequestMapping 경로를 올바르게 지정
					url : '/deleteRoom.do',
					type : 'POST',
					data : {
						roomIdx : id
					}, // 컨트롤러로 보낼 데이터
					success : function(response) {
						// 서버로부터 'success' 문자열을 받으면 성공 처리
						if (response === 'success') {
							alert('회의실이 성공적으로 삭제되었습니다.');
							window.location.href = '/roomManagement.do';
						} else {
							alert('회의실 삭제 중 오류가 발생했습니다.');
						}
					},
					error : function() {
						alert('서버와 통신 중 오류가 발생했습니다.');
					}
				});
			}
		}

		function closeModal() {
			document.getElementById('roomModal').classList.add('hidden');
		}
	</script>
</body>
</html>
