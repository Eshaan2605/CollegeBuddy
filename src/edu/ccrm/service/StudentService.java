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

    /** Creates and persists a new student. Throws if ID is duplicate. */
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

    /** Enrolls student in a course; checks for duplicates and credit limits. */
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

    /** Returns top N students sorted by GPA descending. */
    public List<Student> getTopStudents(int n){
        return ds.getStudents().values().stream()
            .sorted(Comparator.comparingDouble(Student::computeGPA).reversed())
            .limit(n)
            .collect(Collectors.toList());
    }
}



