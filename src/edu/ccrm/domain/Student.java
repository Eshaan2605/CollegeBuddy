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
