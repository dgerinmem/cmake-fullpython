# Problem to solve

The main objective of cmake-fullpython.cmake is
to provide a frame to helps developers to adress software
fragmentation problem in projects that requires
a cmake downstream python integration.

# Proposed solution

cmake-fullpython.cmake probides a python executable
that belongs to the folowing diagram.

 |-----------------------------------------|
 |                                         |
 |         upstream cmake project          |
 |                                         |
 |-----------------------------------------|
 |                                         |
 |    pybind11     python3    virtualenv   | 
 |                                         |
 |-----------------------------------------|
 |                                         |  ----------------------------------
 |                                         |      |                             |
 |                                         |      |                             |
 |                                         |   [PYBIND11 .so CPP API]     [cmakeHook.py] (upstram CMAKE variables)
 |					   |      |                    	        |
 |					   |      |                    	        |
 |					   |      |                    	        |
 |         cmake-fullpython.cmake          |  -------------------------------------------> [venv/bin/python]
 |                                         |                                               | ../site-packages/pipPackages..
 |                                         |                                                                 /...     
 |-----------------------------------------|
 


# Usage

- Clone this repository:

```bash
git clone https://github.com/Dimitri1/cmake-fullpython
```

- Configure system:

```bash
configure.sh
```

- Launch tests

```bash
test.sh
```


## Authors

- Dimitri Gerin <dimitri.gerin@gmail.com>
