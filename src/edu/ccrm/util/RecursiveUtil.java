package edu.ccrm.util;

import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.List;

/**
 * Utility class for recursive file system operations.
 */
public class RecursiveUtil {

    /** Recursively compute total size of directory in bytes. */
    public static long computeSize(Path root) throws IOException {
        final long[] total = {0};
        Files.walkFileTree(root, new SimpleFileVisitor<Path>(){
            @Override
            public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
                total[0] += attrs.size();
                return FileVisitResult.CONTINUE;
            }
        });
        return total[0];
    }

    /** Recursively list all files under a directory. */
    public static List<Path> listAllFiles(Path root) throws IOException {
        List<Path> result = new ArrayList<>();
        Files.walkFileTree(root, new SimpleFileVisitor<Path>(){
            @Override
            public FileVisitResult visitFile(Path file, BasicFileAttributes attrs){
                result.add(file);
                return FileVisitResult.CONTINUE;
            }
        });
        return result;
    }

    /** Count number of files recursively. */
    public static long countFiles(Path root) throws IOException {
        final long[] count = {0};
        Files.walkFileTree(root, new SimpleFileVisitor<Path>(){
            @Override
            public FileVisitResult visitFile(Path file, BasicFileAttributes attrs){
                count[0]++;
                return FileVisitResult.CONTINUE;
            }
        });
        return count[0];
    }
}
