package com.example.nexa.service;

import com.example.nexa.entity.InteriorImage;
import com.example.nexa.repository.InteriorImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class InteriorImageService {
    @Autowired
    private InteriorImageRepository interiorImageRepository;
    private String email;

    public boolean existsByEmail(String email) {
        return interiorImageRepository.existsByEmail(email);
    }

    public Integer findLastInteriorImageIdByEmail(String email) {
        InteriorImage lastImage = interiorImageRepository.findTopByEmailOrderByInteriorImageIdDesc(email);
        return lastImage != null ? lastImage.getInteriorImageId() : null;
    }
}