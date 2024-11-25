# cmake_minimum_required(VERSION 3.10)
# project(Inverter VERSION 1.0)

# add_executable(${PROJECT_NAME} 
#     main.cpp
#     regs.cpp
#     state.cpp
#     terminal.cpp
#     utils.cpp
#     xilinx.cpp
# )

# set(THREADS_PREFER_PTHREAD_FLAG ON)
# find_package(Threads REQUIRED)
# target_link_libraries(${PROJECT_NAME} PRIVATE Threads::Threads)

# TODO: Estudiar CMakeLists.txt (probar en un proyecto nuevo)

cmake_minimum_required(VERSION 3.10)
project(inverter LANGUAGES CXX)

add_executable(${PROJECT_NAME} 
    main.cpp
    regs.cpp
    utils.cpp
    xilinx.cpp
    terminal.cpp
)

add_library(library)

# Add google test
# include(FetchContent)
# FetchContent_Declare(
#   googletest
#   URL https://github.com/google/googletest/archive/609281088cfefc76f9d0ce82e1ff6c30cc3591e5.zip
# )

# Add all directories
macro(SUBDIRLIST result curdir)
    file(GLOB children RELATIVE ${curdir} ${curdir}/*)
    set(dirlist "")
    foreach(child ${children})
        if(IS_DIRECTORY ${curdir}/${child})
            list(APPEND dirlist ${child})
        endif()
    endforeach()
    set(${result} ${dirlist})
endmacro()

subdirlist(SUBDIRS ${CMAKE_CURRENT_LIST_DIR})
foreach(subdir ${SUBDIRS})
    if((NOT ${subdir} STREQUAL ".git") AND (NOT ${subdir} STREQUAL "build"))
        add_subdirectory(${subdir})
    endif()
endforeach()

# Include multithreading capabilities
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE Threads::Threads)

target_include_directories(library PUBLIC ${CMAKE_CURRENT_LIST_DIR})

# 