package egovframework.room.web;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.room.service.DepartmentService;
import egovframework.room.service.DepartmentVO;
import egovframework.room.service.FacilityVO;
import egovframework.room.service.ReservationService;
import egovframework.room.service.ReservationVO;
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
	
	@Autowired
	private ReservationService reservationService;

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
	public String main(ModelMap model, HttpSession session) throws Exception {    
		// 오늘 날짜 설정
		// 오늘 날짜를 문자열로 생성 (YYYY-MM-DD)
	    LocalDate today = LocalDate.now();
	    String now = today.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		model.addAttribute("today", now);
		
	    Integer userIdx = (Integer) session.getAttribute("userIdx");
		
	    // DB에서 회의실 개수 불러오기
		int roomCount = roomService.selectRoomListTotCnt(new RoomVO());
		model.addAttribute("roomCount", roomCount);
		 
		// 1. 해당 날짜의 전체 예약 건수 조회
	    int totalReservations = reservationService.countTotalReservationsByDate(now);
	    model.addAttribute("totalReservations", totalReservations);
	    
	    // 2. 해당 날짜의 내 예약 건수 조회 (로그인 상태일 경우에만)
	    int myReservations = 0;
	    if (userIdx != null) {
	    	Map<String, Object> param = new HashMap<>();
	    	param.put("userIdx", userIdx);
	    	param.put("date", now);
	        myReservations = reservationService.countMyReservationsByDate(param);
	    } else {
	        myReservations = 0; // 이 경우 로직은 문제없음
	    }
	    model.addAttribute("myReservations", myReservations);
		
		// DB에서 예약 목록 불러오기
		List<ReservationVO> reservationList = reservationService.selectReservationList(new ReservationVO());
        model.addAttribute("reservationList", reservationList);
        
        // DB에서 회의실 목록 불러오기
        List<RoomVO> roomList = roomService.selectRoomList(new RoomVO());
        model.addAttribute("roomList", roomList);
        
        // 오늘 날짜의 예약 목록 불러오기
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("date", now);
        List<ReservationVO> todayReservationList = reservationService.selectReservationListByDate(paramMap);
        model.addAttribute("todayReservationList", todayReservationList);
        
		return "/main";
	}
	
	@RequestMapping("/getStats.do")
	@ResponseBody
	public Map<String, Object> getStats(@RequestParam("date") String dateStr, HttpSession session) throws Exception {
		Map<String, Object> response = new HashMap<>();
		Integer userIdx = (Integer) session.getAttribute("userIdx");

	    // DB 조회
	    int totalReservations = reservationService.countTotalReservationsByDate(dateStr);

	    int myReservations = 0;
	    if (userIdx != null) {
	    	Map<String, Object> param = new HashMap<>();
	    	param.put("userIdx", userIdx);
	    	param.put("date", dateStr);
	        myReservations = reservationService.countMyReservationsByDate(param);
	    }

	    response.put("totalReservations", totalReservations);
	    response.put("myReservations", myReservations);

	    return response;
	}
	
	// /getReservationsByDate.do
	@RequestMapping("/getReservationsByDate.do")
	@ResponseBody
	public List<ReservationVO> getReservationsByDate(@RequestParam("date") String dateStr) throws Exception {
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("date", dateStr);
	    List<ReservationVO> reservationList = reservationService.selectReservationListByDate(paramMap);
	    return reservationList;
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
			request.getSession().setAttribute("department", resultVO.getDepartmentName());
			return "redirect:/main.do";
		} else {
			request.getSession().setAttribute("id", "");
			request.getSession().setAttribute("name", "");
			request.getSession().setAttribute("userType", "");
			request.getSession().setAttribute("userIdx", "");
			request.getSession().setAttribute("department", "");
			model.addAttribute("message", "사용자 정보가 올바르지 않습니다.");
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
	public String registerProcess(@ModelAttribute UserVO userVO, RedirectAttributes redirectAttributes, ModelMap model) throws Exception {
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
			
			// 성공 메시지를 flashAttribute에 담아 리다이렉션
			model.addAttribute("msg", "회원가입이 완료되었습니다.");
	        redirectAttributes.addFlashAttribute("message", "회원가입이 완료되었습니다.");
	        redirectAttributes.addFlashAttribute("messageType", "success");

	        return "forward:/login.do";

	    } catch (Exception e) {
	        System.out.println("회원가입 오류: " + e.getMessage());
	        redirectAttributes.addFlashAttribute("message", "회원가입 중 오류가 발생했습니다: " + e.getMessage());
	        redirectAttributes.addFlashAttribute("messageType", "error");
	        return "redirect:/register.do"; // 리다이렉트 방식으로 변경
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
	        model.addAttribute("userDetails", userDetails);
	        
	        // 3. 부서 목록 전체 조회
	        List<DepartmentVO> deptList = departmentMapper.selectDepartmentList(new DepartmentVO());
			model.addAttribute("deptList", deptList);
			
			// 4. DB에서 내 예약 목록 불러오기
			ReservationVO resVO = new ReservationVO();
	        resVO.setUserIdx(userIdx);  // 로그인 유저 아이디 설정
	        List<ReservationVO> reservationList = reservationService.selectMyReservationList(resVO);
	        model.addAttribute("reservationList", reservationList);
	        
	        // 5. DB에서 회의실 목록 불러오기
	        List<RoomVO> roomList = roomService.selectRoomList(new RoomVO());
	        model.addAttribute("roomList", roomList);
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
	
	@PostMapping("/deleteRoom.do")
    @ResponseBody // 이 어노테이션은 메서드의 반환 값을 HTTP 응답 본문에 직접 담아 보냅니다.
    public String deleteRoom(@RequestParam("roomIdx") int roomIdx) {
        try {
            RoomVO roomVO = new RoomVO();
            roomVO.setRoomIdx(roomIdx);
            roomService.deleteRoom(roomVO);
            return "success"; // 삭제 성공 시 "success" 문자열 반환
        } catch (Exception e) {
            // 예외 발생 시 로그를 남기는 것이 좋습니다.
            e.printStackTrace();
            return "fail"; // 삭제 실패 시 "fail" 문자열 반환
        }
    }
	
	@RequestMapping(value = "/selectRoom.do", 
            method = {RequestMethod.GET, RequestMethod.POST},
            produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> selectRoom(@RequestParam("roomIdx") int roomIdx, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		
		System.out.println("=== selectRoom 요청 받음 ===");
		System.out.println("roomIdx: " + roomIdx);
		
		// 세션 정보 확인
		Integer userIdx = (Integer) session.getAttribute("userIdx");
		String userType = (String) session.getAttribute("userType");
		
		System.out.println("userIdx: " + userIdx);
		System.out.println("userType: " + userType);
		
		// 관리자 권한 확인
		if (userIdx == null || !userType.equals("ADMIN")) {
		    System.out.println("권한 체크 실패");
		    response.put("result", "error");
		    response.put("msg", "접근 권한이 없습니다.");
		    return response;
		}
		
		RoomVO roomVO = new RoomVO();
		roomVO.setRoomIdx(roomIdx);
		
		try {
		    System.out.println("DB 조회 시작");
		    RoomVO roomData = roomService.selectRoom(roomVO);
		    System.out.println("DB 조회 완료: " + roomData.toString());
		    
		    // JSON 직렬화를 위해 Map으로 변환
		    Map<String, Object> roomMap = new HashMap<>();
		    roomMap.put("roomIdx", roomData.getRoomIdx());
		    roomMap.put("name", roomData.getName());
		    roomMap.put("capacity", roomData.getCapacity());
		    roomMap.put("floor", roomData.getFloor());
		    roomMap.put("number", roomData.getNumber());
		    roomMap.put("status", roomData.getStatus());
		    roomMap.put("description", roomData.getDescription());
		    
		    // 시설 목록도 Map 리스트로 변환
		    List<Map<String, Object>> facilityMapList = new ArrayList<>();
		    if (roomData.getFacilities() != null) {
		        for (FacilityVO facility : roomData.getFacilities()) {
		            Map<String, Object> facilityMap = new HashMap<>();
		            facilityMap.put("facilityIdx", facility.getFacilityIdx());
		            facilityMap.put("name", facility.getName());
		            facilityMapList.add(facilityMap);
		        }
		    }
		    roomMap.put("facilities", facilityMapList);
		    
		    response.put("result", "success");
		    response.put("data", roomMap); // Map으로 변환된 데이터 사용
		    
		    System.out.println("응답 데이터 준비 완료");
		    
		} catch (Exception e) {
		    System.out.println("DB 조회 중 예외 발생: " + e.getMessage());
		    e.printStackTrace();
		    
		    response.put("result", "error");
		    response.put("msg", "데이터 조회 중 오류가 발생했습니다: " + e.getMessage());
		}
		
		System.out.println("=== selectRoom 응답 반환 ===");
		return response;
	}
	
	@PostMapping("/updateRoom.do")
    public String updateRoom(
		@RequestParam("roomIdx") int roomIdx,
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
        roomVO.setRoomIdx(roomIdx);
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
        roomService.updateRoom(roomVO);
        
        model.addAttribute("msg", "회의실 정보를 수정했습니다.");
        
        // 5. 처리 후 페이지 리다이렉션
        return "forward:/roomManagement.do";
    }
	
	@RequestMapping(value = "/reservation.do")
	public String booking(ModelMap model, HttpSession session) throws Exception {
		// user 정보 가져오기
        Integer userIdx = (Integer) session.getAttribute("userIdx");
        String userType = (String) session.getAttribute("userType");
        String name = (String) session.getAttribute("name");
        String department = (String) session.getAttribute("department");
        
        model.addAttribute("userIdx", userIdx);
        model.addAttribute("userType", userType);
        model.addAttribute("name", name);
        model.addAttribute("department", department);
        
	    // 회의실 목록 조회
	    List<RoomVO> roomList = roomService.selectRoomList(new RoomVO());
        model.addAttribute("roomList", roomList);
	    
        
		return "/reservation";
	}
	
	@PostMapping("/addReservation.do")
	public String addReservation(
	    @RequestParam("title") String title,
	    @RequestParam("roomIdx") int roomIdx,
	    @RequestParam("attendees") int attendees,
	    @RequestParam("date") String dateStr,
	    @RequestParam("startTime") String startTimeStr,
	    @RequestParam("endTime") String endTimeStr,
	    @RequestParam(value = "content", required = false) String content,
	    HttpSession session, Model model) throws Exception {

	    // 1. 사용자 정보 확인
	    Integer userIdx = (Integer) session.getAttribute("userIdx");
	    if (userIdx == null) {
	        model.addAttribute("msg", "로그인 상태가 아닙니다.");
	        return "forward:/login.do";
	    }

	    // 2. 날짜와 시간을 합쳐서 Date 객체로 변환
	    String startDateTimeCombined = dateStr + " " + startTimeStr + ":00";
	    String endDateTimeCombined = dateStr + " " + endTimeStr + ":00";
	    
	    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    Date startDatetime = formatter.parse(startDateTimeCombined);
	    Date endDatetime = formatter.parse(endDateTimeCombined);
	    
	    // 3. ReservationVO 객체 생성 및 값 설정
	    ReservationVO reservationVO = new ReservationVO();
	    reservationVO.setUserIdx(userIdx);
	    reservationVO.setTitle(title);
	    reservationVO.setRoomIdx(roomIdx);
	    reservationVO.setAttendees(attendees);
	    reservationVO.setStartDatetime(startDatetime);
	    reservationVO.setEndDatetime(endDatetime);
	    reservationVO.setContent(content);

	    // 4. 중복 예약 확인
	    int overlapCount = reservationService.countOverlappingReservations(reservationVO);
	    
	    if (overlapCount > 0) {
	        // 중복 예약이 존재할 경우
	        model.addAttribute("msg", "이미 다른 예약이 있습니다.");
	        // 실패 메시지를 reservation.jsp에 표시하기 위해 forward
	        // 필요한 데이터를 다시 모델에 담아 전달
//	        model.addAttribute("roomList", roomService.selectRoomList(new RoomVO()));
//	        model.addAttribute("name", session.getAttribute("name"));
//	        model.addAttribute("department", session.getAttribute("department"));
	        return "forward:/reservation.do";
	    } else {
	        // 중복 예약이 없을 경우, 정상적으로 예약 진행
	        reservationService.insertSingleReservation(reservationVO);
	        model.addAttribute("msg", "회의실 예약이 완료되었습니다.");
	        return "forward:/main.do";
	    }
	}
	
	@PostMapping("/deleteReservation.do")
    @ResponseBody // 이 어노테이션은 메서드의 반환 값을 HTTP 응답 본문에 직접 담아 보냅니다.
    public String deleteReservation(@RequestParam("reservationIdx") int reservationIdx) {
        try {
            ReservationVO reservationVO = new ReservationVO();
            reservationVO.setReservationIdx(reservationIdx);
            reservationService.deleteReservation(reservationVO);
            return "success"; // 삭제 성공 시 "success" 문자열 반환
        } catch (Exception e) {
            // 예외 발생 시 로그를 남기는 것이 좋습니다.
            e.printStackTrace();
            return "fail"; // 삭제 실패 시 "fail" 문자열 반환
        }
    }
	
	@RequestMapping(value = "/selectReservation.do", 
            method = {RequestMethod.GET, RequestMethod.POST},
            produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> selectReservation(@RequestParam("reservationIdx") int reservationIdx, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		
		try {
	        // 권한 체크 (예약자 본인만 접근 허용)
	        Integer userIdx = (Integer) session.getAttribute("userIdx");
	        if (userIdx == null) {
	            response.put("result", "error");
	            response.put("msg", "로그인 상태가 아닙니다.");
	            return response;
	        }

	        ReservationVO resVO = new ReservationVO();
	        resVO.setReservationIdx(reservationIdx);
	        
	        ReservationVO reservationData = reservationService.selectReservation(resVO); // 단일 예약 조회 서비스
	        
	        // 예약자와 세션의 userIdx가 일치하는지 확인
	        if (reservationData.getUserIdx() != userIdx) {
	            response.put("result", "error");
	            response.put("msg", "수정 권한이 없습니다.");
	            return response;
	        }

	        response.put("result", "success");
	        response.put("data", reservationData);
	    } catch (Exception e) {
	        response.put("result", "error");
	        response.put("msg", "데이터 조회 중 오류 발생: " + e.getMessage());
	    }
	    return response;
	}
	
	// 예약 정보 수정
	@PostMapping("/updateReservation.do")
	public String updateReservation(@ModelAttribute ReservationVO reservationVO,
	                                 @RequestParam("date") String dateStr,
	                                 @RequestParam("startTime") String startTimeStr,
	                                 @RequestParam("endTime") String endTimeStr,
	                                 HttpSession session, Model model) throws Exception {
	    
	    Integer userIdx = (Integer) session.getAttribute("userIdx");
	    if (userIdx == null) {
	        model.addAttribute("msg", "로그인 상태가 아닙니다.");
	        return "forward:/login.do";
	    }

	    // 날짜와 시간 합치기
	    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    Date startDatetime = formatter.parse(dateStr + " " + startTimeStr + ":00");
	    Date endDatetime = formatter.parse(dateStr + " " + endTimeStr + ":00");
	    
	    reservationVO.setStartDatetime(startDatetime);
	    reservationVO.setEndDatetime(endDatetime);
	    
	    // 예약자 정보 설정 (보안)
	    reservationVO.setUserIdx(userIdx);

	    // 중복 예약 확인 로직 추가 (addReservation.do와 동일)
	    int overlapCount = reservationService.countOverlappingReservations(reservationVO);
	    
	    if (overlapCount > 0) {
	        model.addAttribute("msg", "이미 다른 예약이 있습니다.");
	        // 실패 시 필요한 데이터를 다시 모델에 담아 전달
	        return "forward:/myPage.do";
	    } else {
	        reservationService.updateReservation(reservationVO);
	        model.addAttribute("msg", "예약이 성공적으로 수정되었습니다.");
	        return "forward:/myPage.do";
	    }
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
