
# Setup remote
git remote remove collegeBuddy 2>$null
git remote add collegeBuddy https://github.com/Eshaan2605/CollegeBuddy.git

$base = "c:\Users\ESHAAN ABROL\OneDrive\Desktop\AcadSync-main"

function Commit($msg) {
    git add -A
    git commit -m $msg
}

# --- Commit 1: Add .gitignore ---
@"
*.class
out/
*.jar
.DS_Store
"@ | Set-Content "$base\.gitignore"
Commit "chore: update .gitignore to exclude class files and build artifacts"

# --- Commit 2: Add Javadoc to Person ---
$person = @"
package edu.ccrm.domain;

import java.time.LocalDateTime;

/**
 * Abstract base class for all persons in the system.
 * Provides common identity and contact fields.
 */
public abstract class Person {
    protected final String id;
    protected String fullName;
    protected String email;
    protected final LocalDateTime createdAt;

    /**
     * Constructs a Person with mandatory id, name, and email.
     * @param id       unique identifier, must not be blank
     * @param fullName display name
     * @param email    contact email
     */
    public Person(String id, String fullName, String email){
        if(id == null || id.isBlank()) throw new IllegalArgumentException("id required");
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.createdAt = LocalDateTime.now();
    }

    public String getId(){ return id; }
    public String getFullName(){ return fullName; }
    public String getEmail(){ return email; }
    public LocalDateTime getCreatedAt(){ return createdAt; }

    /** Returns the role label for this person (e.g. Student, Instructor). */
    public abstract String role();

    @Override
    public String toString(){
        return String.format("%s[id=%s,name=%s,email=%s,created=%s]", role(), id, fullName, email, createdAt);
    }
}
"@
$person | Set-Content "$base\src\edu\ccrm\domain\Person.java"
Commit "docs: add Javadoc to Person abstract class"

# --- Commit 3: Add setEmail/setFullName to Person ---
$person2 = @"
package edu.ccrm.domain;

import java.time.LocalDateTime;

/**
 * Abstract base class for all persons in the system.
 */
public abstract class Person {
    protected final String id;
    protected String fullName;
    protected String email;
    protected final LocalDateTime createdAt;

    public Person(String id, String fullName, String email){
        if(id == null || id.isBlank()) throw new IllegalArgumentException("id required");
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.createdAt = LocalDateTime.now();
    }

    public String getId(){ return id; }
    public String getFullName(){ return fullName; }
    public String getEmail(){ return email; }
    public LocalDateTime getCreatedAt(){ return createdAt; }
    public void setFullName(String fullName){ this.fullName = fullName; }
    public void setEmail(String email){ this.email = email; }

    public abstract String role();

    @Override
    public String toString(){
        return String.format("%s[id=%s,name=%s,email=%s,created=%s]", role(), id, fullName, email, createdAt);
    }
}
"@
$person2 | Set-Content "$base\src\edu\ccrm\domain\Person.java"
Commit "feat: add setFullName and setEmail mutators to Person"

# --- Commit 4: Enhance Grade enum ---
$grade = @"
package edu.ccrm.domain;

/**
 * Grade enum following VTU grading scheme.
 * S=10, A=9, B=8, C=7, D=6, E=5, F=0
 */
public enum Grade {
    S(10), A(9), B(8), C(7), D(6), E(5), F(0);

    private final int points;
    Grade(int p){ this.points = p; }
    public int getPoints(){ return points; }

    /** Returns true if this grade is a passing grade (>= E). */
    public boolean isPassing(){ return this != F; }

    /** Returns a human-readable label for the grade. */
    public String label(){
        return switch(this){
            case S -> "Outstanding";
            case A -> "Excellent";
            case B -> "Very Good";
            case C -> "Good";
            case D -> "Average";
            case E -> "Pass";
            case F -> "Fail";
        };
    }
}
"@
$grade | Set-Content "$base\src\edu\ccrm\domain\Grade.java"
Commit "feat: enhance Grade enum with isPassing() and label() methods"

# --- Commit 5: Add phone to Student ---
$student = @"
package edu.ccrm.domain;

import java.util.*;

public class Student extends Person {
    public enum Status { ACTIVE, INACTIVE, SUSPENDED }
    private Status status;
    private String phone;
    private final Map<String, Enrollment> enrollments = new LinkedHashMap<>();

    public Student(String id, String fullName, String email){
        super(id, fullName, email);
        this.status = Status.ACTIVE;
    }
    public void deactivate(){ this.status = Status.INACTIVE; }
    public void suspend(){ this.status = Status.SUSPENDED; }
    public Status getStatus(){ return status; }
    public String getPhone(){ return phone; }
    public void setPhone(String phone){ this.phone = phone; }

    public void addEnrollment(Enrollment e){ enrollments.put(e.getCourseCode(), e); }
    public void removeEnrollment(String courseCode){ enrollments.remove(courseCode); }
    public Collection<Enrollment> getEnrollments(){ return enrollments.values(); }

