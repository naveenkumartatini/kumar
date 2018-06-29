package com.login.dao;

import com.login.domain.Login;

public interface LoginDAO {
	public Login getLoginDetailsById(String username);
}
