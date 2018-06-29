package com.login.dao;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.login.domain.Login;

@Repository
public class LoginDAOImpl implements LoginDAO {

	private SessionFactory sessionFactory;
	
	@Autowired
	public void setSessionFactory(SessionFactory sf){
		this.sessionFactory = sf;
	}


	@Override
	@Transactional
	public Login getLoginDetailsById(String username) {
			System.out.println("inside dao layer");
			Session session = this.sessionFactory.getCurrentSession();	
			Login login = (Login) session.get(Login.class, new String(username));  //using hibernate get method
			System.out.println("person name="+login.getPersonName());
			return login;
			/*Login login1=new Login();
			Login login = (Login) session.load(Login.class, new String(username)); //using hibernate load method
			System.out.println("person name="+login.getPersonName());
			login1.setUsername(login.getUsername());
			login1.setPassword(login.getPassword());
			login1.setPersonName(login.getPersonName());
			System.out.println("person name="+login1.getPersonName());
			return login1;*/          
		}         

		
	

}
