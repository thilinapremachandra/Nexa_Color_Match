package com.example.nexa.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.Objects;
import java.util.Set;

import static org.springframework.data.jpa.domain.AbstractPersistable_.id;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@IdClass(InteriorImageKey.class)
public class InteriorImage {
    @Id
    private String email;

    @Id
    private int interiorImageId;
    private String augmentedImageUrl;
    private String texture;
    private String complexityScore;
    private String TimeStamp;
    private String interiorImageUrl;


//    //not
//    @Transient // This indicates that this field is not persisted in the database, but rather is a part of the query result
//    @JsonProperty("colorCode") // Ensures the field is included in the JSON output
//    private String colorCode;


    @ManyToOne
    @JoinColumn(name = "email", insertable = false, updatable = false)
    @JsonBackReference
    private Client client;

    @OneToMany(mappedBy = "interiorImage", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private Set<Generate> generates;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        InteriorImage that = (InteriorImage) o;
        return Objects.equals(email, that.email) &&
                Objects.equals(interiorImageId, that.interiorImageId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(email, interiorImageId);
    }
    public String getInteriorImageUrl() {
        return interiorImageUrl;
    }

    public String getEmail() {
        return this.email;
    }


    public InteriorImage(String email, int interiorImageId, String augmentedImageUrl, String texture, String complexityScore, String timeStamp, String interiorImageUrl) {
        this.email = email;
        this.interiorImageId = interiorImageId;
        this.augmentedImageUrl = augmentedImageUrl;
        this.texture = texture;
        this.complexityScore = complexityScore;
        TimeStamp = timeStamp;
        this.interiorImageUrl = interiorImageUrl;
    }
}
