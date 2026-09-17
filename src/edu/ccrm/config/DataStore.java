package edu.ccrm.config;

import edu.ccrm.domain.*;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Singleton in-memory data store for the CCRM application.
 */
public class DataStore {
    private static final DataStore INSTANCE = new DataStore();

    private final Map<String, Student> students = new ConcurrentHashMap<>();
    private final Map<String, Course> courses = new ConcurrentHashMap<>();
    private final Map<String, Instructor> instructors = new ConcurrentHashMap<>();

    private DataStore(){}

    public static DataStore getInstance(){ return INSTANCE; }

    public Map<String, Student> getStudents(){ return students; }
    public Map<String, Course> getCourses(){ return courses; }
    public Map<String, Instructor> getInstructors(){ return instructors; }

    /** Clears all in-memory data. Use with caution. */
    public void clear(){
        students.clear();
        courses.clear();
        instructors.clear();
    }

    /** Seeds the data store with sample students, instructors, and courses for demonstration. */
    public void seedSample(){
        Student s1 = new Student("24BEC10013","Eshaan Abrol","eshaanabrol@gmail.com");
        Student s2 = new Student("24BEC10014","Aanchal Pandey","aanchal@example.com");
        Student s3 = new Student("24BEC10015","Rahul Sharma","rahul@example.com");
        students.put(s1.getId(), s1);
        students.put(s2.getId(), s2);
        students.put(s3.getId(), s3);

        Instructor i1 = new Instructor("INS001","Dr. Irfan Alam","irfan@vit.ac.in","Computer Science");
        Instructor i2 = new Instructor("INS002","Dr. Sanat Jain","sanat@vit.ac.in","Computer Science");
        instructors.put(i1.getId(), i1);
        instructors.put(i2.getId(), i2);

        Course c1 = new Course.Builder("CSE3001").title("Database Management System").credits(4).instructor("Dr. Irfan Alam").semester(Semester.FALL).department("Computer Science").build();
        Course c2 = new Course.Builder("CSE3002").title("Programming in Java").credits(3).instructor("Dr. Sanat Jain").semester(Semester.FALL).department("Computer Science").build();
        Course c3 = new Course.Builder("CSE3003").title("Data Structures and Algorithms").credits(4).instructor("Dr. Irfan Alam").semester(Semester.FALL).department("Computer Science").build();
        courses.put(c1.getCode(), c1);
        courses.put(c2.getCode(), c2);
        Course c4 = new Course.Builder("ECE3001").title("Signals and Systems").credits(3).instructor("Dr. Meena Rao").semester(Semester.FALL).department("Electronics").build();
        courses.put(c4.getCode(), c4);
        courses.put(c3.getCode(), c3);
    }
}



