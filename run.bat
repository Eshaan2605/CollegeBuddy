@echo off
echo Compiling CollegeBuddy...
if exist out rmdir /s /q out
mkdir out
for /r src %%f in (*.java) do javac -d out "%%f"
echo Running CollegeBuddy...
java -cp out edu.ccrm.cli.Main
