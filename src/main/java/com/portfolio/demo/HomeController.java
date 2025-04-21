package com.portfolio.demo;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("name", "Hemant Khatiwada");
        model.addAttribute("bio", "A Java developer.");
        model.addAttribute("skills", new String[]{"Java", "Spring Boot", "HTML", "CSS", "JavaScript"});
        model.addAttribute("projects", new String[]{"Portfolio Website", "To-Do App", "Weather App"});
        return "index";
    }
}
