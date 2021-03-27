project(native C CXX)
cmake_minimum_required(VERSION 3.5)

get_filename_component(TOPDIR ${CMAKE_CURRENT_SOURCE_DIR}/../ ABSOLUTE)
get_filename_component(CMAKEFULLPYTHON ${TOPDIR}/cmake-fullpython.cmake ABSOLUTE)


# setup build/install directories
set(INSTALLDIR ${CMAKE_CURRENT_SOURCE_DIR}/install)
get_filename_component(PYTHONSRC ${CMAKE_CURRENT_SOURCE_DIR}/python ABSOLUTE)
get_filename_component(CPYTHONSRC ${CMAKE_CURRENT_SOURCE_DIR}/cpython ABSOLUTE)

set(PYBIND11_INSTALL_DIR ${TOPDIR}/install/pybind11)

include(${CMAKEFULLPYTHON})
set(CMAKE_MODULE_PATH ${TOPDIR})
set(ENA_VIRTUALENV_DEV_MODE True)
set(REQUIREMENTS ${CMAKE_CURRENT_SOURCE_DIR}/requirements.txt)

# cmake_configure for python hook example variable
set(CMAKE_PYTHON_HOOK_TEST "HELLO-PYTHON-HOOK")

create_virtualenv(main ${PYBIND11_INSTALL_DIR}
	               ${REQUIREMENTS} 
		       cmakeHook.py
		       ${PYTHONSRC}
		       ${CPYTHONSRC}
		       ${INSTALLDIR}
		       ${ENA_VIRTUALENV_DEV_MODE})
