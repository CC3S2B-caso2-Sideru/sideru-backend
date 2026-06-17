package com.sideru.sideru_backend;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@SpringBootApplication
public class SideruBackendApplication {

	private static final PasswordEncoder passwordEncoder =  new BCryptPasswordEncoder();
	public static void main(String[] args) {
		SpringApplication.run(SideruBackendApplication.class, args);
	}

}
