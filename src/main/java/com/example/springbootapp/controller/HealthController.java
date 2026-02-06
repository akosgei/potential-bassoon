package com.example.springbootapp.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.beans.factory.annotation.Value;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class HealthController {

    @Value("${wiremock.url}")
    private String wiremockUrl;

    @GetMapping("/hello")
    public Map<String, String> hello() {
        Map<String, String> response = new HashMap<>();
        response.put("message", "Hello from Spring Boot Application!");
        response.put("status", "running");
        return response;
    }

    @GetMapping("/wiremock-test")
    public Map<String, Object> testWiremock() {
        Map<String, Object> response = new HashMap<>();
        try {
            RestTemplate restTemplate = new RestTemplate();
            String wiremockResponse = restTemplate.getForObject(
                wiremockUrl + "/api/health", 
                String.class
            );
            response.put("success", true);
            response.put("wiremock_response", wiremockResponse);
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
        }
        return response;
    }
}