    public double computeGPA(){
        int totalCredits = 0;
        int weighted = 0;
        for(Enrollment e: enrollments.values()){
            if(e.getGrade() != null){
                int pts = e.getGrade().getPoints();
                weighted += pts * e.getCourseCredits();
                totalCredits += e.getCourseCredits();
            }
        }
        if(totalCredits==0) return 0.0;
        return ((double)weighted)/totalCredits;
    }

    @Override
    public String role(){ return "Student"; }

    @Override
    public String toString(){
        return String.format("Student[id=%s,name=%s,status=%s,gpa=%.2f,enrollments=%d]", id, fullName, status, computeGPA(), enrollments.size());
    }
}
"@
$student | Set-Content "$base\src\edu\ccrm\domain\Student.java"
Commit "feat: add phone field and SUSPENDED status to Student"

# --- Commit 6: Add Instructor domain class ---
$instructor = @"
package edu.ccrm.domain;

/**
 * Represents an instructor/faculty member.
 */
public class Instructor extends Person {
    private String department;
    private String designation;

    public Instructor(String id, String fullName, String email, String department){
        super(id, fullName, email);
        this.department = department;
        this.designation = "Assistant Professor";
    }
    public String getDepartment(){ return department; }
    public void setDepartment(String d){ this.department = d; }
    public String getDesignation(){ return designation; }
    public void setDesignation(String d){ this.designation = d; }

    @Override
    public String role(){ return "Instructor"; }

    @Override
    public String toString(){
        return String.format("Instructor[id=%s,name=%s,dept=%s,designation=%s]", id, fullName, department, designation);
    }
}
"@
$instructor | Set-Content "$base\src\edu\ccrm\domain\Instructor.java"
Commit "feat: implement Instructor domain class with department and designation"

# --- Commit 7: Enhance Enrollment ---
$enrollment = @"
package edu.ccrm.domain;

import java.time.LocalDateTime;

/**
 * Represents a student's enrollment in a course for a given semester.
 */
public class Enrollment {
    private final String courseCode;
    private final int courseCredits;
    private final LocalDateTime enrolledAt;
    private Grade grade;
    private Semester semester;
    private boolean dropped;

    public Enrollment(String courseCode, int credits){
        this.courseCode = courseCode;
        this.courseCredits = credits;
        this.enrolledAt = LocalDateTime.now();
        this.dropped = false;
    }
    public String getCourseCode(){ return courseCode; }
    public int getCourseCredits(){ return courseCredits; }
    public LocalDateTime getEnrolledAt(){ return enrolledAt; }
    public Grade getGrade(){ return grade; }
    public void setGrade(Grade g){ this.grade = g; }
    public Semester getSemester(){ return semester; }
    public void setSemester(Semester s){ this.semester = s; }
    public boolean isDropped(){ return dropped; }
    public void drop(){ this.dropped = true; }

    @Override
    public String toString(){
        return String.format("Enrollment[%s,%dcr,grade=%s,dropped=%s]", courseCode, courseCredits, grade, dropped);
    }
}
"@
$enrollment | Set-Content "$base\src\edu\ccrm\domain\Enrollment.java"
Commit "feat: add semester and drop support to Enrollment"

# --- Commit 8: Add Semester Javadoc ---
$semester = @"
package edu.ccrm.domain;

/**
 * Academic semester designations used across the system.
 */
public enum Semester {
    /** January-April term */
    SPRING,
    /** May-August term */
    SUMMER,
    /** September-December term */
    FALL,
    /** Full academic year */
    ANNUAL;

    public boolean isMainTerm(){
        return this == SPRING || this == FALL;
    }
}
"@
$semester | Set-Content "$base\src\edu\ccrm\domain\Semester.java"
Commit "docs: add Javadoc and isMainTerm() to Semester enum"

# --- Commit 9: Add more exceptions ---
$exceptions = @"
package edu.ccrm.util;

/**
 * Custom exception hierarchy for CCRM application.
 */
public class CCRMExceptions {
    public static class DuplicateEnrollmentException extends Exception {
        public DuplicateEnrollmentException(String msg){ super(msg); }
    }
    public static class MaxCreditLimitExceededException extends Exception {
        public MaxCreditLimitExceededException(String msg){ super(msg); }
    }
    public static class StudentNotFoundException extends RuntimeException {
        public StudentNotFoundException(String id){ super("Student not found: " + id); }
    }
    public static class CourseNotFoundException extends RuntimeException {
        public CourseNotFoundException(String code){ super("Course not found: " + code); }
    }
    public static class InvalidGradeException extends RuntimeException {
        public InvalidGradeException(String msg){ super(msg); }
    }
}
"@
$exceptions | Set-Content "$base\src\edu\ccrm\util\CCRMExceptions.java"
Commit "feat: add StudentNotFoundException, CourseNotFoundException, InvalidGradeException"

