package egovframework.room.reservation.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class RoomController {
	
	@RequestMapping(value= "/main.do")
	public String main(ModelMap model) throws Exception {
		return "/reservation/main";
	}
	
	@RequestMapping(value= "/login.do")
	public String login(ModelMap model) throws Exception {
		return "/reservation/login";
	}
	
	@RequestMapping(value= "/register.do")
	public String register(ModelMap model) throws Exception {
		return "/reservation/register";
	}
	
	@RequestMapping(value= "/myPage.do")
	public String myPage(ModelMap model) throws Exception {
		return "/reservation/myPage";
	}
	
	@RequestMapping(value= "/booking.do")
	public String booking(ModelMap model) throws Exception {
		return "/reservation/booking";
	}
	
	@RequestMapping(value= "/roomManagement.do")
	public String roomManagement(ModelMap model) throws Exception {
		return "/reservation/roomManagement";
	}
}
