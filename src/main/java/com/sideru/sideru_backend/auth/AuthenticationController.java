package com.sideru.sideru_backend.auth;

import com.sideru.sideru_backend.auth.dto.AuthenticationRequest;
import com.sideru.sideru_backend.auth.dto.AuthenticationResponse;
import com.sideru.sideru_backend.auth.dto.RegisterRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthenticationController {
    private final AuthenticationService authService;

    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    public AuthenticationResponse register(
            @RequestBody RegisterRequest registerRequest
    ) {
        return authService.register(registerRequest);
    }

    @PostMapping("/login")
    @ResponseStatus(HttpStatus.CREATED)
    public AuthenticationResponse authenticate(
            @RequestBody AuthenticationRequest authRequest
    ) {
        return authService.authenticate(authRequest);
    }
}
