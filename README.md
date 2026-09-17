# CollegeBuddy - Campus Course & Records Manager

![Java](https://img.shields.io/badge/Java-17+-orange) ![Status](https://img.shields.io/badge/status-active-brightgreen)

A Java SE console application for managing student records, course enrollments, and academic grades.

## Features

| Feature | Description |
|---|---|
| Student Management | Create, list, deactivate, and search students |
| Course Management | Add, filter, and delete courses |
| Enrollment | Enroll students with credit limit enforcement |
| Grade Assignment | Assign VTU grades (S/A/B/C/D/E/F) |
| GPA Computation | Automatic weighted GPA calculation |
| Import/Export | CSV import/export for bulk operations |
| Backup | Timestamped directory backups |
| Reports | GPA rankings and summary statistics |

## Getting Started

`ash
chmod +x compile.sh
./compile.sh
`

## Project Structure

`
src/
  edu/ccrm/
    cli/          - Main CLI entry point
    config/       - Singleton DataStore
    domain/       - Entity classes (Student, Course, Enrollment, Grade)
    io/           - Import/Export and Backup services
    service/      - Business logic (StudentService, CourseService)
    util/         - Utilities and custom exceptions
`

## Author

**Eshaan Abrol** (24BEC10013) - Electronics and Communication Engineering
