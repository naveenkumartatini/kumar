package com.login.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.login.dao.LoginDAO;
import com.login.domain.Login;

@Service
public class LoginServiceImpl implements LoginService {
	private LoginDAO loginDAO;

	@Autowired
	public void setLoginDAO(LoginDAO loginDAO) {
		this.loginDAO = loginDAO;
	}

	@Override
	@Transactional
	public Login getLoginDetailsById(String username) {
		
		return loginDAO.getLoginDetailsById(username);
		
	}

}
