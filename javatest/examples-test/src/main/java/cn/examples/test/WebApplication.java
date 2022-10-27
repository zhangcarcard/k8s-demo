package cn.examples.test;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class WebApplication implements CommandLineRunner, ApplicationRunner {
    public static void main(String[] args) {
        SpringApplication.run(WebApplication.class, args);
        System.out.println("examples-test started.");
    }

    @Override
    public void run(String... args) {
        System.out.println("examples-test CommandLineRunner.run.");
    }

    @Override
    public void run(ApplicationArguments args) {
        System.out.println("examples-test ApplicationRunner.run.");
    }
}