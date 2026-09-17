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
