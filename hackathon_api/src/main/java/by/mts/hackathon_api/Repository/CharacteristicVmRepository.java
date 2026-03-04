package by.mts.hackathon_api.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import by.mts.hackathon_api.Models.CharacteristicVmModel;


public interface CharacteristicVmRepository extends JpaRepository<CharacteristicVmModel, Long> {

    List<CharacteristicVmModel> findAllByOrderById();   
    List<CharacteristicVmModel> findByIdUser(Long idUser);
    List<CharacteristicVmModel> findByIdVm(Long idVm);
    List<CharacteristicVmModel> findByIdVmAndIdUser(Long idVm, Long idUser);
    void deleteById(Long id);
}

