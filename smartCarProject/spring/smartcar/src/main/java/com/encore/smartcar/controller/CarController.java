package com.encore.smartcar.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.encore.smartcar.data.dto.CarData;

@Controller
@RequestMapping("/")
public class CarController {
    private List<CarData> dataList = new ArrayList<>();

    public CarController() {
        // Adding sample data
        dataList.add(new CarData("2024-07-12", "Sample content for today"));
        dataList.add(new CarData("2024-07-11", "Sample content for yesterday"));
        dataList.add(new CarData("2024-07-14", "Sample content for yesterday"));
        dataList.add(new CarData("2024-07-13", "Sample content for yesterday"));
    }

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("dataList", dataList);
        return "index";
    }

    @PostMapping("/")
    public String addData(@RequestBody CarData carData, Model model) {
        dataList.add(carData);
        model.addAttribute("dataList", dataList);
        return "index";
    }
}
