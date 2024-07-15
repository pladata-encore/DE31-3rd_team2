package com.encore.smartcar.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;


@Configuration
public class SwaggerConfiguration {
    @Bean
    public OpenAPI openAPI(){
        Info info = new Info().title("My test")
                .version("1.0")
                .description("smartCar api test");


        return new OpenAPI().info(info);
    }

}
