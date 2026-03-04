package by.mts.hackathon_api.DTO;

import lombok.Data;

@Data
public class VmDTO {
    
    private Long id;

    private String name;  

    private Long idSsh;

    private Double ram;
    
    private Double rom;  

    private Double frequency;

    private String os;

    private Integer status;

    private Long idUser;

    private String role;

}
