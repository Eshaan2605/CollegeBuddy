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
