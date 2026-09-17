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
    /** @return true if this grade qualifies for credit */
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