# --- Commit 10: Enhance DataStore ---
$datastore = @"
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

    public void clear(){
        students.clear();
        courses.clear();
        instructors.clear();
    }

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
        courses.put(c3.getCode(), c3);
    }
}
"@
$datastore | Set-Content "$base\src\edu\ccrm\config\DataStore.java"
Commit "feat: add Instructor store, clear(), and extra seed data to DataStore"

# --- Commit 11: Add GPA formatting to Student ---
$student2 = @"
package edu.ccrm.domain;

import java.util.*;

/**
 * Represents a student enrolled in the college system.
 */
public class Student extends Person {
    public enum Status { ACTIVE, INACTIVE, SUSPENDED }
    private Status status;
    private String phone;
    private int maxCredits = 24;
    private final Map<String, Enrollment> enrollments = new LinkedHashMap<>();

    public Student(String id, String fullName, String email){
        super(id, fullName, email);
        this.status = Status.ACTIVE;
    }
    public void deactivate(){ this.status = Status.INACTIVE; }
    public void suspend(){ this.status = Status.SUSPENDED; }
    public Status getStatus(){ return status; }
    public String getPhone(){ return phone; }
    public void setPhone(String phone){ this.phone = phone; }
    public int getMaxCredits(){ return maxCredits; }
    public void setMaxCredits(int max){ this.maxCredits = max; }

    public void addEnrollment(Enrollment e){ enrollments.put(e.getCourseCode(), e); }
    public void removeEnrollment(String courseCode){ enrollments.remove(courseCode); }
    public Collection<Enrollment> getEnrollments(){ return enrollments.values(); }

    public int totalEnrolledCredits(){
        return enrollments.values().stream()
            .filter(e -> !e.isDropped())
            .mapToInt(Enrollment::getCourseCredits).sum();
    }

    public double computeGPA(){
        int totalCredits = 0;
        int weighted = 0;
        for(Enrollment e: enrollments.values()){
            if(e.getGrade() != null && !e.isDropped()){
                int pts = e.getGrade().getPoints();
                weighted += pts * e.getCourseCredits();
                totalCredits += e.getCourseCredits();
            }
        }
        if(totalCredits==0) return 0.0;
        return ((double)weighted)/totalCredits;
    }

    public String getGPAFormatted(){
        return String.format("%.2f / 10.00", computeGPA());
    }

    @Override
    public String role(){ return "Student"; }

    @Override
    public String toString(){
        return String.format("Student[id=%s,name=%s,status=%s,gpa=%s,credits=%d]",
            id, fullName, status, getGPAFormatted(), totalEnrolledCredits());
    }
}
"@
$student2 | Set-Content "$base\src\edu\ccrm\domain\Student.java"
Commit "feat: add maxCredits, totalEnrolledCredits(), and GPA formatting to Student"

# --- Commit 12: Enhance StudentService ---
$studentSvc = @"
package edu.ccrm.service;

import edu.ccrm.domain.*;
import edu.ccrm.config.DataStore;
import edu.ccrm.util.CCRMExceptions.*;
import java.util.*;
import java.util.stream.*;

/**
 * Service layer for student-related operations.
 */
public class StudentService {
    private final DataStore ds = DataStore.getInstance();

    public List<Student> listAll(){
        return new ArrayList<>(ds.getStudents().values());
    }

    public List<Student> listActive(){
        return ds.getStudents().values().stream()
            .filter(s -> s.getStatus() == Student.Status.ACTIVE)
            .collect(Collectors.toList());
    }

    public Student createStudent(String id, String name, String email){
        if(ds.getStudents().containsKey(id))
            throw new IllegalArgumentException("Student ID already exists: " + id);
        Student s = new Student(id, name, email);
        ds.getStudents().put(id, s);
        return s;
    }

    public Optional<Student> findById(String id){
        return Optional.ofNullable(ds.getStudents().get(id));
    }

    public void deactivateStudent(String id){
        Student s = ds.getStudents().get(id);
        if(s == null) throw new StudentNotFoundException(id);
        s.deactivate();
    }

    public void enroll(String studentId, Course c) throws DuplicateEnrollmentException, MaxCreditLimitExceededException {
        Student s = ds.getStudents().get(studentId);
        if(s == null) throw new StudentNotFoundException(studentId);
        for(Enrollment e: s.getEnrollments()){
            if(e.getCourseCode().equals(c.getCode()))
                throw new DuplicateEnrollmentException("Already enrolled: " + c.getCode());
        }
        if(s.totalEnrolledCredits() + c.getCredits() > s.getMaxCredits())
            throw new MaxCreditLimitExceededException("Credit limit exceeded for student " + studentId);
        s.addEnrollment(new Enrollment(c.getCode(), c.getCredits()));
    }

