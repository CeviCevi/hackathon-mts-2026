package by.mts.hackathon_api.Controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import by.mts.hackathon_api.Models.CharacteristicVmModel;
import by.mts.hackathon_api.Repository.CharacteristicVmRepository;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RestController
@RequestMapping("/api/cvm")
@RequiredArgsConstructor
public class CharacteristicVm {
     private final CharacteristicVmRepository characteristicVmRepository;
 @GetMapping("/getAll")
    public List<CharacteristicVmModel> findAllByOrderById() {
        return characteristicVmRepository.findAllByOrderById();
    }
 @GetMapping("/findByIdUser/{idUser}")
    public  List<CharacteristicVmModel> findByIdUser(@PathVariable Long idUser) {
        return characteristicVmRepository.findByIdUser(idUser);
    }
 @GetMapping("/findByIdVm/{idVm}")
    public List<CharacteristicVmModel> findByIdVm(@PathVariable Long idVm) {
        return characteristicVmRepository.findByIdVm(idVm);
    }
 @GetMapping("/findByIdVmAndIdUser/{idUser}/{idVm}")
    public List<CharacteristicVmModel> findByIdVmAndIdUser(@PathVariable Long idVm,@PathVariable Long idUser) {
        return characteristicVmRepository.findByIdVmAndIdUser(idVm,idUser);
    }





}
