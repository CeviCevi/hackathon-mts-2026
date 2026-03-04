package by.mts.hackathon_api.Controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import by.mts.hackathon_api.Models.VmModel;
import by.mts.hackathon_api.Service.VmService;

@RestController
@RequestMapping("/api/vm")
@RequiredArgsConstructor
public class VmController {

    private final VmService vmService;

    @PostMapping("/register/{idUser}")
    public VmModel register(@RequestBody VmModel request,
                            @PathVariable Long idUser) {
        return vmService.register(request, idUser);
    }

    @PutMapping("/update")
    public VmModel update(@RequestBody VmModel request) {
        return vmService.update(request);
    }

    @PutMapping("/on/{id}")
    public ResponseEntity<?> on(@PathVariable Long id) {
        vmService.on(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/off/{id}")
    public ResponseEntity<?> off(@PathVariable Long id) {
        vmService.off(id);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/external/{id}")
    public ResponseEntity<?> deleteExternal(@PathVariable Long id) {
        vmService.deleteExternal(id);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/deleteByName/{name}")
    public ResponseEntity<?> deleteByName(@PathVariable String name) {
        boolean deleted = vmService.deleteByName(name);

        if (!deleted) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/deleteById/{id}")
    public ResponseEntity<?> deleteById(@PathVariable Long id) {
        boolean deleted = vmService.deleteById(id);

        if (!deleted) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok().build();
    }
}