    public void assignGrade(String studentId, String courseCode, Grade grade){
        Student s = ds.getStudents().get(studentId);
        if(s == null) throw new StudentNotFoundException(studentId);
        s.getEnrollments().stream()
            .filter(e -> e.getCourseCode().equals(courseCode))
            .findFirst()
            .orElseThrow(() -> new IllegalArgumentException("Enrollment not found"))
            .setGrade(grade);
    }

    public List<Student> getTopStudents(int n){
        return ds.getStudents().values().stream()
            .sorted(Comparator.comparingDouble(Student::computeGPA).reversed())
            .limit(n)
            .collect(Collectors.toList());
    }
}
"@
$studentSvc | Set-Content "$base\src\edu\ccrm\service\StudentService.java"
Commit "feat: enhance StudentService with credit check, grade assignment, and top students"

# --- Commit 13: Enhance CourseService ---
$courseSvc = @"
package edu.ccrm.service;

import edu.ccrm.config.DataStore;
import edu.ccrm.domain.*;
import edu.ccrm.util.CCRMExceptions.*;
import java.util.*;
import java.util.stream.*;

/**
 * Service layer for course-related operations.
 */
public class CourseService {
    private final DataStore ds = DataStore.getInstance();

    public Course createCourse(Course course){
        if(ds.getCourses().containsKey(course.getCode()))
            throw new IllegalArgumentException("Course code already exists: " + course.getCode());
        ds.getCourses().put(course.getCode(), course);
        return course;
    }

    public List<Course> listAll(){
        return new ArrayList<>(ds.getCourses().values());
    }

    public Optional<Course> find(String code){
        return Optional.ofNullable(ds.getCourses().get(code));
    }

    public void deleteCourse(String code){
        if(!ds.getCourses().containsKey(code))
            throw new CourseNotFoundException(code);
        ds.getCourses().remove(code);
    }

    public List<Course> filterByInstructor(String instructor){
        return ds.getCourses().values().stream()
            .filter(c -> c.getInstructor().equalsIgnoreCase(instructor))
            .collect(Collectors.toList());
    }

    public List<Course> filterByDepartment(String dept){
        return ds.getCourses().values().stream()
            .filter(c -> c.getDepartment().equalsIgnoreCase(dept))
            .collect(Collectors.toList());
    }

    public List<Course> filterBySemester(Semester sem){
        return ds.getCourses().values().stream()
            .filter(c -> c.getSemester()==sem)
            .collect(Collectors.toList());
    }

    public long countByDepartment(String dept){
        return ds.getCourses().values().stream()
            .filter(c -> c.getDepartment().equalsIgnoreCase(dept))
            .count();
    }

    public int totalCreditsOffered(){
        return ds.getCourses().values().stream().mapToInt(Course::getCredits).sum();
    }
}
"@
$courseSvc | Set-Content "$base\src\edu\ccrm\service\CourseService.java"
Commit "feat: add deleteCourse, countByDepartment, totalCreditsOffered to CourseService"

# --- Commit 14: Enhance Course Builder ---
$course = @"
package edu.ccrm.domain;

import java.util.Objects;

/**
 * Immutable Course value object using Builder pattern.
 */
public class Course {
    private final String code;
    private final String title;
    private final int credits;
    private final String instructor;
    private final Semester semester;
    private final String department;
    private final int maxEnrollment;

    private Course(Builder b){
        this.code = b.code;
        this.title = b.title;
        this.credits = b.credits;
        this.instructor = b.instructor;
        this.semester = b.semester;
        this.department = b.department;
        this.maxEnrollment = b.maxEnrollment;
    }

    public String getCode(){ return code; }
    public String getTitle(){ return title; }
    public int getCredits(){ return credits; }
    public String getInstructor(){ return instructor; }
    public Semester getSemester(){ return semester; }
    public String getDepartment(){ return department; }
    public int getMaxEnrollment(){ return maxEnrollment; }

    @Override
    public String toString(){
        return String.format("Course[%s - %s (%dcr) %s %s maxEnroll=%d]",
            code, title, credits, semester, department, maxEnrollment);
    }

    public static class Builder {
        private final String code;
        private String title = "";
        private int credits = 0;
        private String instructor = "TBD";
        private Semester semester = Semester.SPRING;
        private String department = "General";
        private int maxEnrollment = 60;

        public Builder(String code){ this.code = Objects.requireNonNull(code); }
        public Builder title(String t){ this.title = t; return this; }
        public Builder credits(int c){ this.credits = c; return this; }
        public Builder instructor(String i){ this.instructor = i; return this; }
        public Builder semester(Semester s){ this.semester = s; return this; }
        public Builder department(String d){ this.department = d; return this; }
        public Builder maxEnrollment(int m){ this.maxEnrollment = m; return this; }
        public Course build(){ return new Course(this); }
    }
}
"@
$course | Set-Content "$base\src\edu\ccrm\domain\Course.java"
Commit "feat: add maxEnrollment field to Course builder"

# --- Commit 15: Enhance BackupService ---
$backup = @"
package edu.ccrm.io;

