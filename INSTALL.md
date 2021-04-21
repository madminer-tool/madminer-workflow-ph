# Local installation guide


## About
This installation guide covers what are the necessary requirements for executing 
individual steps of the physics workflow without the need of Docker.


## Requirements
To have a local environment able of generating and _showering_ events, there are multiple
requirements that we need to have installed and setup in our system.

In terms of software:
- [ROOT][root-website] downloaded and compiled.
- [MadGraph 5][madgraph-website] installed.
- [Pythia 8][pythia-website] installed.
- [Delphes][delphes-website] installed.
- [A generation model][madgraph-models] installed.
- [Numpy F2PY][numpy-f2py] installed.

In terms of environment:
- `ROOTSYS` environment var defined.
- `PATH` environment var updated with ROOT binaries path.
- `LD_LIBRARY_PATH` environment var defined.
- `DYLD_LIBRARY_PATH` environment var defined.


## Installation
This guide covers the installation of _ROOT_ and its environment variables in a distinct
way for macOS and linux distributions. Once it is correctly set up, the installation of
_MadGraph 5_, _Pythia 8_ and _Delphes_ is the same in both architectures.


### 1. Install ROOT

#### 1.1 Mac OS
Since macOS El Capitan (2015), all macOS devices have a System Integrity Protection
([SIP][sip-docs]) activated by default. It protects users to modify certain parts of
the OS environment. Follow [this guide][sip-guide] to disable it.

Once it is disabled, install ROOT:
```shell script
brew install root
```

The compilation process take around 45 minutes. Once it has finished, `brew` would 
have installed ROOT at `/usr/local/Cellar/root`.

#### 1.2 Linux
For Linux distributions the installation of ROOT is more manual. Follow [this guide][root-guide] 
on how to download and compile ROOT locally.


### 2. Setup environment
To set up the environment for ROOT, multiple variables need to be defined. These variables 
will be useful later on in the process as they will tell _Madgraph 5_ packages where to 
find _ROOT_ in your local system.

#### 2.1 Mac OS
Modify your shell source file (`.bashrc` / `.zshrc` / ...) and add:

```shell script
export ROOTSYS="/usr/local/Cellar/root"
export PATH="$ROOTSYS/bin:$PATH"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ROOTSYS/lib"
export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$ROOTSYS/lib"
```

#### 2.2 Linux
Modify your shell source file (`.bashrc` / `.zshrc` / ...) and add:

```shell script
export ROOTSYS=<path_to_root_folder>
export PATH="$ROOTSYS/bin:$PATH"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ROOTSYS/lib"
export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$ROOTSYS/lib"
```


### 3. Install MadGraph 5
MadGraph is a software tool to install other packages. It can be downloaded to any path of
the local system, although it is recommended to have it in a folder called `software` at
the root folder of this project.

To download MadGraph 5:

```shell script
mkdir -p software
curl -sSL "https://launchpad.net/mg5amcnlo/2.0/2.9.x/+download/MG5_aMC_v2.9.3.tar.gz" | tar -xz -C software
```


### 4. Install Pythia and Delphes
_Pythia_ and _Delphes_ are installed using MadGraph 5 as some sort of _"package manager"_.
Bear in mind, however, MadGraph asks for an upgrade the first time you launch it.

```shell script
# For macOS 11.0+ systems
export SYSTEM_VERSION_COMPAT=1

echo "install pythia8" | python3 software/MG5_aMC_v2_9_3/bin/mg5_aMC
echo "install Delphes" | python3 software/MG5_aMC_v2_9_3/bin/mg5_aMC
```


### 5. Import generation model
When running MadGraph 5, there are several generative models than could be imported.
The one specified in both the _signal_ and _background_ process cards is called
[_Weak boson effective field theory_][madgraph-model].

This model was originally defined in Python2, so it needs to be converted to Python3.
Thankfully, there is a MadGraph option to automatically convert old models to Python3:
`auto_convert_model`.

```shell script
echo "set auto_convert_model T" | python3 software/MG5_aMC_v2_9_3/bin/mg5_aMC
echo "import model EWdim6-full" | python3 software/MG5_aMC_v2_9_3/bin/mg5_aMC
```


### 6. Install Numpy
Finally, as some MadGraph packages use _Fortran_ code internally, an additional binary 
need to be installed. The binary is used to create _Fortran_ to Python interfaces,
it is called `f2py`, and it is distributed by [Numpy][numpy-website].

Given that MadMiner already installs Numpy, there is nothing to do.


[delphes-website]: https://cp3.irmp.ucl.ac.be/projects/delphes
[madgraph-website]: https://launchpad.net/mg5amcnlo
[madgraph-model]: https://cp3.irmp.ucl.ac.be/projects/madgraph/wiki/Models/EWdim6
[madgraph-models]: https://cp3.irmp.ucl.ac.be/projects/madgraph/wiki/Models
[numpy-f2py]: https://numpy.org/doc/stable/f2py/index.html
[numpy-website]: https://numpy.org/
[pythia-website]: http://home.thep.lu.se/Pythia/
[sip-docs]: https://en.wikipedia.org/wiki/System_Integrity_Protection
[sip-guide]: https://ss64.com/osx/csrutil.html
[root-guide]: https://root.cern/install/build_from_source/#quick-start
[root-website]: https://root.cern.ch/
