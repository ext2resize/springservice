package com.devops.hello.world;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.Nullable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/")
@RequiredArgsConstructor
public class HomeController{
    @GetMapping
    public ResponseEntity<?> find(@RequestParam("testId") String testId, @RequestParam("testName") @Nullable String testName){

            System.out.println(testId);
            System.out.println(testName);

            return ResponseEntity.ok("This is testId: " + testId + "\n" + " This is testName: " + testName);
    }
}