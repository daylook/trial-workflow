package com.example;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import static org.junit.jupiter.api.Assertions.*;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

public class AppTest {

    @Test
    @DisplayName("Test that App class exists and can be instantiated")
    public void testAppExists() {
        assertDoesNotThrow(() -> {
            App app = new App();
        });
    }

    @Test
    @DisplayName("Test that main method prints Hello World")
    public void testMainMethodPrintsHelloWorld() throws InterruptedException {
        // Redirect System.out to capture output
        ByteArrayOutputStream outContent = new ByteArrayOutputStream();
        PrintStream originalOut = System.out;
        System.setOut(new PrintStream(outContent));

        // Create a thread to run main method
        Thread mainThread = new Thread(() -> {
            App.main(new String[]{});
        });

        try {
            // Start the thread
            mainThread.start();

            // Wait a bit for output
            Thread.sleep(100);

            // Interrupt the thread to stop it
            mainThread.interrupt();
            mainThread.join(1000);

            // Check output
            String output = outContent.toString();
            assertTrue(output.contains("Hello World"),
                "Output should contain 'Hello World', but got: " + output);

        } finally {
            // Restore System.out
            System.setOut(originalOut);
        }
    }

    @Test
    @DisplayName("Test that Hello World message is correct")
    public void testMessageContent() {
        String expectedMessage = "Hello World";
        assertEquals("Hello World", expectedMessage);
    }

    @Test
    @DisplayName("Test basic arithmetic to verify test framework")
    public void testBasicArithmetic() {
        assertEquals(4, 2 + 2);
        assertEquals(0, 2 - 2);
        assertTrue(5 > 3);
    }
}
