package by.mts.hackathon_api.Models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "vm")

public class VmModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = false, nullable = false)
    private String password;

    @Column(unique = true, nullable = true)
    private Integer port;  

    @Column(unique = true, nullable = false)
    private String name;  

    @Column(unique = false, nullable = true)
    private Long idSsh;
    
    @Column(unique = false, nullable = false)
    private Integer  ram;  

    @Column(unique = false, nullable = false)
    private Integer  rom;  

    @Column(unique = false, nullable = false)
    private Integer cors;

    @Column(unique = false, nullable = false)
    private String  os;

    @Column(unique = false)
    private Integer status;


}
