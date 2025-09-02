<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - 회의실 예약 시스템</title>
    <link rel="stylesheet" href="/css/room/common.css">
    <link rel="stylesheet" href="/css/room/register.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
    <div class="card">
        <div class="card-content">
            <div>
                <h1>회원가입</h1>
                <p>새 계정을 만들어 회의실을 예약하세요</p>
            </div>

            <!-- 메시지 표시 -->
            <c:if test="${not empty message}">
                <div class="alert alert-${messageType}">
                    ${message}
                </div>
            </c:if>

            <form id="registerForm" action="registerProcess.do" method="post">
                <div class="grid grid-cols-2 gap-4">
                    <div class="form-group">
                        <label class="form-label">이름 *</label>
                        <input type="text" name="name" id="userName" class="form-input" placeholder="이름" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">사번 *</label>
                        <div class="input-with-btn">
                            <input type="text" name="id" id="userId" class="form-input" placeholder="사번" required>
                            <button type="button" class="btn btn-secondary" onclick="checkDuplicateId()">중복확인</button>
                        </div>
                        <div id="idCheckResult" class="validation-message"></div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">부서 *</label>
                    <select name="departmentIdx" class="form-select" required>
                        <option value="">부서 선택</option>
                        <c:forEach var="dept" items="${deptList}">
                            <option value="${dept.departmentIdx}">${dept.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">이메일 *</label>
                    <div class="input-with-btn">
                        <input type="email" name="email" id="userEmail" class="form-input" placeholder="이메일 주소" required>
                        <button type="button" class="btn btn-secondary" onclick="checkDuplicateEmail()">중복확인</button>
                    </div>
                    <div id="emailCheckResult" class="validation-message"></div>
                </div>

                <div class="form-group">
                    <label class="form-label">전화번호</label>
                    <input type="tel" name="phone" id="userPhone" class="form-input" placeholder="010-0000-0000">
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div class="form-group">
                        <label class="form-label">비밀번호 *</label>
                        <input type="password" name="passwd" id="password" class="form-input" placeholder="비밀번호" required>
                        <div id="passwordStrength" class="password-strength"></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">비밀번호 확인 *</label>
                        <input type="password" id="passwordConfirm" class="form-input" placeholder="비밀번호 확인" required>
                        <div id="passwordMatch" class="validation-message"></div>
                    </div>
                </div>

                <!-- 사용자 타입 (숨김) -->
                <input type="hidden" name="userType" value="USER">

                <button type="submit" class="btn btn-primary submit-btn" id="submitBtn">
                    <i class="fas fa-user-plus"></i>
                    회원가입
                </button>

                <div class="form-footer">
                    <a href="login.do">
                        이미 계정이 있으신가요? 로그인
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        let idChecked = false;
        let emailChecked = false;
        let passwordMatch = false;

        // 아이디 중복 확인
        function checkDuplicateId() {
            const userId = document.getElementById('userId').value;
            if (!userId) {
                alert('사번을 입력하세요.');
                return;
            }

            $.ajax({
                url: 'checkId.do',
                type: 'POST',
                data: { id: userId },
                success: function(result) {
                    console.log('아이디 중복 체크 결과:', result);
                    const resultDiv = document.getElementById('idCheckResult');
                    if (result === 'duplicate') {
                        resultDiv.innerHTML = '<span class="text-danger">이미 사용 중인 사번입니다.</span>';
                        idChecked = false;
                    } else {
                        resultDiv.innerHTML = '<span class="text-success">사용 가능한 사번입니다.</span>';
                        idChecked = true;
                    }
                    validateForm();
                },
                error: function() {
                    alert('중복 확인 중 오류가 발생했습니다.');
                }
            });
        }

        // 이메일 중복 확인
        function checkDuplicateEmail() {
            const userEmail = document.getElementById('userEmail').value;
            if (!userEmail) {
                alert('이메일을 입력하세요.');
                return;
            }

            $.ajax({
                url: 'checkEmail.do',
                type: 'POST',
                data: { email: userEmail },
                success: function(result) {
                    console.log('이메일 중복 체크 결과:', result);
                    const resultDiv = document.getElementById('emailCheckResult');
                    if (result === 'duplicate') {
                        resultDiv.innerHTML = '<span class="text-danger">이미 사용 중인 이메일입니다.</span>';
                        emailChecked = false;
                    } else {
                        resultDiv.innerHTML = '<span class="text-success">사용 가능한 이메일입니다.</span>';
                        emailChecked = true;
                    }
                    validateForm();
                },
                error: function() {
                    alert('중복 확인 중 오류가 발생했습니다.');
                }
            });
        }

        // 비밀번호 확인
        document.getElementById('password').addEventListener('input', function() {
            checkPasswordMatch();
        });

        document.getElementById('passwordConfirm').addEventListener('input', function() {
            checkPasswordMatch();
        });

        function checkPasswordMatch() {
            const password = document.getElementById('password').value;
            const passwordConfirm = document.getElementById('passwordConfirm').value;
            const matchDiv = document.getElementById('passwordMatch');
            
            if (passwordConfirm.length === 0) {
                matchDiv.innerHTML = '';
                passwordMatch = false;
            } else if (password === passwordConfirm) {
                matchDiv.innerHTML = '<span class="text-success">비밀번호가 일치합니다.</span>';
                passwordMatch = true;
            } else {
                matchDiv.innerHTML = '<span class="text-danger">비밀번호가 일치하지 않습니다.</span>';
                passwordMatch = false;
            }
            validateForm();
        }

        // 사번, 이메일 입력 시 중복 확인 상태 초기화
        document.getElementById('userId').addEventListener('input', function() {
            idChecked = false;
            document.getElementById('idCheckResult').innerHTML = '';
            validateForm();
        });

        document.getElementById('userEmail').addEventListener('input', function() {
            emailChecked = false;
            document.getElementById('emailCheckResult').innerHTML = '';
            validateForm();
        });

        // 폼 유효성 검사
        function validateForm() {
            const submitBtn = document.getElementById('submitBtn');
            // 중복 확인과 비밀번호 일치만 확인
            if (idChecked && emailChecked && passwordMatch) {
                submitBtn.disabled = false;
                submitBtn.classList.remove('btn-disabled');
            } else {
                submitBtn.disabled = true;
                submitBtn.classList.add('btn-disabled');
            }
        }

        // 초기 상태로 버튼 비활성화
        document.getElementById('submitBtn').disabled = true;
        document.getElementById('submitBtn').classList.add('btn-disabled');
    </script>
</body>
</html>