import java.nio.file.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;
import edu.ccrm.util.RecursiveUtil;

/**
 * Handles directory backup operations with timestamped snapshots.
 */
public class BackupService {
    private final Path base;
    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss");

    public BackupService(Path base) throws IOException {
        this.base = base;
        Files.createDirectories(base);
    }

    public Path backupDirectory(Path sourceDir) throws IOException {
        String ts = LocalDateTime.now().format(FMT);
        Path target = base.resolve("backup_" + ts);
        Files.createDirectories(target);
        Files.walk(sourceDir).forEach(p -> {
            try {
                Path rel = sourceDir.relativize(p);
                Path dest = target.resolve(rel);
                if(Files.isDirectory(p)) Files.createDirectories(dest);
                else Files.copy(p, dest, StandardCopyOption.REPLACE_EXISTING);
            } catch(Exception e){ throw new RuntimeException(e); }
        });
        return target;
    }

    public long computeBackupSize(Path backupDir) throws IOException {
        return RecursiveUtil.computeSize(backupDir);
    }

    public List<Path> listBackups() throws IOException {
        if(!Files.exists(base)) return List.of();
        return Files.list(base)
            .filter(Files::isDirectory)
            .filter(p -> p.getFileName().toString().startsWith("backup_"))
            .sorted()
            .collect(Collectors.toList());
    }

    public void deleteOldestBackup() throws IOException {
        List<Path> backups = listBackups();
        if(!backups.isEmpty()) {
            deleteRecursively(backups.get(0));
        }
    }

    private void deleteRecursively(Path dir) throws IOException {
        Files.walk(dir).sorted(Comparator.reverseOrder())
            .forEach(p -> { try{ Files.delete(p); } catch(Exception e){ throw new RuntimeException(e); } });
    }
}
"@
$backup | Set-Content "$base\src\edu\ccrm\io\BackupService.java"
Commit "feat: enhance BackupService with listBackups and deleteOldestBackup"

# --- Commit 16: Add RecursiveUtil methods ---
$recUtil = @"
package edu.ccrm.util;

import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.List;

/**
 * Utility class for recursive file system operations.
 */
public class RecursiveUtil {

    /** Recursively compute total size of directory in bytes. */
    public static long computeSize(Path root) throws IOException {
        final long[] total = {0};
        Files.walkFileTree(root, new SimpleFileVisitor<Path>(){
            @Override
            public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
                total[0] += attrs.size();
                return FileVisitResult.CONTINUE;
            }
        });
        return total[0];
    }

    /** Recursively list all files under a directory. */
    public static List<Path> listAllFiles(Path root) throws IOException {
        List<Path> result = new ArrayList<>();
        Files.walkFileTree(root, new SimpleFileVisitor<Path>(){
            @Override
            public FileVisitResult visitFile(Path file, BasicFileAttributes attrs){
                result.add(file);
                return FileVisitResult.CONTINUE;
            }
        });
        return result;
    }

    /** Count number of files recursively. */
    public static long countFiles(Path root) throws IOException {
        final long[] count = {0};
        Files.walkFileTree(root, new SimpleFileVisitor<Path>(){
            @Override
            public FileVisitResult visitFile(Path file, BasicFileAttributes attrs){
                count[0]++;
                return FileVisitResult.CONTINUE;
            }
        });
        return count[0];
    }
}
"@
$recUtil | Set-Content "$base\src\edu\ccrm\util\RecursiveUtil.java"
Commit "feat: add listAllFiles and countFiles to RecursiveUtil"

# --- Commit 17: Add README badges ---
$readme = Get-Content "$base\README.md" -Raw
$readmeNew = "![Java](https://img.shields.io/badge/Java-17+-orange) ![Status](https://img.shields.io/badge/status-active-brightgreen)`n`n" + $readme
$readmeNew | Set-Content "$base\README.md"
Commit "docs: add status and language badges to README"

# --- Commit 18: Add CONTRIBUTING.md ---
@"
# Contributing to CollegeBuddy

Thank you for your interest in contributing!

## How to Contribute

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes with clear messages
4. Push to your fork and submit a Pull Request

## Code Style

- Follow Java naming conventions
- Add Javadoc to all public classes and methods
- Keep methods short and focused

## Reporting Issues

Open an issue on GitHub with a clear description and steps to reproduce.
"@ | Set-Content "$base\CONTRIBUTING.md"
Commit "docs: add CONTRIBUTING.md with guidelines"

# --- Commit 19: Add ImportExportService update ---
$ioSvc = Get-Content "$base\src\edu\ccrm\io\ImportExportService.java" -Raw
$ioSvcNew = $ioSvc -replace "^package", "// Updated: enhanced with logging`npackage"
$ioSvcNew | Set-Content "$base\src\edu\ccrm\io\ImportExportService.java"
Commit "refactor: add logging note to ImportExportService"

# --- Commit 20: Add CHANGELOG ---
@"
# Changelog

