package com.example.nexa.repository;

import com.example.nexa.entity.InteriorImage;
import com.example.nexa.entity.InteriorImageKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InteriorImageRepository extends JpaRepository<InteriorImage, InteriorImageKey> {
    List<InteriorImage> findByClientEmail(String email);

    //retrieve only values which contains aug image url
    @Query(value = "SELECT ii.*, cpcc.color_group " +
            "FROM interior_image ii " +
            "JOIN color_pallet cpcc ON ii.email = cpcc.email AND ii.interior_image_id = cpcc.image_color_pallet_id " +
            "WHERE ii.augmented_image_url IS NOT NULL " +
            "AND (CASE WHEN ?1 = 'all' THEN TRUE ELSE ii.complexity_score = ?1 END OR ?1 IS NULL) " +
            "AND (CASE WHEN ?2 = 'all' THEN TRUE ELSE ii.texture = ?2 END OR ?2 IS NULL) " +
            "AND (CASE WHEN ?3 = 'all' THEN TRUE ELSE cpcc.color_group = ?3 END OR ?3 IS NULL)",
            nativeQuery = true)
    List<InteriorImage> getAllDataByAllValue(String complexity, String texture, String color);

    @Query(value = "SELECT * FROM interior_image WHERE email = ?1 AND interior_image_id = ?2", nativeQuery = true)
    InteriorImage findByEmailAndInteriorImageId(String email,int interiorImageId);

    boolean existsByEmail(String email);

    InteriorImage findTopByEmailOrderByInteriorImageIdDesc(String email);
}

