package by.mts.hackathon_api.Controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import by.mts.hackathon_api.DTO.UserDTO;
import by.mts.hackathon_api.Models.UserModel;
import by.mts.hackathon_api.Repository.UserRepository;
import by.mts.hackathon_api.Service.UserService;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    private final UserRepository userRepository;


    @PostMapping("/register")
    public UserModel register(@RequestBody UserDTO request) {
        return userService.register(
            request.getLogin(),
            request.getPassword()
        );
    }

    @PostMapping("/enter")
    public UserModel login(@RequestBody UserDTO request) {
        return userService.login(
            request.getLogin(),
            request.getPassword()
        );
    }

    @GetMapping("/read")
    public List<UserModel> findAllByOrderById(@RequestBody UserDTO request) {
        return userRepository.findAllByOrderById();
    }

    
     @DeleteMapping("/delete")
    public ResponseEntity<?> deleteUser(@RequestParam String login) {

        boolean deleted = userService.deleteUserByLogin(login);

        if (!deleted) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok().build();
    }
}