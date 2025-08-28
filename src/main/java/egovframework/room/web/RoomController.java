package egovframework.room.web;

import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.room.service.DepartmentService;

@Controller
public class RoomController {
	
	@Autowired
	private DataSource dataSource;
	
	private DepartmentService departmentService;
	
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
	
	@RequestMapping(value= "/test.do")
	@ResponseBody
	public String test(ModelMap model) throws Exception {
		System.out.println("테스트중");
		try {
            Connection conn = dataSource.getConnection();
            String dbName = conn.getCatalog();
            String dbVersion = conn.getMetaData().getDatabaseProductVersion();
            conn.close();
            
            // System.out.println("연결 성공");
            
            return "DB 연결 성공!<br>" +
                   "데이터베이스: " + dbName + "<br>" +
                   "MySQL 버전: " + dbVersion;
        } catch (SQLException e) {
        	// System.out.println("연결 실패");
            return "DB 연결 실패: " + e.getMessage();
        }
	}
}
