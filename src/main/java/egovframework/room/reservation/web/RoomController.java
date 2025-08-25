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
}