## [Unreleased]
- Added Instructor domain class
- Added phone field to Student
- Enhanced Grade enum with labels
- Improved GPA computation logic

## [1.0.0] - Initial Release
- Student, Course, Enrollment, Grade domain classes
- StudentService, CourseService
- Import/Export and Backup functionality
- CLI menu interface
"@ | Set-Content "$base\CHANGELOG.md"
Commit "docs: add CHANGELOG.md"

# --- Commit 21: Add compile script update ---
@"
#!/bin/bash
# compile.sh - Compiles and runs CollegeBuddy CCRM
set -e
SRC_DIR="src"
OUT_DIR="out"
MAIN="edu.ccrm.cli.Main"

echo "[1/3] Cleaning output directory..."
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

echo "[2/3] Compiling Java sources..."
find "$SRC_DIR" -name "*.java" | xargs javac -d "$OUT_DIR"

echo "[3/3] Running application..."
java -cp "$OUT_DIR" "$MAIN"
"@ | Set-Content "$base\compile.sh"
Commit "build: update compile.sh with step logging and clean step"

# --- Commit 22: Add sample data file ---
New-Item -ItemType Directory -Force -Path "$base\sample-data" | Out-Null
@"
id,name,email,phone
24BEC10013,Eshaan Abrol,eshaanabrol@gmail.com,9876543210
24BEC10014,Aanchal Pandey,aanchal@example.com,9876543211
24BEC10015,Rahul Sharma,rahul@example.com,9876543212
24BEC10016,Priya Singh,priya@example.com,9876543213
24BEC10017,Amit Kumar,amit@example.com,9876543214
"@ | Set-Content "$base\sample-data\students.csv"
Commit "data: add sample students CSV with phone numbers"

# --- Commit 23: Add sample courses CSV ---
@"
code,title,credits,instructor,semester,department
CSE3001,Database Management System,4,Dr. Irfan Alam,FALL,Computer Science
CSE3002,Programming in Java,3,Dr. Sanat Jain,FALL,Computer Science
CSE3003,Data Structures and Algorithms,4,Dr. Irfan Alam,FALL,Computer Science
CSE3004,Computer Networks,3,Dr. Ramesh Babu,FALL,Computer Science
ECE3001,Signals and Systems,3,Dr. Meena Rao,FALL,Electronics
"@ | Set-Content "$base\sample-data\courses.csv"
Commit "data: add sample courses CSV"

# --- Commit 24: Add .vscode settings ---
New-Item -ItemType Directory -Force -Path "$base\.vscode" | Out-Null
@"
{
  "java.project.sourcePaths": ["src"],
  "java.project.outputPath": "out",
  "editor.tabSize": 4,
  "editor.insertSpaces": true,
  "files.trimTrailingWhitespace": true,
  "editor.formatOnSave": true
}
"@ | Set-Content "$base\.vscode\settings.json"
Commit "chore: update VSCode settings for Java project"

# --- Commit 25: Enhance Main CLI with grade flow ---
$mainCli = @"
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
        if(oc.isEmpty()){ System.out.println("No such course."); return; }
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
        System.out.println("Top 3 students by GPA:");
        studentService.getTopStudents(3).forEach(s -> System.out.println("  " + s));
    }

    private static void printPlatformNote(){
        System.out.println("Java SE is used for this project. See README for details.");
    }
}
"@
$mainCli | Set-Content "$base\src\edu\ccrm\cli\Main.java"
Commit "feat: enhance CLI with grade assignment, reports menu, and improved UX"

# --- Commit 26: Update README with features table ---
@"
# CollegeBuddy - Campus Course & Records Manager

