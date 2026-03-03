package by.mts.hackathon_api.Service;

import org.springframework.stereotype.Service;

import by.mts.hackathon_api.Models.UserModel;
import by.mts.hackathon_api.Repository.UserRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor

public class UserService {

    private final UserRepository userRepository;
    
    public UserModel register(String login, String password) {
        if (userRepository.existsByLogin(login)) {
            throw new RuntimeException("Login already exists");
        }

        UserModel user = new UserModel();
        user.setLogin(login);
        user.setPassword(password);
        return userRepository.save(user);
    }
      public UserModel login(String login, String password) {
        return userRepository.findByLogin(login)
            .filter(user -> user.getPassword().equals(password))
            .orElseThrow(() -> new RuntimeException("Invalid login or password"));
    }
    
    public boolean deleteUserByLogin(String login) {
        if (!userRepository.existsByLogin(login)) {
            return false;
        }

        
        userRepository.deleteByLogin(login);
        return true;
    }



}
