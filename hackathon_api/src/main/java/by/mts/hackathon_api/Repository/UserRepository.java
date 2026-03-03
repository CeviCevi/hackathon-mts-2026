package by.mts.hackathon_api.Repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import by.mts.hackathon_api.Models.UserModel;

public interface UserRepository extends JpaRepository<UserModel, Long> {
List<UserModel> findAllByOrderById();      
    Optional<UserModel> findByLogin(String login);

    boolean existsByLogin(String login);
    void deleteByLogin(String login);

}
