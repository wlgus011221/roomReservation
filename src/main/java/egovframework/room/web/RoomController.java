package egovframework.room.web;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.room.service.DepartmentDefaultVO;
import egovframework.room.service.DepartmentService;
import egovframework.room.service.DepartmentVO;
import egovframework.room.service.impl.DepartmentMapper;

@Controller
public class RoomController {
	
	@Autowired
	private DataSource dataSource;
	
	@Autowired
	private DepartmentService departmentService;
	
	@Autowired
	private DepartmentMapper departmentMapper;
	
	@RequestMapping(value= "/main.do")
	public String main(ModelMap model) throws Exception {
		return "/main";
	}
	
	@RequestMapping(value= "/login.do")
	public String login(ModelMap model) throws Exception {
		return "/login";
	}
	
	@RequestMapping(value= "/register.do")
	public String register(ModelMap model) throws Exception {
		return "/register";
	}
	
	@RequestMapping(value= "/myPage.do")
	public String myPage(ModelMap model) throws Exception {
		return "/myPage";
	}
	
	@RequestMapping(value= "/booking.do")
	public String booking(ModelMap model) throws Exception {
		return "/booking";
	}
	
	@RequestMapping(value= "/roomManagement.do")
	public String roomManagement(ModelMap model) throws Exception {
		return "/roomManagement";
	}
	
	@RequestMapping(value= "/test.do", produces = "text/html; charset=UTF-8")
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
