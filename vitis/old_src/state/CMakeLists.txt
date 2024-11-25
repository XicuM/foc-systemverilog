macro(SUBDIRLIST result curdir)
    file(GLOB children RELATIVE ${curdir} ${curdir}/*)
    set(dirlist "")
    foreach(child ${children})
        if(IS_DIRECTORY ${curdir}/${child})
            LIST(APPEND dirlist ${child})
        endif()
    endforeach()
    set(${result} ${dirlist})
endmacro()

subdirlist(SUBDIRS ${CMAKE_CURRENT_LIST_DIR})
foreach(subdir ${SUBDIRS})
    if(NOT ${subdir} STREQUAL ".git")
        add_subdirectory(${subdir})
    endif()
endforeach()

target_sources(library PRIVATE          
	${CMAKE_CURRENT_LIST_DIR}/state.hpp
	${CMAKE_CURRENT_LIST_DIR}/state.cpp
)