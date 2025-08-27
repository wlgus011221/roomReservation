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
    <header class="header">
        <div class="header-left">
            <h1>회의실 예약 시스템</h1>
        </div>
        <nav class="nav-menu">
            <a href="main.do">대시보드</a>
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
                            <tr>
                                <td>
                                    <div>컨퍼런스룸 A</div>
                                    <div>대형 회의실</div>
                                </td>
                                <td>2층 201호</td>
                                <td>20명</td>
                                <td>
                                    <div class="flex gap-1">
                                        <span>프로젝터</span>
                                        <span>화이트보드</span>
                                        <span>화상회의</span>
                                    </div>
                                </td>
                                <td>
                                    <span class="status-badge status-available">사용 가능</span>
                                </td>
                                <td>
                                    <div class="flex gap-2">
                                        <button class="btn btn-secondary" onclick="editRoom(1)">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-danger" onclick="deleteRoom(1)">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div>컨퍼런스룸 B</div>
                                    <div>중형 회의실</div>
                                </td>
                                <td>2층 202호</td>
                                <td>12명</td>
                                <td>
                                    <div class="flex gap-1">
                                        <span>TV</span>
                                        <span>화이트보드</span>
                                    </div>
                                </td>
                                <td>
                                    <span class="status-badge status-maintenance">점검 중</span>
                                </td>
                                <td>
                                    <div class="flex gap-2">
                                        <button class="btn btn-secondary" onclick="editRoom(2)">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-danger" onclick="deleteRoom(2)">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div>미팅룸 1</div>
                                    <div>소형 회의실</div>
                                </td>
                                <td>1층 101호</td>
                                <td>6명</td>
                                <td>
                                    <div class="flex gap-1">
                                        <span>화이트보드</span>
                                    </div>
                                </td>
                                <td>
                                    <span class="status-badge status-available">사용 가능</span>
                                </td>
                                <td>
                                    <div class="flex gap-2">
                                        <button class="btn btn-secondary" onclick="editRoom(3)">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-danger" onclick="deleteRoom(3)">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <!-- 회의실 추가/수정 모달 -->
    <div id="roomModal" class="hidden"">
        <div class="card">
            <div class="card-header">
                <div class="flex items-center justify-between">
                    <h3 class="card-title" id="modalTitle">회의실 추가</h3>
                    <button onclick="closeModal()">×</button>
                </div>
            </div>
            <div class="card-content">
                <form>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="form-group">
                            <label class="form-label">회의실명 *</label>
                            <input type="text" class="form-input" placeholder="회의실명" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">수용인원 *</label>
                            <input type="number" class="form-input" placeholder="인원수" min="1" required>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div class="form-group">
                            <label class="form-label">층 *</label>
                            <select class="form-select" required>
                                <option value="">층 선택</option>
                                <option value="1">1층</option>
                                <option value="2">2층</option>
                                <option value="3">3층</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">호실 *</label>
                            <input type="text" class="form-input" placeholder="예: 201호" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">시설</label>
                        <div class="checkbox-group">
                            <div class="checkbox-item">
                                <input type="checkbox" id="projector" value="projector">
                                <label for="projector">프로젝터</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="tv" value="tv">
                                <label for="tv">TV</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="whiteboard" value="whiteboard">
                                <label for="whiteboard">화이트보드</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="videoconf" value="videoconf">
                                <label for="videoconf">화상회의</label>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">상태</label>
                        <select class="form-select">
                            <option value="available">사용 가능</option>
                            <option value="maintenance">점검 중</option>
                            <option value="disabled">사용 불가</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">설명</label>
                        <textarea class="form-textarea" placeholder="회의실에 대한 추가 설명"></textarea>
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
