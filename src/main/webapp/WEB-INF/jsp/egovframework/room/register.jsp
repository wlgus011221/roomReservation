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
</head>
<body>
    <div class="card">
        <div class="card-content">
            <div>
                <h1>회원가입</h1>
                <p>새 계정을 만들어 회의실을 예약하세요</p>
            </div>

            <form>
                <div class="grid grid-cols-2 gap-4">
                    <div class="form-group">
                        <label class="form-label">이름 *</label>
                        <input type="text" class="form-input" placeholder="이름" required>
                    </div>
                    <div class="form-group">
	                    <label class="form-label">사번 *</label>
	                    <input type="text" class="form-input" placeholder="사번" required>
	                </div>
                    <div class="form-group">
                        <label class="form-label">부서 *</label>
                        <select class="form-select" required>
                            <option value="">부서 선택</option>
                            <c:forEach var="dept" items="${deptList}">
					            <option value="${dept.departmentIdx}">${dept.name}</option>
					        </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">이메일 *</label>
                    <input type="email" class="form-input" placeholder="이메일 주소" required>
                </div>

                <div class="form-group">
                    <label class="form-label">전화번호</label>
                    <input type="tel" class="form-input" placeholder="010-0000-0000">
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div class="form-group">
                        <label class="form-label">비밀번호 *</label>
                        <input type="password" class="form-input" placeholder="비밀번호" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">비밀번호 확인 *</label>
                        <input type="password" class="form-input" placeholder="비밀번호 확인" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary submit-btn">
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
</body>
</html>
