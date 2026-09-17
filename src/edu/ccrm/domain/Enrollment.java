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
        this.semester = Semester.FALL; // default semester
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

