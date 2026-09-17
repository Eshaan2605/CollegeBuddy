# Campus Course & Records Manager (AcadSync)

A Java-based terminal application designed to efficiently manage student records and course data within a campus environment. This project provides a structured and scalable way to handle academic information such as student details, course listings, and enrollments.

---

## Overview

Campus Course & Records Manager (AcadSync) is a lightweight academic management system built using Java. It is designed to simulate how universities manage student-course relationships using structured data and modular programming.

The system allows users to:
- Store and manage student records
- Maintain course information
- Handle structured academic datasets using CSV files
- Execute operations via a command-line interface

---

## Tech Stack

- Language: Java  
- Build Tool: Shell Script (`compile.sh`)  
- IDE Support: VS Code (with launch configurations)  
- Data Storage: CSV Files  
- Platform: macOS / Linux terminal-based execution  

---

## Project Structure

```
AcadSync/
│
├── src/edu/ccrm/          # Core Java source files
├── sample-data/           # Sample CSV datasets
│   ├── students.csv
│   └── courses.csv
│
├── .vscode/               # VS Code configurations (launch/tasks)
├── compile.sh             # Script to compile all Java files
├── sources.txt            # Source file references
├── README.md              # Project documentation
└── USAGE.md               # Additional usage instructions
```

---

## Features

- Student Record Management  
  Add, view, and manage student information efficiently  

- Course Management  
  Maintain course listings with structured data  

- Data Handling via CSV  
  Uses CSV files for easy readability and modification  

- Command-Line Interface  
  Lightweight and fast execution without GUI overhead  

- Modular Code Structure  
  Organized packages for scalability and maintainability  

---

## Sample Data

The project includes preloaded datasets:

- `students.csv` contains student records  
- `courses.csv` contains course details  

You can modify or expand these files to test different scenarios.

---

## How to Run

### 1. Open Terminal

Navigate to the project directory:

```bash
cd ~/Projects/CCRM_complete
```

### 2. Make Script Executable

```bash
chmod +x compile.sh
```

### 3. Compile the Project

```bash
./compile.sh
```

### 4. Run the Application

```bash
java -cp out edu.ccrm.cli.Main
```

---

## Working Concept

The system follows a structured approach:

1. Reads data from CSV files  
2. Processes records using Java classes  
3. Provides CLI-based interaction  
4. Outputs structured results  

This simulates a basic academic database system without requiring external dependencies.

---

## Use Cases

- Academic mini-projects  
- Understanding file-based data handling in Java  
- Learning modular project structuring  
- Practicing CLI-based application development  

---

## Future Improvements

- Add GUI using JavaFX or Swing  
- Integrate database (MySQL / PostgreSQL)  
- Implement authentication system  
- Add REST API support  
- Deploy as a web-based application  

---

## Author

Eshaan Abrol  
24BEC10013  
Electronics and Communication Engineering  
VIT Bhopal University  

---

## License

This project is for educational purposes and can be freely used or modified.

---

## Support

If you found this project helpful, consider giving it a star on GitHub.
