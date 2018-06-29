package com.login.controller;

import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.login.domain.Login;
import com.login.service.LoginService;


@Controller
public class LoginController {
	
	
	private LoginService loginService;
	
	@Autowired
	public void setLoginService(LoginService loginService){
		this.loginService = loginService;
	}
       
	@RequestMapping(value="/verify", method=RequestMethod.POST)
    public @ResponseBody Login verifyCredentials(@RequestBody Login login) {
    	System.out.println("hello hello");
    	
    	Login login1=loginService.getLoginDetailsById(login.getUsername());
    	
    		if(login1!=null) {
    		if(login.getPassword().equals(login1.getPassword())) {
    			System.out.println("verified");
    			login1.setStatus(true);
    			return login1;
    		}
    		else {
    		login1.setStatus(false);
    		return login1;
    		}
    		
    	}
    	login.setStatus(false);
    	return login1;
	}
	@RequestMapping(value="/", method=RequestMethod.GET)
	public String loginForm(ModelMap map) {
		System.out.println("hello");
		return "Login";
	}
}