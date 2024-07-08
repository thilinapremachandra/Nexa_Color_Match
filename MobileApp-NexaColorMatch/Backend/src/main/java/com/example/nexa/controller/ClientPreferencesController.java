package com.example.nexa.controller;

import com.example.nexa.entity.ClientPreferences;
import com.example.nexa.service.ClientPreferencesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/client-preferences")
public class ClientPreferencesController {

    @Autowired
    private ClientPreferencesService service;

    @PostMapping
    public ResponseEntity<ClientPreferences> saveOrUpdate(@RequestBody ClientPreferences clientPreferences) {
        ClientPreferences savedPreferences = service.saveOrUpdate(clientPreferences);
        return ResponseEntity.ok(savedPreferences);
    }
}
