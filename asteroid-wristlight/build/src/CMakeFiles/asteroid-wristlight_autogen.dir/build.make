# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.28

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/oecore-x86_64/sysroots/x86_64-oesdk-linux/usr/bin/cmake

# The command to remove a file.
RM = /usr/local/oecore-x86_64/sysroots/x86_64-oesdk-linux/usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/profilenameisok/asteroid-wristlight

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/profilenameisok/asteroid-wristlight/build

# Utility rule file for asteroid-wristlight_autogen.

# Include any custom commands dependencies for this target.
include src/CMakeFiles/asteroid-wristlight_autogen.dir/compiler_depend.make

# Include the progress variables for this target.
include src/CMakeFiles/asteroid-wristlight_autogen.dir/progress.make

src/CMakeFiles/asteroid-wristlight_autogen: src/asteroid-wristlight_autogen/timestamp

src/asteroid-wristlight_autogen/timestamp: /usr/local/oecore-x86_64/sysroots/x86_64-oesdk-linux/usr/bin/moc
src/asteroid-wristlight_autogen/timestamp: src/CMakeFiles/asteroid-wristlight_autogen.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/home/profilenameisok/asteroid-wristlight/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Automatic MOC for target asteroid-wristlight"
	cd /home/profilenameisok/asteroid-wristlight/build/src && /usr/local/oecore-x86_64/sysroots/x86_64-oesdk-linux/usr/bin/cmake -E cmake_autogen /home/profilenameisok/asteroid-wristlight/build/src/CMakeFiles/asteroid-wristlight_autogen.dir/AutogenInfo.json ""
	cd /home/profilenameisok/asteroid-wristlight/build/src && /usr/local/oecore-x86_64/sysroots/x86_64-oesdk-linux/usr/bin/cmake -E touch /home/profilenameisok/asteroid-wristlight/build/src/asteroid-wristlight_autogen/timestamp

asteroid-wristlight_autogen: src/CMakeFiles/asteroid-wristlight_autogen
asteroid-wristlight_autogen: src/asteroid-wristlight_autogen/timestamp
asteroid-wristlight_autogen: src/CMakeFiles/asteroid-wristlight_autogen.dir/build.make
.PHONY : asteroid-wristlight_autogen

# Rule to build all files generated by this target.
src/CMakeFiles/asteroid-wristlight_autogen.dir/build: asteroid-wristlight_autogen
.PHONY : src/CMakeFiles/asteroid-wristlight_autogen.dir/build

src/CMakeFiles/asteroid-wristlight_autogen.dir/clean:
	cd /home/profilenameisok/asteroid-wristlight/build/src && $(CMAKE_COMMAND) -P CMakeFiles/asteroid-wristlight_autogen.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/asteroid-wristlight_autogen.dir/clean

src/CMakeFiles/asteroid-wristlight_autogen.dir/depend:
	cd /home/profilenameisok/asteroid-wristlight/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/profilenameisok/asteroid-wristlight /home/profilenameisok/asteroid-wristlight/src /home/profilenameisok/asteroid-wristlight/build /home/profilenameisok/asteroid-wristlight/build/src /home/profilenameisok/asteroid-wristlight/build/src/CMakeFiles/asteroid-wristlight_autogen.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : src/CMakeFiles/asteroid-wristlight_autogen.dir/depend

