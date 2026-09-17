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

    /** Counts courses offered by a specific department. */
    public long countByDepartment(String dept){
        return ds.getCourses().values().stream()
            .filter(c -> c.getDepartment().equalsIgnoreCase(dept))
            .count();
    }

    public int totalCreditsOffered(){
        return ds.getCourses().values().stream().mapToInt(Course::getCredits).sum();
    }
}

