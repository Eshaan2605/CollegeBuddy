package edu.ccrm.cli;

import edu.ccrm.config.DataStore;
import edu.ccrm.service.*;
import edu.ccrm.io.*;
import edu.ccrm.domain.*;
import java.nio.file.Paths;
import java.util.*;

/**
 * CLI entry point for the CollegeBuddy Campus Course and Records Manager.
 */
public class Main {
    private static final Scanner scanner = new Scanner(System.in);
    private static final DataStore ds = DataStore.getInstance();
    private static final StudentService studentService = new StudentService();
    private static final CourseService courseService = new CourseService();
    private static final ImportExportService ioService = new ImportExportService();

    public static void main(String[] args) {
        ds.seedSample();
        System.out.println("=== CollegeBuddy: Campus Course & Records Manager ===");
        boolean run = true;
        while(run){
            printMenu();
            String choice = scanner.nextLine().trim();
            switch(choice){
                case "1" -> manageStudents();
                case "2" -> manageCourses();
                case "3" -> enrollFlow();
                case "4" -> gradeFlow();
                case "5" -> importExportFlow();
                case "6" -> backupFlow();
                case "7" -> reportFlow();
                case "8" -> { printPlatformNote(); run = false; }
                default -> System.out.println("Unknown choice. Please try again.");
            }
        }
        System.out.println("Thank you for using CollegeBuddy. Goodbye!");
    }

    private static void printMenu(){
        System.out.println("\n--- Main Menu ---");
        System.out.println("1) Manage Students  2) Manage Courses  3) Enroll");
        System.out.println("4) Assign Grade     5) Import/Export   6) Backup");
        System.out.println("7) Reports          8) Exit");
        System.out.print("Choose: ");
    }

    private static void manageStudents(){
        System.out.println("\n-- Students --");
        studentService.listAll().forEach(System.out::println);
        System.out.print("Create new student? y/n: ");
        if(scanner.nextLine().trim().equalsIgnoreCase("y")){
            System.out.print("id: "); String id = scanner.nextLine().trim();
            System.out.print("name: "); String name = scanner.nextLine().trim();
            System.out.print("email: "); String email = scanner.nextLine().trim();
            studentService.createStudent(id, name, email);
            System.out.println("Student created successfully.");
        }
    }

    private static void manageCourses(){
        System.out.println("\n-- Courses --");
        courseService.listAll().forEach(System.out::println);
        System.out.print("Add course? y/n: ");
        if(scanner.nextLine().trim().equalsIgnoreCase("y")){
            System.out.print("code: "); String code = scanner.nextLine().trim();
            System.out.print("title: "); String title = scanner.nextLine().trim();
            System.out.print("credits: "); int cr = Integer.parseInt(scanner.nextLine().trim());
            System.out.print("instructor: "); String inst = scanner.nextLine().trim();
            System.out.print("department: "); String dept = scanner.nextLine().trim();
            Course c = new Course.Builder(code).title(title).credits(cr).instructor(inst).department(dept).build();
            courseService.createCourse(c);
            System.out.println("Course added successfully.");
        }
    }

    private static void enrollFlow(){
        System.out.print("\nStudent ID: "); String sid = scanner.nextLine().trim();
        System.out.print("Course code: "); String cc = scanner.nextLine().trim();
        var oc = courseService.find(cc);
        if(oc.isEmpty()){ System.out.println("Course not found. Please check the course code."); return; }
        try {
            studentService.enroll(sid, oc.get());
            System.out.println("Enrolled successfully.");
        } catch(Exception e){
            System.out.println("Error: " + e.getMessage());
        }
    }

    private static void gradeFlow(){
        System.out.print("\nStudent ID: "); String sid = scanner.nextLine().trim();
        System.out.print("Course code: "); String cc = scanner.nextLine().trim();
        System.out.print("Grade (S/A/B/C/D/E/F): "); String g = scanner.nextLine().trim();
        try {
            studentService.assignGrade(sid, cc, Grade.valueOf(g.toUpperCase()));
            System.out.println("Grade assigned.");
        } catch(Exception e){
            System.out.println("Error: " + e.getMessage());
        }
    }

    private static void importExportFlow(){
        System.out.println("1) Import Students  2) Import Courses  3) Export All");
        System.out.print("opt: ");
        String opt = scanner.nextLine().trim();
        try{
            if(opt.equals("1")){
                System.out.print("path: "); ioService.importStudents(Paths.get(scanner.nextLine().trim()));
                System.out.println("Imported students.");
            } else if(opt.equals("2")){
                System.out.print("path: "); ioService.importCourses(Paths.get(scanner.nextLine().trim()));
                System.out.println("Imported courses.");
            } else if(opt.equals("3")){
                System.out.print("out dir: "); ioService.exportAll(Paths.get(scanner.nextLine().trim()));
                System.out.println("Exported.");
            }
        } catch(Exception e){ System.out.println("I/O error: " + e.getMessage()); }
    }

    private static void backupFlow(){
        try{
            System.out.print("Source directory: "); String src = scanner.nextLine().trim();
            System.out.print("Backup base dir: "); String base = scanner.nextLine().trim();
            BackupService b = new BackupService(Paths.get(base));
            var dest = b.backupDirectory(Paths.get(src));
            System.out.println("Backed up to: " + dest);
            System.out.println("Backup size (bytes): " + b.computeBackupSize(dest));
        } catch(Exception e){ System.out.println("Backup error: " + e.getMessage()); }
    }

    private static void reportFlow(){
        System.out.println("\n-- Reports --");
        System.out.println("Total students: " + studentService.listAll().size());
        System.out.println("Total courses: " + courseService.listAll().size());
        System.out.println("Active students: " + studentService.listActive().size());
        System.out.println("Top 3 students by GPA:");
        studentService.getTopStudents(3).forEach(s -> System.out.println("  " + s));
    }

    private static void printPlatformNote(){
        System.out.println("Java SE is used for this project. See README for details.");
    }
}


