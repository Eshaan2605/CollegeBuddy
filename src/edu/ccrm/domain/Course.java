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
