<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - 회의실 예약 시스템</title>
    <link rel="stylesheet" href="/css/room/common.css">
    <link rel="stylesheet" href="/css/room/main.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body style="display: flex; align-items: center; justify-content: center; min-height: 100vh;">
    <div class="card" style="width: 100%; max-width: 400px; margin: 1rem;">
        <div class="card-content">
            <div style="text-align: center; margin-bottom: 2rem;">
                <h1 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-900); margin-bottom: 0.5rem;">회의실 예약 시스템</h1>
                <p style="color: var(--gray-600);">계정에 로그인하세요</p>
            </div>

            <form>
                <div class="form-group">
                    <label class="form-label">이메일</label>
                    <input type="email" class="form-input" placeholder="이메일을 입력하세요" required>
                </div>

                <div class="form-group">
                    <label class="form-label">비밀번호</label>
                    <input type="password" class="form-input" placeholder="비밀번호를 입력하세요" required>
                </div>


                <button type="submit" class="btn btn-primary" style="width: 100%; margin-bottom: 1rem;">
                    <i class="fas fa-sign-in-alt"></i>
                    로그인
                </button>

                <div style="text-align: center;">
                    <a href="register.html" style="color: var(--primary-color); text-decoration: none; font-size: 0.875rem;">
                        계정이 없으신가요? 회원가입
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
