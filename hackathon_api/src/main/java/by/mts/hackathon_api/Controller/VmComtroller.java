package by.mts.hackathon_api.Controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import by.mts.hackathon_api.DTO.VmDTO;
import by.mts.hackathon_api.Models.VmModel;
import by.mts.hackathon_api.Repository.VmRepository;
import by.mts.hackathon_api.Service.VmService;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PutMapping;


@Data
@RestController
@RequestMapping("/api/vm")
@RequiredArgsConstructor
public class VmComtroller {


    private final VmRepository vmRepository;

    private final VmService vmService;

    @PostMapping("/register")
    public VmModel register(@RequestBody VmDTO request) { 
        return vmService.register(request);
    }
    
    @DeleteMapping("/deleteByName/{name}")
    public ResponseEntity<?> deleteByName(@PathVariable String name) {

        boolean deleted = vmService.deleteByName(name);

        if (!deleted) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok().build();
    }

   @PutMapping("/update")
public ResponseEntity<VmModel> update(@RequestBody VmDTO request) {
    VmModel updated = vmService.update(request);
    return ResponseEntity.ok(updated);
}

    
    @DeleteMapping("/deleteById/{id}")
    public ResponseEntity<?> deleteUserById(@PathVariable Long id) {

        boolean deleted = vmService.deleteById(id);

        if (!deleted) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok().build();
    }
}
