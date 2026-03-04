package by.mts.hackathon_api.Service;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import by.mts.hackathon_api.DTO.VmDTO;
import by.mts.hackathon_api.Models.CharacteristicVmModel;
import by.mts.hackathon_api.Models.VmModel;
import by.mts.hackathon_api.Repository.CharacteristicVmRepository;
import by.mts.hackathon_api.Repository.VmRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class VmService {
    
    private final VmRepository vmRepository;
    private final CharacteristicVmRepository characteristicVmRepository;
    private final RestTemplate restTemplate = new RestTemplate();
    private final String externalServerUrl = "https://hghghgh";
    public VmModel register(VmDTO request) { 
    
        if (vmRepository.existsByName(request.getName())) {
            throw new RuntimeException("VM already exists");
        }

        VmModel vm = new VmModel();
        vm.setName(request.getName());
        vm.setOs(request.getOs());
        vm.setRam(request.getRam());
        vm.setRom(request.getRom());
        vm.setFrequency(request.getFrequency());
        vm.setStatus(request.getStatus()); 
        vmRepository.save(vm);

        CharacteristicVmModel cvm = new CharacteristicVmModel();
        cvm.setIdUser(request.getIdUser());
        cvm.setIdVm(vm.getId());
        cvm.setRole(request.getRole());
        characteristicVmRepository.save(cvm);  // ← добавлена ;
    
        return vm;  // ← возвращаем уже сохранённый объект, без повторного save
    }





    @Transactional  
    public boolean deleteByName(String name) {
        if (!vmRepository.existsByName(name)) {
            return false;
        }
        vmRepository.deleteByName(name);
        return true;
    }

    @Transactional  
    public boolean deleteById(Long id) {
        if (!vmRepository.existsById(id)) {
            return false;
        }
        vmRepository.deleteById(id);
        return true;
    }

      @Transactional
        public VmModel updateStatus(VmDTO request) {
        // Находим VM по ID
        VmModel vm = vmRepository.findById(request.getId)
            .orElseThrow(() -> new RuntimeException("VM not found with id: " + vmId));
        
        // Обновляем статус
        vm.setStatus(newStatus);
        VmModel updatedVm = vmRepository.save(vm);
        
        // Выполняем GET-запрос на другой сервер
        try {
            //переписать путь получения ssh
            String fullUrl = externalServerUrl + "?vmId=" + vmId;
            ResponseEntity<String> response = restTemplate.getForEntity(fullUrl, String.class);
            
           
            System.out.println("External server response: " + response.getStatusCode());
            
        } catch (Exception e) {
            
            System.err.println("Failed to notify external server: " + e.getMessage());
           
        }
        
        return updatedVm;
    }

}