project(native C CXX)
cmake_minimum_required(VERSION 3.5)

get_filename_component(TOPDIR ${CMAKE_CURRENT_SOURCE_DIR}/../ ABSOLUTE)
get_filename_component(CMAKEFULLPYTHON ${TOPDIR}/cmake-fullpython.cmake ABSOLUTE)

# cmake_configure for python hook example variable
set(CMAKE_PYTHON_HOOK_TEST "HELLO-PYTHON-HOOK")

# setup build/install directories
set(INSTALLDIR ${CMAKE_CURRENT_SOURCE_DIR}/install )
set(PYTHONSRC ${CMAKE_CURRENT_SOURCE_DIR}/python )

include(${CMAKEFULLPYTHON})
set(CMAKE_MODULE_PATH ${TOPDIR})
set(ENA_VIRTUALENV_DEV_MODE True)
set(REQUIREMENTS ${CMAKE_CURRENT_SOURCE_DIR}/requirements.txt)
create_virtualenv(main ${REQUIREMENTS} 
		       cmake-hook.py
		       ${PYTHONSRC}
		       ${INSTALLDIR}
		       ${ENA_VIRTUALENV_DEV_MODE})
