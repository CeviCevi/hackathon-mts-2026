package by.mts.hackathon_api;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")     // Разрешить все источники
                .allowedMethods("*")      // Разрешить все методы
                .allowedHeaders("*")      // Разрешить все заголовки
                .allowCredentials(false)  // Важно: false при "*"
                .maxAge(3600);
    }
}