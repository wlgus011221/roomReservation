package egovframework.room.web;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.room.service.DepartmentService;
import egovframework.room.service.DepartmentVO;
import egovframework.room.service.UserService;
import egovframework.room.service.UserVO;
import egovframework.room.service.impl.DepartmentMapper;
import egovframework.room.service.impl.UserMapper;

@Controller
public class RoomController {

	@Autowired
	private DataSource dataSource;

	@Autowired
	private DepartmentService departmentService;

	@Autowired
	private DepartmentMapper departmentMapper;

	@Autowired
	private UserService userService;

	@Autowired
	private UserMapper userMapper;

	/**
	 * 비밀번호 SHA-512 암호화
	 */
	private String sha512(String input) {
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-512");
			byte[] hashedBytes = md.digest(input.getBytes(StandardCharsets.UTF_8));
			StringBuilder sb = new StringBuilder();
			for (byte b : hashedBytes) {
				sb.append(String.format("%02x", b));
			}
			return sb.toString();
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException("SHA-512 알고리즘을 사용할 수 없습니다.", e);
		}
	}

	@RequestMapping(value = "/main.do")
	public String main(ModelMap model) throws Exception {
		model.addAttribute("today", new Date());
		return "/main";
	}

	@RequestMapping(value = "/login.do")
	public String login(ModelMap model) throws Exception {	
		return "/login";
	}
	
	/**
	 * 로그인 처리 
	 */
	@PostMapping(value = "/loginProcess.do")
	public String loginProcess(ModelMap model, @RequestParam("id") String id, @RequestParam("passwd") String passwd, HttpServletRequest request) throws Exception {
		System.out.println("id=" + id);
		System.out.println("passwd=" + sha512(passwd));
		
		UserVO userVO = new UserVO();
		userVO.setId(id);
		userVO.setPasswd(sha512(passwd));

		UserVO resultVO = userService.selectLoginCheck(userVO);
		
		if(resultVO != null && resultVO.getId() != null) {
			request.getSession().setAttribute("id", resultVO.getId());
			request.getSession().setAttribute("name", resultVO.getName());
			request.getSession().setAttribute("userType", resultVO.getUserType());
			return "redirect:/main.do";
		} else {
			request.getSession().setAttribute("id", "");
			request.getSession().setAttribute("name", "");
			request.getSession().setAttribute("userType", "");
			model.addAttribute("msg", "사용자 정보가 올바르지 않습니다.");
			return "forward:/login.do";
		}
	}
	
	/**
	 * 로그아웃 처리
	 */
	@RequestMapping(value= "logout.do")
	public String logout(ModelMap model, HttpServletRequest request) throws Exception {
		request.getSession().invalidate();
		return "redirect:main.do";
	}

	@RequestMapping(value = "/register.do")
	public String register(ModelMap model) throws Exception {
		// DB에서 부서 목록 조회
		List<DepartmentVO> deptList = departmentMapper.selectDepartmentList(new DepartmentVO());
		model.addAttribute("deptList", deptList);

		return "/register";
	}

	/**
	 * 회원가입 처리
	 */
	@PostMapping(value = "/registerProcess.do")
	public String registerProcess(@ModelAttribute UserVO userVO, RedirectAttributes redirectAttributes) throws Exception {
		System.out.println("회원가입 처리 - UserVO: " + userVO.toString());
		try {
			// 비밀번호 암호화
			String encryptedPassword = sha512(userVO.getPasswd());
			userVO.setPasswd(encryptedPassword);

			// 기본 사용자 타입 설정
			if (userVO.getUserType() == null || userVO.getUserType().isEmpty()) {
				userVO.setUserType("USER");
			}

			// 회원가입 처리 (UserService에서 중복 체크 처리)
			String result = userService.insertUser(userVO);
			System.out.println("회원가입 완료 - userIdx: " + result);

			redirectAttributes.addFlashAttribute("message", "회원가입이 완료되었습니다.");
			redirectAttributes.addFlashAttribute("messageType", "success");

			return "redirect:/login.do";

		} catch (Exception e) {
			System.out.println("회원가입 오류: " + e.getMessage());
			redirectAttributes.addFlashAttribute("message", "회원가입 중 오류가 발생했습니다: " + e.getMessage());
			redirectAttributes.addFlashAttribute("messageType", "error");
			return "redirect:/register.do";
		}
	}

	/**
	 * 아이디 중복 체크 (AJAX)
	 */
	@PostMapping(value = "/checkId.do")
	@ResponseBody
	public String checkId(@ModelAttribute UserVO userVO) {
		try {
			System.out.println("아이디 중복 체크: " + userVO.getId());
			int count = userMapper.selectUserById(userVO);
			System.out.println("중복 체크 결과: " + count);
			return count > 0 ? "duplicate" : "available";
		} catch (Exception e) {
			System.out.println("중복 체크 오류: " + e.getMessage());
			return "available";
		}
	}

	/**
	 * 이메일 중복 체크 (AJAX)
	 */
	@PostMapping(value = "/checkEmail.do")
	@ResponseBody
	public String checkEmail(@ModelAttribute UserVO userVO) {
		try {
			System.out.println("이메일 중복 체크: " + userVO.getEmail());
			int count = userMapper.selectUserByEmail(userVO);
			System.out.println("이메일 중복 체크 결과: " + count);
			return count > 0 ? "duplicate" : "available";
		} catch (Exception e) {
			System.out.println("이메일 중복 체크 오류: " + e.getMessage());
			return "available";
		}
	}

	@RequestMapping(value = "/myPage.do")
	public String myPage(ModelMap model) throws Exception {
		return "/myPage";
	}

	@RequestMapping(value = "/booking.do")
	public String booking(ModelMap model) throws Exception {
		return "/booking";
	}

	@RequestMapping(value = "/roomManagement.do")
	public String roomManagement(ModelMap model) throws Exception {
		return "/roomManagement";
	}

	@RequestMapping(value = "/test.do", produces = "text/html; charset=UTF-8")
	@ResponseBody
	public String test(ModelMap model) throws Exception {
		System.out.println("테스트중");
		try {
			// DB 연결 확인
			Connection conn = dataSource.getConnection();
			String dbName = conn.getCatalog();
			String dbVersion = conn.getMetaData().getDatabaseProductVersion();
			conn.close();

			// department 테이블 조회
			List<DepartmentVO> deptList = departmentMapper.selectDepartmentList(new DepartmentVO());

			StringBuilder sb = new StringBuilder();
			sb.append("DB 연결 성공!<br>");
			sb.append("데이터베이스: " + dbName + "<br>");
			sb.append("MySQL 버전: " + dbVersion + "<br>");
			sb.append("부서 목록:<br>");

			for (DepartmentVO dept : deptList) {
				sb.append("[" + dept.getDepartmentIdx() + "] " + dept.getName() + "<br>");
			}

			return sb.toString();

		} catch (SQLException e) {
			return "DB 연결 실패: " + e.getMessage();
		}
	}

}
