package com.example.springbootapp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "APP_LOGS")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AppLog {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "log_seq")
    @SequenceGenerator(name = "log_seq", sequenceName = "APP_LOG_SEQ", allocationSize = 1)
    private Long id;

    @Column(nullable = false)
    private String message;

    @Column(name = "LOG_LEVEL")
    private String logLevel;

    @Column(name = "CREATED_AT")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
