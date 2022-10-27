package cn.examples.test.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/k8s")
public class WebTest {
    @GetMapping("/hello")
    public String hello(String name) {
        return "hello," + name;
    }
}
