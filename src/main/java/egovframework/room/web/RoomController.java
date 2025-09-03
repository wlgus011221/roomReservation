package egovframework.room.web;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.room.service.DepartmentService;
import egovframework.room.service.DepartmentVO;
import egovframework.room.service.FacilityVO;
import egovframework.room.service.RoomService;
import egovframework.room.service.RoomVO;
import egovframework.room.service.UserService;
import egovframework.room.service.UserVO;
import egovframework.room.service.impl.DepartmentMapper;
import egovframework.room.service.impl.RoomMapper;
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
	
	@Autowired
	private RoomService roomService;

	@Autowired
	private RoomMapper roomMapper;

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
			request.getSession().setAttribute("userIdx", resultVO.getUserIdx());
			return "redirect:/main.do";
		} else {
			request.getSession().setAttribute("id", "");
			request.getSession().setAttribute("name", "");
			request.getSession().setAttribute("userType", "");
			request.getSession().setAttribute("userIdx", "");
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
	public String myPage(ModelMap model, HttpSession session) throws Exception {
		Integer userIdx = (Integer)session.getAttribute("userIdx");
		
		if(userIdx != null) {
			// 1. UserVO 객체 생성 및 ID 설정
	        UserVO vo = new UserVO();
	        vo.setUserIdx(userIdx);

	        // 2. UserVO 객체를 서비스 메소드로 전달하여 DB 조회
	        UserVO userDetails = userService.selectUser(vo);
	        
	        // 3. 조회된 정보를 모델에 담아 JSP로 전달
	        model.addAttribute("userDetails", userDetails);
	        
	        // 4. 부서 목록 전체 조회
	        List<DepartmentVO> deptList = departmentMapper.selectDepartmentList(new DepartmentVO());
			model.addAttribute("deptList", deptList);
		}
		
		return "/myPage";
	}

	@PostMapping("/updateProfile.do")
	public String updateProfile(@RequestParam("name") String name,
	                            @RequestParam("departmentIdx") int departmentIdx,
	                            @RequestParam("email") String email,
	                            @RequestParam("phone") String phone,
	                            HttpSession session,
	                            Model model) throws Exception {

	    Integer userIdx = (Integer) session.getAttribute("userIdx");
	    if (userIdx == null) {
	        model.addAttribute("msg", "로그인 상태가 아닙니다.");
	        return "forward:/login.do";
	    }
	    
	    try {
	        UserVO userVO = new UserVO();
	        userVO.setUserIdx(userIdx);
	        userVO.setName(name);
	        userVO.setDepartmentIdx(departmentIdx);
	        userVO.setEmail(email);
	        userVO.setPhone(phone);
	        
	        System.out.println(userIdx);
	        
	        // 서비스 호출
	        userService.updateUser(userVO);
	        
	        // 세션 정보 업데이트 (필수)
	        session.setAttribute("name", name);
	        
	        model.addAttribute("msg", "프로필 정보가 성공적으로 변경되었습니다.");
	    } catch (Exception e) {
	        model.addAttribute("msg", "프로필 업데이트 중 오류가 발생했습니다: " + e.getMessage());
	    }
	    
	    // 처리 후 다시 마이페이지로 돌아감
	    return "forward:/myPage.do";
	}

	@PostMapping("/updatePassword.do")
	public String updatePassword(@RequestParam("currentPassword") String currentPassword, 
	                             @RequestParam("newPassword") String newPassword, 
	                             HttpSession session, Model model) throws Exception {

	    Integer userIdx = (Integer) session.getAttribute("userIdx");
	    if (userIdx == null) {
	        model.addAttribute("msg", "로그인 상태가 아닙니다.");
	        return "forward:/myPage.do"; // 로그인 페이지로 리디렉션
	    }
	    
	    // 암호화 로직은 기존과 동일
	    String hashedCurrentPassword = sha512(currentPassword);
	    String hashedNewPassword = sha512(newPassword);
	    
	    try {
	        userService.updatePassword(userIdx, hashedCurrentPassword, hashedNewPassword);
	        model.addAttribute("msg", "비밀번호 변경이 완료되었습니다.");
	    } catch (Exception e) {
	        model.addAttribute("msg", e.getMessage());
	    }
	    
	    // 처리 후 마이페이지로 다시 포워딩
	    return "forward:/myPage.do";
	}

	@RequestMapping(value = "/booking.do")
	public String booking(ModelMap model) throws Exception {
		return "/booking";
	}

	@RequestMapping(value = "/roomManagement.do")
	public String roomManagement(HttpSession session, Model model) throws Exception {
		Integer userIdx = (Integer) session.getAttribute("userIdx");
	    String userType = (String) session.getAttribute("userType");
	    if (userIdx == null || userType.equals("USER")) {
	        model.addAttribute("msg", "접근할 수 없습니다.");
	        return "forward:/main.do"; // 로그인 페이지로 리디렉션
	    }
	    
	    // 회의실 목록 조회
	    List<RoomVO> roomList = roomService.selectRoomList(new RoomVO());
        model.addAttribute("roomList", roomList);
	    
		// 시설 목록 조회
		List<FacilityVO> facilityList = roomService.selectAllFacilities();
        model.addAttribute("facilityList", facilityList);
        
		return "/roomManagement";
	}
	
	@PostMapping("/addRoom.do")
    public String addRoom(
        @RequestParam("name") String name,
        @RequestParam("capacity") int capacity,
        @RequestParam("floor") int floor,
        @RequestParam("number") String number,
        @RequestParam(value = "facilities", required = false) List<String> facilities,
        @RequestParam("status") String status,
        @RequestParam("description") String description,
        HttpSession session,
        Model model) throws Exception {

        // 1. 관리자 권한 확인
        Integer userIdx = (Integer) session.getAttribute("userIdx");
        String userType = (String) session.getAttribute("userType");
        if (userIdx == null || !userType.equals("ADMIN")) {
            model.addAttribute("msg", "관리자 권한이 없습니다.");
            return "forward:/main.do";
        }
        
        // 2. RoomVO 객체 생성 및 폼 데이터 설정
        RoomVO roomVO = new RoomVO();
        roomVO.setName(name);
        roomVO.setCapacity(capacity);
        roomVO.setFloor(floor);
        roomVO.setNumber(number);
        roomVO.setStatus(status);
        roomVO.setDescription(description);

        // 3. 폼에서 넘어온 String 리스트를 FacilityVO 리스트로 변환
        //    (MyBatis의 foreach를 사용하기 위함)
        List<FacilityVO> facilityList = new ArrayList<>();
        if (facilities != null) {
            for (String facilityIdxStr : facilities) {
                FacilityVO facility = new FacilityVO();
                facility.setFacilityIdx(Integer.parseInt(facilityIdxStr));
                facilityList.add(facility);
            }
        }
        roomVO.setFacilities(facilityList); // RoomVO의 facilities 필드에 설정
        
        // 4. 서비스 호출하여 회의실 정보 등록
        String roomIdx = roomService.insertRoom(roomVO);
        
        model.addAttribute("msg", "회의실 추가 했습니다.");
        
        // 5. 처리 후 페이지 리다이렉션
        return "forward:/roomManagement.do";
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
