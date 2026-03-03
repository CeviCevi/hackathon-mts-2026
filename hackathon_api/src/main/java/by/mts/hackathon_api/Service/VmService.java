package by.mts.hackathon_api.Service;

import org.springframework.stereotype.Service;

import by.mts.hackathon_api.DTO.VmDTO;
import by.mts.hackathon_api.Models.VmModel;
import by.mts.hackathon_api.Repository.VmRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class VmService {
    
    private final VmRepository vmRepository;
    
    public VmModel register(VmDTO request) {  // ✅ Добавлено имя параметра
        
        
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
        
        return vmRepository.save(vm);
    }
    @Transactional  // <-- Добавьте эту аннотацию
    public boolean deleteByName(String name) {
        if (!vmRepository.existsByName(name)) {
            return false;
        }
        vmRepository.deleteByName(name);
        return true;
    }

    @Transactional  // <-- И сюда тоже
    public boolean deleteById(Long id) {
        if (!vmRepository.existsById(id)) {
            return false;
        }
        vmRepository.deleteById(id);
        return true;
    }

}