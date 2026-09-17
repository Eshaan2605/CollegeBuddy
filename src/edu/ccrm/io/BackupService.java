package edu.ccrm.io;

import java.nio.file.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;
import edu.ccrm.util.RecursiveUtil;

/**
 * Handles directory backup operations with timestamped snapshots.
 */
public class BackupService {
    private final Path base;
    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss");

    public BackupService(Path base) throws IOException {
        this.base = base;
        Files.createDirectories(base);
    }

    public Path backupDirectory(Path sourceDir) throws IOException {
        String ts = LocalDateTime.now().format(FMT);
        Path target = base.resolve("backup_" + ts);
        Files.createDirectories(target);
        Files.walk(sourceDir).forEach(p -> {
            try {
                Path rel = sourceDir.relativize(p);
                Path dest = target.resolve(rel);
                if(Files.isDirectory(p)) Files.createDirectories(dest);
                else Files.copy(p, dest, StandardCopyOption.REPLACE_EXISTING);
            } catch(Exception e){ throw new RuntimeException(e); }
        });
        return target;
    }

    public long computeBackupSize(Path backupDir) throws IOException {
        return RecursiveUtil.computeSize(backupDir);
    }

    public List<Path> listBackups() throws IOException {
        if(!Files.exists(base)) return List.of();
        return Files.list(base)
            .filter(Files::isDirectory)
            .filter(p -> p.getFileName().toString().startsWith("backup_"))
            .sorted()
            .collect(Collectors.toList());
    }

    public void deleteOldestBackup() throws IOException {
        List<Path> backups = listBackups();
        if(!backups.isEmpty()) {
            deleteRecursively(backups.get(0));
        }
    }

    private void deleteRecursively(Path dir) throws IOException {
        Files.walk(dir).sorted(Comparator.reverseOrder())
            .forEach(p -> { try{ Files.delete(p); } catch(Exception e){ throw new RuntimeException(e); } });
    }
}
