package by.mts.hackathon_api.DTO;

import lombok.Data;

@Data
public class VmDTO {
    
    private String name;  

    private Long ssh_id;

    private double ram;

    private double rom;  

    private double frequency;

    private String os;

    private int status;

}