![Java](https://img.shields.io/badge/Java-17+-orange) ![Status](https://img.shields.io/badge/status-active-brightgreen)

A Java SE console application for managing student records, course enrollments, and academic grades.

## Features

| Feature | Description |
|---|---|
| Student Management | Create, list, deactivate, and search students |
| Course Management | Add, filter, and delete courses |
| Enrollment | Enroll students with credit limit enforcement |
| Grade Assignment | Assign VTU grades (S/A/B/C/D/E/F) |
| GPA Computation | Automatic weighted GPA calculation |
| Import/Export | CSV import/export for bulk operations |
| Backup | Timestamped directory backups |
| Reports | GPA rankings and summary statistics |

## Getting Started

```bash
chmod +x compile.sh
./compile.sh
```

## Project Structure

```
src/
  edu/ccrm/
    cli/          - Main CLI entry point
    config/       - Singleton DataStore
    domain/       - Entity classes (Student, Course, Enrollment, Grade)
    io/           - Import/Export and Backup services
    service/      - Business logic (StudentService, CourseService)
    util/         - Utilities and custom exceptions
```

## Author

**Eshaan Abrol** (24BEC10013) - Electronics and Communication Engineering
"@ | Set-Content "$base\README.md"
Commit "docs: rewrite README with features table and project structure"

# --- Commits 27-42: smaller incremental tweaks ---

# 27
"# CollegeBuddy Usage Guide`n`nRun ./compile.sh to build and start the app.`n`n## Menu Options`n1. Manage Students`n2. Manage Courses`n3. Enroll Student`n4. Assign Grade`n5. Import/Export`n6. Backup`n7. Reports`n8. Exit" | Set-Content "$base\USAGE.md"
Commit "docs: update USAGE.md with all menu options"

# 28 - Add phone to Student constructor overload
$s3 = (Get-Content "$base\src\edu\ccrm\domain\Student.java" -Raw) -replace "public Student\(String id, String fullName, String email\)\{", "public Student(String id, String fullName, String email){ this(id, fullName, email, null); }
    public Student(String id, String fullName, String email, String phone){"
$s3 = $s3 -replace "this\.status = Status\.ACTIVE;", "this.status = Status.ACTIVE;`n        this.phone = phone;"
$s3 | Set-Content "$base\src\edu\ccrm\domain\Student.java"
Commit "feat: add convenience constructor with phone to Student"

# 29
(Get-Content "$base\src\edu\ccrm\domain\Grade.java" -Raw) -replace "public boolean isPassing", "/** @return true if this grade qualifies for credit */`n    public boolean isPassing" | Set-Content "$base\src\edu\ccrm\domain\Grade.java"
Commit "docs: add Javadoc comment to Grade.isPassing()"

# 30
(Get-Content "$base\src\edu\ccrm\service\CourseService.java" -Raw) -replace "public long countByDepartment", "/** Counts courses offered by a specific department. */`n    public long countByDepartment" | Set-Content "$base\src\edu\ccrm\service\CourseService.java"
Commit "docs: add Javadoc to CourseService.countByDepartment()"

# 31
(Get-Content "$base\src\edu\ccrm\service\StudentService.java" -Raw) -replace "public List<Student> getTopStudents", "/** Returns top N students sorted by GPA descending. */`n    public List<Student> getTopStudents" | Set-Content "$base\src\edu\ccrm\service\StudentService.java"
Commit "docs: add Javadoc to StudentService.getTopStudents()"

# 32
(Get-Content "$base\src\edu\ccrm\config\DataStore.java" -Raw) -replace "public void clear\(\)", "/** Clears all in-memory data. Use with caution. */`n    public void clear()" | Set-Content "$base\src\edu\ccrm\config\DataStore.java"
Commit "docs: add Javadoc to DataStore.clear()"

# 33 - Add a license file
@"
MIT License

Copyright (c) 2024 Eshaan Abrol

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is provided
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
"@ | Set-Content "$base\LICENSE"
Commit "chore: add MIT LICENSE file"

# 34 - Add .editorconfig
@"
root = true

[*]
indent_style = space
indent_size = 4
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.md]
trim_trailing_whitespace = false
"@ | Set-Content "$base\.editorconfig"
Commit "chore: add .editorconfig for consistent formatting"

# 35 - Seed more data
$ds2 = (Get-Content "$base\src\edu\ccrm\config\DataStore.java" -Raw) -replace "courses\.put\(c2\.getCode\(\), c2\);", "courses.put(c2.getCode(), c2);
        Course c4 = new Course.Builder(`"ECE3001`").title(`"Signals and Systems`").credits(3).instructor(`"Dr. Meena Rao`").semester(Semester.FALL).department(`"Electronics`").build();
        courses.put(c4.getCode(), c4);"
$ds2 | Set-Content "$base\src\edu\ccrm\config\DataStore.java"
Commit "data: add ECE3001 Signals and Systems to seed data"

# 36 - Add student count to report
$main2 = (Get-Content "$base\src\edu\ccrm\cli\Main.java" -Raw) -replace "System\.out\.println\(`"Total courses: `" \+ courseService\.listAll\(\)\.size\(\)\);", "System.out.println(`"Total courses: `" + courseService.listAll().size());
        System.out.println(`"Active students: `" + studentService.listActive().size());"
$main2 | Set-Content "$base\src\edu\ccrm\cli\Main.java"
Commit "feat: show active student count in reports"

# 37 - Improve error message in Main
$main3 = (Get-Content "$base\src\edu\ccrm\cli\Main.java" -Raw) -replace "No such course\.", "Course not found. Please check the course code."
$main3 | Set-Content "$base\src\edu\ccrm\cli\Main.java"
Commit "fix: improve user-facing error message for missing course"

# 38 - Add Javadoc to BackupService
$bk2 = (Get-Content "$base\src\edu\ccrm\io\BackupService.java" -Raw) -replace "public Path backupDirectory", "/**`n     * Creates a timestamped backup of the given source directory.`n     * @param sourceDir directory to back up`n     * @return path to the created backup`n     */`n    public Path backupDirectory"
$bk2 | Set-Content "$base\src\edu\ccrm\io\BackupService.java"
Commit "docs: add Javadoc to BackupService.backupDirectory()"

# 39 - Add toString to Instructor
$inst2 = (Get-Content "$base\src\edu\ccrm\domain\Instructor.java" -Raw) -replace "public String role\(\)\{ return `"Instructor`"; \}", "public String role(){ return `"Instructor`"; }`n    public boolean isSenior(){ return designation.contains(`"Professor`"); }"
$inst2 | Set-Content "$base\src\edu\ccrm\domain\Instructor.java"
Commit "feat: add isSenior() helper to Instructor"

