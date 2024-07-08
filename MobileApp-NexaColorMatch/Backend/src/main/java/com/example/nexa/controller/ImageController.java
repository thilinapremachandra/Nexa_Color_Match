package com.example.nexa.controller;

import com.example.nexa.entity.InteriorImage;
import com.example.nexa.repository.InteriorImageRepository;
import com.example.nexa.service.S3Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/images")
public class ImageController {

    @Autowired
    private S3Service s3Service;

    @Autowired
    private InteriorImageRepository interiorImageRepository;

    @PostMapping("/room")
    public ResponseEntity<Map<String, Object>> uploadRoomImage(
            @RequestParam("file") MultipartFile file,
            @RequestParam("email") String email) throws IOException {
        String keyName = "room-images/" + file.getOriginalFilename();
        File convertedFile = convertMultipartFileToFile(file);
        String imageUrl;
        try {
            imageUrl = s3Service.uploadFile(convertedFile.getAbsolutePath(), keyName);
        } finally {
            convertedFile.delete();
        }

        InteriorImage image = new InteriorImage();
        image.setEmail(email);
        image.setInteriorImageUrl(imageUrl);
        image.setTimeStamp(new Timestamp(System.currentTimeMillis()).toString());
        InteriorImage savedImage = interiorImageRepository.save(image);

        Map<String, Object> response = new HashMap<>();
        response.put("interiorImageId", savedImage.getInteriorImageId()); // Ensure ID is from saved entity
        response.put("imageUrl", imageUrl);

        return ResponseEntity.ok(response);
    }

    private File convertMultipartFileToFile(MultipartFile file) throws IOException {
        File convertedFile = new File(file.getOriginalFilename());
        try (FileOutputStream fos = new FileOutputStream(convertedFile)) {
            fos.write(file.getBytes());
        }
        return convertedFile;
    }
}
