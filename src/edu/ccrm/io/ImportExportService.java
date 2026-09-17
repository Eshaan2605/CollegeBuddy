package edu.ccrm.io;

import edu.ccrm.config.DataStore;
import edu.ccrm.domain.*;
import java.nio.file.*;
import java.io.IOException;
import java.util.*;
import java.util.stream.*;

/**
 * Minimal CSV import/export using NIO and Streams
 */
public class ImportExportService {
    private final DataStore ds = DataStore.getInstance();

    public void importStudents(Path csv) throws IOException {
        try(Stream<String> lines = Files.lines(csv)){
            List<String> data = lines.skip(1).collect(Collectors.toList());
            for(String ln: data){
                String[] parts = ln.split(",");
                if(parts.length<4) continue;
                String id = parts[0].trim();
                String regNo = parts[1].trim();
                String name = parts[2].trim();
                String email = parts[3].trim();
                ds.getStudents().put(id, new Student(id, name, email));
            }
        }
    }

    public void importCourses(Path csv) throws IOException {
        try(Stream<String> lines = Files.lines(csv)){
            List<String> data = lines.skip(1).collect(Collectors.toList());
            for(String ln: data){
                String[] p = ln.split(",");
                if(p.length<6) continue;
                String code = p[0].trim();
                String title = p[1].trim();
                int credits = Integer.parseInt(p[2].trim());
                String instructor = p[3].trim();
                Semester sem = Semester.valueOf(p[4].trim());
                String dept = p[5].trim();
                Course c = new Course.Builder(code).title(title).credits(credits).instructor(instructor).semester(sem).department(dept).build();
                ds.getCourses().put(code, c);
            }
        }
    }

    public void exportAll(Path outDir) throws IOException {
        Files.createDirectories(outDir);
        Path s = outDir.resolve("students_export.csv");
        try(Stream<String> lines = ds.getStudents().values().stream().map(st -> String.join(",", st.getId(), st.getFullName(), st.getEmail(), String.valueOf(st.getStatus())))){
            Files.write(s, (Iterable<String>)lines::iterator);
        }
        Path c = outDir.resolve("courses_export.csv");
        try(Stream<String> lines = ds.getCourses().values().stream().map(co -> String.join(",", co.getCode(), co.getTitle(), String.valueOf(co.getCredits()), co.getInstructor(), co.getSemester().toString(), co.getDepartment()))){
            Files.write(c, (Iterable<String>)lines::iterator);
        }
    }
}
