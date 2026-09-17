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
