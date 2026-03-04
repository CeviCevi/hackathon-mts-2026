package by.mts.hackathon_api.DTO;

import lombok.Data;

@Data
public class VmDTO {
    
    private int id;

    private String name;  

    private Long idSsh;

    private double ram;

    private double rom;  

    private double frequency;

    private String os;

    private int status;

    private Long idUser;

    private String role;

}
