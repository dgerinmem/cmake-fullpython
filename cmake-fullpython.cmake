cmake_minimum_required(VERSION 3.12)

macro(create_virtualenv name requirements env_file python_src_dir venv_dir ena_virtualenv_dev_mode)

find_package (Python COMPONENTS Interpreter Development)

set(PYTHON_MIN_VERS 3.5)
set(PIP_VERSION 20.3.4)
set(SETUPTOOLS_VERSION 39.0.1)
set(PYTHON_VERS ${Python_VERSION_MAJOR}.${Python_VERSION_MINOR})

# check if python exixts
if(NOT Python_FOUND)
    message(FATAL_ERROR "Could not find `python` in PATH")
else()
    message("Found python in system ${PYTHON_VERS}")
endif()

# check python version
if (NOT ${PYTHON_VERS} VERSION_GREATER_EQUAL ${PYTHON_MIN_VERS})
	message(FATAL_ERROR "Python version ${PYTHON_VERS} is not supported, the minimal required version is ${PYTHON_MIN_VERS}")
endif()

# use update alernative to install python 3.6 as /usr/bin/python
# in your sytem
# This install depends on your distribution
# It is probably not required for Ubuntu 18.04
# For ubuntu 16.04, you can use this procedure below :
# # python 3.6 is required in ubuntu Xenial 16.04
# sudo add-apt-repository ppa:deadsnakes/ppa
# sudo apt-get update
# sudo apt-get install python3.6
# sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 2

# use virtualenv from python package
set(VIRTUALENV ${Python_EXECUTABLE} -m venv)

set(VENV_BIN_DIR ${venv_dir}/venv-${name}/bin)
set(PYTHON_BIN ${venv_dir}/venv-${name}/bin/python)
set(PYTHON_PIP ${venv_dir}/venv-${name}/bin/pip)
set(PYTHON_LIB_DIR ${venv_dir}/venv-${name}/lib/python${PYTHON_VERS}/)
set(SITE_PACKAGES_DIR ${PYTHON_LIB_DIR}/site-packages)
set(EASY_INSTALL ${venv_dir}/venv-${name}/bin/easy_install)

# generate virtualenv
add_custom_target( gen-venv-${name} ALL
                   COMMAND cd ${venv_dir} && ${VIRTUALENV} venv-${name}
)

# WORKAROUND INTRALLING TENSORFFLOW > 1.11 has the side effect of removing
# EASY_INSTALL. This cause this script to fails the second time.
# So we check is EASY_INSTALL EXISTS before using it.

if(EXISTS ${EASY_INSTALL})
	# updating pip
	add_custom_target(pip-upgrade ALL
		COMMAND ${EASY_INSTALL} pip==${PIP_VERSION}
		DEPENDS gen-venv-${name}
	)
        # updating setuptools
	add_custom_target(setuptools-upgrade ALL
		COMMAND ${EASY_INSTALL} setuptools==${SETUPTOOLS_VERSION}
		DEPENDS pip-upgrade
	)
	# installing wheel package
	add_custom_target(wheel-install ALL
		COMMAND ${PYTHON_PIP}  install wheel
		DEPENDS setuptools-upgrade
	)
else()
	# installing wheel package
	add_custom_target(wheel-install ALL
		COMMAND ${PYTHON_PIP}  install wheel
		DEPENDS gen-venv-${name}
	)
endif()

## Build all pip packages ##
# each setup.py file found under ${python_src_dir}
# Here we fetch all the setup.py files that are present
# in python_src_dir. 
# Then, we build each setup.py and install (.whl) files
# into the virtualenv.

file(GLOB_RECURSE PIP_SETUP_SCRIPTS  ${python_src_dir}/*setup.py)
set(python_build "python-build-${name}")
set(python_install "python-install-${name}")
set(pythonlib_install "pythonlib-install-${name}")

# list to store each target builded in foreach PIP_SETUP_SCRIPTS
set(PIP_INSTALL_TARTETS "")

if (${ena_virtualenv_dev_mode})

# install in develop mode
foreach(SETUP ${PIP_SETUP_SCRIPTS})
	message("** found pip package installation " ${SETUP})
	get_filename_component(SETUP_DIR ${SETUP} DIRECTORY)
	message(WARNING " user must ensure, that cmake target build ed with absolute setup.py system PATH doesn't have have '/'")
	string(REPLACE "/" "-" SETUP_TARGET ${SETUP_DIR})

	add_custom_target("${python_build}${SETUP_TARGET}" ALL
                           COMMAND cd ${SETUP_DIR} && ${PYTHON_BIN} setup.py develop
                           DEPENDS gen-venv-${name} ${DEPS} ${README} wheel-install)
	list(APPEND PIP_INSTALL_TARTETS ${python_build}${SETUP_TARGET})
endforeach(SETUP)

else()

# install in source mode
foreach(SETUP ${PIP_SETUP_SCRIPTS})
	message("** found pip package installation " ${SETUP})
	get_filename_component(SETUP_DIR ${SETUP} DIRECTORY)
	message(WARNING " user must ensure, that cmake target build ed with absolute setup.py system PATH doesn't have have '/'")
	string(REPLACE "/" "-" SETUP_TARGET ${SETUP_DIR})

	# Note : User should consider using ${PYTHON_BIN} setup.py install [sdist bdist_wheel] / [develop] depending on requirements,
	#        [develop] is default mode
	add_custom_target("${python_build}${SETUP_TARGET}" ALL
                           COMMAND cd ${SETUP_DIR} && ${PYTHON_BIN} setup.py bdist_wheel
                           DEPENDS gen-venv-${name} ${DEPS} ${README} wheel-install)
        add_custom_target("${python_install}${SETUP_TARGET}" ALL
                           COMMAND cd ${SETUP_DIR} && ${PYTHON_PIP} install --no-deps --ignore-installed dist/*.whl
                           DEPENDS "${python_build}${SETUP_TARGET}")

        list(APPEND PIP_INSTALL_TARTETS ${python_install}${SETUP_TARGET})
endforeach(SETUP)

endif()


# vsora cpython package installation
# cpython package is a python module that has
# beed writen in C++, through PYBIND11 library
# This module consist of a .so library.
# This .so file must be installed into the 
# virtualenv site-package for binding purposes.

add_custom_target(install-venv-${name}-requirements ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${requirements}  requirements.txt
    COMMAND ${PYTHON_PIP} install -r ${requirements} --upgrade-strategy=only-if-needed
    DEPENDS ${PIP_INSTALL_TARTETS})

# VsoraCpython package must be provided whith FindVsoraCpython.cmake
#find_package(VsoraCpython)
#if(NOT VsoraCpython_FOUND)
#	message(FATAL_ERROR "Could not find `vsoraCpython`")
#endif()

#add_custom_target(${pythonlib_install} ALL
#	COMMAND ${CMAKE_COMMAND} -E copy ${VSORA_CPYTHON_INSTALL_DIR}/*.so ${SITE_PACKAGES_DIR}
#	DEPENDS install-venv-${name}-requirements)
#
## env_file contains environement informations
## here we configure and install env_file into
## vsora package dir as a python module.
## vsora/__init__.py file import env_file 
## module while starting up to get all the 
## necessary env variables into the vsora namespace
#configure_file (${env_file} env_file.conf)
#
#add_custom_target(env-file-install ALL
#	COMMAND ${CMAKE_COMMAND} -E copy env_file.conf ${SITE_PACKAGES_DIR}/vsora_environ.py
#	DEPENDS ${pythonlib_install})

endmacro()
