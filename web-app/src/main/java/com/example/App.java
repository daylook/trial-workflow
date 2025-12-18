package com.example;

public class App {
    public static void main(String[] args) {
        while (true) {
            System.out.println("Hello World");
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                System.err.println("Thread interrupted: " + e.getMessage());
                Thread.currentThread().interrupt();
                break;
            }
        }
    }
}
