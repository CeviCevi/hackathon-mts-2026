package by.mts.hacaton.Service;

import java.io.IOException;

import org.springframework.stereotype.Service;

import by.mts.hacaton.Something;


@Service
public class HostService {

    // Метод для создания виртуальной машины
    public void createVM(Something entity) {
        try {
            String command = String.format("bash /home/user/create.sh %s %d %d %d %s",
                    entity.getName(), entity.getCors(), entity.getRam(), entity.getRom(), entity.getPassword());
            executeBashScript(command);
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            throw new RuntimeException("Error while creating VM", e);
        }
    }

    // Метод для включения виртуальной машины
    public boolean startVM(String vmName) {
        try {
            String command = String.format("bash /home/user/start.sh %s", vmName);

            executeBashScript(command);
            System.out.println(command);
            return true;
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Метод для выключения виртуальной машины
    public boolean stopVM(String vmName) {
        try {
            String command = String.format("bash /home/user/stop.sh %s", vmName);
            executeBashScript(command);
            return true;
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Метод для перезагрузки виртуальной машины
    public boolean rebootVM(String vmName) {
        try {
            String command = String.format("bash /path/to/reboot_vm.sh %s", vmName);
            executeBashScript(command);
            return true;
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Метод для удаления виртуальной машины
    public boolean deleteVM(String vmName) {
        try {
            String command = String.format("bash /path/to/delete_vm.sh %s", vmName);
            executeBashScript(command);
            return true;
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Метод для выполнения bash-скриптов
    private void executeBashScript(String command) throws IOException, InterruptedException {
        Process process = Runtime.getRuntime().exec(command);
        int exitCode = process.waitFor();
        if (exitCode != 0) {
            throw new RuntimeException("Bash script execution failed with exit code " + exitCode);
        }
    }
}