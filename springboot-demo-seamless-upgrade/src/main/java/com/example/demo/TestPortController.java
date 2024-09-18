package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("port/test")
public class TestPortController {
    @GetMapping("test")
    public String test() {
        return "2";
    }
}
