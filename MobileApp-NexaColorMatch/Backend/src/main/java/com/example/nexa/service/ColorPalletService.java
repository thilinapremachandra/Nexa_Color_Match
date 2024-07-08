package com.example.nexa.service;


import com.example.nexa.dto.ColorPalletDTO;
import com.example.nexa.entity.ColorPallet;
import com.example.nexa.repository.ColorPalletRepository;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ColorPalletService {

    @Autowired
    private ColorPalletRepository colorPalletRepository;

    @Autowired
    private ModelMapper modelMapper;

    public ColorPalletDTO saveColorPallet(ColorPalletDTO colorpalletDTO) {
        colorPalletRepository.save(modelMapper.map(colorpalletDTO, ColorPallet.class));
        return colorpalletDTO;
    }

    public void updateColorPallet(ColorPallet colorPallet) {
        colorPalletRepository.save(colorPallet);
    }
}
