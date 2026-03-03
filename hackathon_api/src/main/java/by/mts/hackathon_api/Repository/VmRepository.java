package by.mts.hackathon_api.Repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import by.mts.hackathon_api.Models.VmModel;

public interface VmRepository extends JpaRepository<VmModel, Long> {

    List<VmModel> findAllByOrderById();      
    Optional<VmModel> findByName(String name);

    boolean existsByName(String name);
    void deleteByName(String name);

    boolean existsById(Long id);
    void deleteById(Long id);
}
