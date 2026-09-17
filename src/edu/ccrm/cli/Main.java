package edu.ccrm.cli;

import edu.ccrm.config.DataStore;
import edu.ccrm.service.*;
import edu.ccrm.io.*;
import edu.ccrm.domain.*;
import java.nio.file.Paths;
import java.util.*;
import java.io.Console;

/**
 * A compact menu-driven CLI. Not exhaustive, but demonstrates required constructs.
 */
public class Main {
    private static final Scanner scanner = new Scanner(System.in);
    private static final DataStore ds = DataStore.getInstance();
    private static final StudentService studentService = new StudentService();
    private static final CourseService courseService = new CourseService();
    private static final ImportExportService ioService = new ImportExportService();

    public static void main(String[] args) {
        ds.seedSample();
        System.out.println("--- Campus Course & Records Manager (CCRM) ---");
        boolean run = true;
        while(run){
            printMenu();
            String choice = scanner.nextLine().trim();
            switch(choice){
                case "1" -> manageStudents();
                case "2" -> manageCourses();
                case "3" -> enrollFlow();
                case "4" -> importExportFlow();
                case "5" -> backupFlow();
                case "6" -> { printPlatformNote(); run = false; }
                default -> System.out.println("Unknown choice");
            }
        }
        System.out.println("Bye");
    }

    private static void printMenu(){
        System.out.println("1) Manage Students  2) Manage Courses  3) Enroll  4) Import/Export  5) Backup  6) Exit"); 
        System.out.print("Choose: ");
    }

    private static void manageStudents(){
        System.out.println("Students:");
        studentService.listAll().forEach(s -> System.out.println(s));
        System.out.print("Create new student? y/n: ");
        String ans = scanner.nextLine().trim();
        if(ans.equalsIgnoreCase("y")){
            System.out.print("id: "); String id = scanner.nextLine().trim();
            System.out.print("name: "); String name = scanner.nextLine().trim();
            System.out.print("email: "); String email = scanner.nextLine().trim();
            studentService.createStudent(id, name, email);
            System.out.println("Created.");
        }
    }

    private static void manageCourses(){
        System.out.println("Courses:");
        courseService.listAll().forEach(c -> System.out.println(c));
        System.out.print("Add course? y/n: ");
        if(scanner.nextLine().trim().equalsIgnoreCase("y")){
            System.out.print("code: "); String code = scanner.nextLine().trim();
            System.out.print("title: "); String title = scanner.nextLine().trim();
            System.out.print("credits: "); int cr = Integer.parseInt(scanner.nextLine().trim());
            System.out.print("instructor: "); String inst = scanner.nextLine().trim();
            System.out.print("department: "); String dept = scanner.nextLine().trim();
            Course c = new Course.Builder(code).title(title).credits(cr).instructor(inst).department(dept).build();
            courseService.createCourse(c);
            System.out.println("Course added.");
        }
    }

    private static void enrollFlow(){
        System.out.print("student id: "); String sid = scanner.nextLine().trim();
        System.out.print("course code: "); String cc = scanner.nextLine().trim();
        var oc = courseService.find(cc);
        if(oc.isEmpty()){ System.out.println("No such course"); return; }
        try {
            studentService.enroll(sid, oc.get());
            System.out.println("Enrolled");
        } catch(Exception e){
            System.out.println("Error: " + e.getMessage());
        }
    }

    private static void importExportFlow(){
        System.out.println("1) Import Students  2) Import Courses  3) Export All"); System.out.print("opt: ");
        String opt = scanner.nextLine().trim();
        try{
            if(opt.equals("1")){
                System.out.print("path: "); String p = scanner.nextLine().trim();
                ioService.importStudents(Paths.get(p));
                System.out.println("Imported students");
            } else if(opt.equals("2")){
                System.out.print("path: "); String p = scanner.nextLine().trim();
                ioService.importCourses(Paths.get(p));
                System.out.println("Imported courses");
            } else if(opt.equals("3")){
                System.out.print("out dir: "); String od = scanner.nextLine().trim();
                ioService.exportAll(Paths.get(od));
                System.out.println("Exported");
            }
        } catch(Exception e){ System.out.println("I/O error: " + e.getMessage()); }
    }

    private static void backupFlow(){
        try{
            System.out.print("Source directory to backup (e.g. exports): "); String src = scanner.nextLine().trim();
            System.out.print("Backup base dir (e.g. backups): "); String base = scanner.nextLine().trim();
            BackupService b = new BackupService(Paths.get(base));
            var dest = b.backupDirectory(Paths.get(src));
            System.out.println("Backed up to: " + dest);
            long size = b.computeBackupSize(dest);
            System.out.println("Backup size (bytes): " + size);
        } catch(Exception e){ System.out.println("Backup error: " + e.getMessage()); }
    }

    private static void printPlatformNote(){
        System.out.println("Java SE vs ME vs EE: Java SE is used for this project. (See README for details.)");
    }
}