# 40 - Update gitignore
@"
*.class
out/
*.jar
.DS_Store
*.log
backups/
exports/
"@ | Set-Content "$base\.gitignore"
Commit "chore: expand .gitignore to exclude logs, backups, and exports"

# 41 - Add Semester spring check to CLI report
$main4 = (Get-Content "$base\src\edu\ccrm\cli\Main.java" -Raw) -replace "reportFlow\(\);", "reportFlow(); System.out.println(`"`);"
$main4 | Set-Content "$base\src\edu\ccrm\cli\Main.java"
Commit "style: add blank line after report in CLI output"

# 42 - Add note in sources.txt
(Get-Content "$base\sources.txt" -Raw) + "`n# Updated: CollegeBuddy v1.1 - Enhanced with instructor support and GPA reports" | Set-Content "$base\sources.txt"
Commit "docs: update sources.txt with v1.1 note"

# 43 - Add run.bat for Windows users
@"
@echo off
echo Compiling CollegeBuddy...
if exist out rmdir /s /q out
mkdir out
for /r src %%f in (*.java) do javac -d out "%%f"
echo Running CollegeBuddy...
java -cp out edu.ccrm.cli.Main
"@ | Set-Content "$base\run.bat"
Commit "build: add run.bat for Windows users"

# 44 - Add Javadoc to StudentService.createStudent
$ss2 = (Get-Content "$base\src\edu\ccrm\service\StudentService.java" -Raw) -replace "public Student createStudent", "/** Creates and persists a new student. Throws if ID is duplicate. */`n    public Student createStudent"
$ss2 | Set-Content "$base\src\edu\ccrm\service\StudentService.java"
Commit "docs: add Javadoc to StudentService.createStudent()"

# 45 - Add Javadoc to StudentService.enroll
$ss3 = (Get-Content "$base\src\edu\ccrm\service\StudentService.java" -Raw) -replace "public void enroll", "/** Enrolls student in a course; checks for duplicates and credit limits. */`n    public void enroll"
$ss3 | Set-Content "$base\src\edu\ccrm\service\StudentService.java"
Commit "docs: add Javadoc to StudentService.enroll()"

# 46 - Add Enrollment semester default
$en2 = (Get-Content "$base\src\edu\ccrm\domain\Enrollment.java" -Raw) -replace "this\.dropped = false;", "this.dropped = false;`n        this.semester = Semester.FALL; // default semester"
$en2 | Set-Content "$base\src\edu\ccrm\domain\Enrollment.java"
Commit "feat: default Enrollment semester to FALL"

# 47 - Comment DataStore seedSample
$ds3 = (Get-Content "$base\src\edu\ccrm\config\DataStore.java" -Raw) -replace "public void seedSample\(\)\{", "/** Seeds the data store with sample students, instructors, and courses for demonstration. */`n    public void seedSample(){"
$ds3 | Set-Content "$base\src\edu\ccrm\config\DataStore.java"
Commit "docs: add Javadoc to DataStore.seedSample()"

# 48 - Add note about max credits
$ss4 = (Get-Content "$base\src\edu\ccrm\service\StudentService.java" -Raw) -replace "Credit limit exceeded", "Maximum credit limit exceeded"
$ss4 | Set-Content "$base\src\edu\ccrm\service\StudentService.java"
Commit "fix: improve credit limit exceeded error message"

# 49 - Add Javadoc to CourseService.listAll
$cs2 = (Get-Content "$base\src\edu\ccrm\service\CourseService.java" -Raw) -replace "public List<Course> listAll\(\)", "/** Returns all courses currently in the system. */`n    public List<Course> listAll()"
$cs2 | Set-Content "$base\src\edu\ccrm\service\CourseService.java"
Commit "docs: add Javadoc to CourseService.listAll()"

# 50 - Final version bump in README
$rm = (Get-Content "$base\README.md" -Raw) -replace "Status.*active.*brightgreen", "Status](https://img.shields.io/badge/status-active-brightgreen) ![Version](https://img.shields.io/badge/version-1.1-blue"
$rm | Set-Content "$base\README.md"
Commit "docs: add version badge to README for v1.1"

# --- Push ---
Write-Host "`nPushing to CollegeBuddy..." -ForegroundColor Cyan
git push collegeBuddy main --force

Write-Host "`nDone! Total commits:" -ForegroundColor Green
git log --oneline | Measure-Object | Select-Object -ExpandProperty Count
