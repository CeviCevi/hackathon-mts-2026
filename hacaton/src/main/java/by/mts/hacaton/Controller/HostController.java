package by.mts.hacaton.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import by.mts.hacaton.Something; // Убедитесь, что этот импорт присутствует
import by.mts.hacaton.Service.HostService;

@RestController
@RequestMapping("/api/host")
public class HostController {

    @Autowired
    private HostService hostService;

    // Эндпоинт для создания виртуальной машины
    @PostMapping("/create")
    public ResponseEntity<?> create(@RequestBody Something entity) {
        if (!entity.isValid()) {
            return ResponseEntity.badRequest().body("Invalid input data");
        }
        hostService.createVM(entity);
        return ResponseEntity.ok("VM created successfully");
    }

    // Эндпоинт для включения виртуальной машины
    @PostMapping("/start/{vmName}")
    public ResponseEntity<?> start(@PathVariable String vmName) {
        if (hostService.startVM(vmName)) {
            return ResponseEntity.ok("VM started successfully");
        }
        return ResponseEntity.status(500).body("Failed to start VM");
    }

    // Эндпоинт для выключения виртуальной машины
    @PostMapping("/stop/{vmName}")
    public ResponseEntity<?> stop(@PathVariable String vmName) {
        if (hostService.stopVM(vmName)) {
            return ResponseEntity.ok("VM stopped successfully");
        }
        return ResponseEntity.status(500).body("Failed to stop VM");
    }

    // Эндпоинт для перезагрузки виртуальной машины
    @PostMapping("/reboot/{vmName}")
    public ResponseEntity<?> reboot(@PathVariable String vmName) {
        if (hostService.rebootVM(vmName)) {
            return ResponseEntity.ok("VM rebooted successfully");
        }
        return ResponseEntity.status(500).body("Failed to reboot VM");
    }

    // Эндпоинт для удаления виртуальной машины
    @DeleteMapping("/delete/{vmName}")
    public ResponseEntity<?> delete(@PathVariable String vmName) {
        if (hostService.deleteVM(vmName)) {
            return ResponseEntity.ok("VM deleted successfully");
        }
        return ResponseEntity.status(500).body("Failed to delete VM");
    }
}