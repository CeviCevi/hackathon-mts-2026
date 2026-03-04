package by.mts.hackathon_api.Service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import by.mts.hackathon_api.Models.CharacteristicVmModel;
import by.mts.hackathon_api.Models.VmModel;
import by.mts.hackathon_api.Repository.CharacteristicVmRepository;
import by.mts.hackathon_api.Repository.VmRepository;

@Service
@RequiredArgsConstructor
public class VmService {

    private final VmRepository vmRepository;
    private final CharacteristicVmRepository characteristicVmRepository;

    private final RestTemplate restTemplate = new RestTemplate();
    private final String externalServerUrl = "http://192.168.43.8/";

    // ================= REGISTER =================

    @Transactional
    public VmModel register(VmModel request, Long idUser) {

        if (vmRepository.existsByName(request.getName())) {
            throw new RuntimeException("VM already exists");
        }

        VmModel vm = new VmModel();
        vm.setName(request.getName());
        vm.setOs(request.getOs());
        vm.setRam(request.getRam());
        vm.setRom(request.getRom());
        vm.setCors(request.getCors());
        vm.setStatus(request.getStatus());

        vmRepository.save(vm);

        CharacteristicVmModel cvm = new CharacteristicVmModel();
        cvm.setIdUser(idUser); // берем из PathVariable
        cvm.setIdVm(vm.getId());
        cvm.setRole(request.getRole());

        characteristicVmRepository.save(cvm);

        return vm;
    }

    // ================= UPDATE =================

    @Transactional
    public VmModel update(VmModel request) {

        if (request.getId() == null) {
            throw new RuntimeException("Id must not be null");
        }

        VmModel vm = vmRepository.findById(request.getId())
                .orElseThrow(() ->
                        new RuntimeException("VM not found with id: " + request.getId()));

        boolean statusChangedTo200 = false;

        if (request.getName() != null) vm.setName(request.getName());
        if (request.getOs() != null) vm.setOs(request.getOs());
        if (request.getRam() != null) vm.setRam(request.getRam());
        if (request.getRom() != null) vm.setRom(request.getRom());
        if (request.getCors() != null) vm.setCors(request.getCors());

        if (request.getStatus() != null) {
            if (vm.getStatus() != 200 && request.getStatus() == 200) {
                statusChangedTo200 = true;
            }
            vm.setStatus(request.getStatus());
        }

        VmModel updatedVm = vmRepository.save(vm);

        if (statusChangedTo200) {
            try {
                String fullUrl = externalServerUrl + vm.getName();
                restTemplate.getForEntity(fullUrl, String.class);
            } catch (Exception e) {
                System.err.println("Failed to notify external server: " + e.getMessage());
            }
        }

        return updatedVm;
    }

    // ================= DELETE =================

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

    // ================= EXTERNAL ACTIONS =================

    @Transactional
    public void on(Long vmId) {
        callExternal(vmId);
    }

    @Transactional
    public void off(Long vmId) {
        callExternal(vmId);
    }

    @Transactional
    public void deleteExternal(Long vmId) {
        callExternal(vmId);
    }

    private void callExternal(Long vmId) {

        if (!vmRepository.existsById(vmId)) {
            throw new RuntimeException("VM not found with id: " + vmId);
        }

        try {
            String fullUrl = externalServerUrl + vmId;
            restTemplate.getForEntity(fullUrl, String.class);
        } catch (Exception e) {
            System.err.println("Failed to notify external server: " + e.getMessage());
        }
    }
}