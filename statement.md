# Statement

## Problem Statement

Managing student records, course information, and academic data in a college environment is often a tedious and error-prone process when done manually. Existing systems are either too complex, require expensive software, or lack the simplicity needed for small-scale academic use. There is a clear need for a lightweight, efficient, and structured system that can handle campus-level course and records management without relying on heavy databases or graphical interfaces.

**CollegeBuddy (CCRM)** — Campus Course & Records Manager — is built to solve this problem by providing a Java-based terminal application that manages student records, course data, and enrollments in a simple, reliable, and scalable manner.

---

## Scope of the Project

The scope of CollegeBuddy CCRM includes:

- **Student Management**: Adding, viewing, and maintaining student records including personal and academic details.
- **Course Management**: Creating and managing course listings with relevant metadata.
- **Enrollment Handling**: Mapping students to courses and managing enrollment data.
- **Grade Assignment**: Recording and managing academic grades per student per course.
- **Data Import/Export**: Reading from and writing to CSV files for easy data portability.
- **Backup & Recovery**: Providing backup functionality to prevent data loss.
- **Reporting**: Generating structured academic reports through the CLI.

The project is scoped as a **command-line application** built in **Java**, running on **Windows 11**, and does not include a graphical user interface or external database integration in its current version.

---

## Target Users

CollegeBuddy CCRM is designed for the following user groups:

| User | Role |
|---|---|
| **College Administrators** | Manage student and course records across departments |
| **Faculty / Instructors** | Assign grades and view enrolled students |
| **Academic Coordinators** | Monitor enrollments and generate reports |
| **Students (View Access)** | Check their enrolled courses and grades |
| **Developers / Learners** | Study modular Java project structure and CLI application development |

---

## High-Level Features

1. **Student Record Management**
   - Add, view, and manage complete student profiles
   - Store student ID, name, department, and semester details

2. **Course Management**
   - Maintain a structured list of available courses
   - Associate courses with instructors and semesters

3. **Enrollment System**
   - Enroll students into courses
   - Track and manage enrollment status

4. **Grade Assignment**
   - Record and update grades for each student per course
   - Support multiple grade entries per semester

5. **CSV-Based Data Handling**
   - Import student and course data from `.csv` files
   - Export records for external use or reporting

6. **Backup Service**
   - Create backups of current records to prevent data loss

7. **Reports Module**
   - Generate academic summaries and structured output via CLI

8. **Modular Architecture**
   - Organized into packages: `domain`, `service`, `io`, `config`, `util`, and `cli`
   - Scalable and maintainable codebase designed for future enhancements

---

*Author: Eshaan Abrol | 24BEC10013 | Electronics and Communication Engineering | VIT Bhopal University*
