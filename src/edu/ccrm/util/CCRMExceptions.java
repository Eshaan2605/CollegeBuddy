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
