package by.mts.hackathon_api.DTO;

import lombok.Data;

@Data
public class VmDTO {
    
    private Long id;

    private String name;  

    private String password;

    private Long idSsh;

    private Integer ram;
    
    private Integer rom;  

    private Integer cors;

    private String os;

    private Integer status;

    private Long idUser;

    private String role;

}
