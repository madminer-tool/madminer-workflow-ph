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
Since Mac OS El Capitan (2015), all macOS devices have a System Integrity Protection
([SIP][sip-docs]) activated by default. It protect users to modify certain parts of
the OS environment. Follow [this guide][sip-guide] to disable it.

Once it is disabled, the easiest way to download and compile ROOT is to use `brew`.
The compilation process will take around 45 minutes. Once it has finished, `brew` would 
have installed ROOT at `/usr/local/Cellar/root`.

#### 1.2 Linux
For Linux distributions the installation of ROOT is more manual. Follow [this guide][root-guide] 
on how to download and compile ROOT locally.


### 2. Setup environment
To setup the environment for ROOT, multiple variables need to be defined. These variables 
will be useful later on in the process as they will tell _Madgraph 5_ packages where to 
find _ROOT_ in your local system.

#### 1.1 Mac OS
Modify your Shell source file (`.bashrc` / `.zshrc` / ...) and add:

```shell script
export ROOTSYS="/usr/local/Cellar/root"
export PATH="$ROOTSYS/bin:$PATH"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ROOTSYS/lib"
export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$ROOTSYS/lib"
```

#### 1.2 Linux
Modify your Shell source file (`.bashrc` / `.zshrc` / ...) and add:

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
mkdir software
cd software
curl -sSL "https://launchpad.net/mg5amcnlo/2.0/2.6.x/+download/MG5_aMC_v2.6.7.tar.gz" | tar -xzv
```


### 4. Install Pythia and Delphes
Finally, _Pythia_ and _Delphes_ are installed using MadGraph 5 as some sort of _"package manager"_.
Bare in mind, however, that they need another package to be installed first: `lhapdf6`.

```shell script
echo "install lhapdf6" | python2 software/MG5_aMC_v2_6_7/bin/mg5_aMC
echo "install pythia8" | python2 software/MG5_aMC_v2_6_7/bin/mg5_aMC
echo "install Delphes" | python2 software/MG5_aMC_v2_6_7/bin/mg5_aMC
```


[delphes-website]: https://cp3.irmp.ucl.ac.be/projects/delphes
[madgraph-website]: https://launchpad.net/mg5amcnlo
[pythia-website]: http://home.thep.lu.se/Pythia/
[sip-docs]: https://en.wikipedia.org/wiki/System_Integrity_Protection
[sip-guide]: https://ss64.com/osx/csrutil.html
[root-guide]: https://root.cern.ch/building-root#quick-start
[root-website]: https://root.cern.ch/
