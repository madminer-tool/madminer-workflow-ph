#### Base image
#### Reference: https://github.com/root-project/root-docker/blob/master/ubuntu/Dockerfile
FROM rootproject/root:6.24.00-ubuntu20.04


#### Install binary dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        wget \
        rsync \
        gfortran \
        build-essential \
        ca-certificates \
        libboost-all-dev \
        python3-pip \
        zip \
        unzip


#### Define working folders
ENV PROJECT_FOLDER "/madminer"
ENV SOFTWARE_FOLDER "/madminer/software"


#### Copy files
COPY code ${PROJECT_FOLDER}/code
COPY scripts ${PROJECT_FOLDER}/scripts
COPY requirements.txt ${PROJECT_FOLDER}

# Install Python3 dependencies
RUN python3 -m pip install --no-cache-dir --upgrade pip && \
    python3 -m pip install --no-cache-dir --requirement ${PROJECT_FOLDER}/requirements.txt


#### MadGraph 5 environment variables
ENV MG_VERSION "MG5_aMC_v2.9.4"
ENV MG_FOLDER "MG5_aMC_v2_9_4"
ENV MG_FOLDER_PATH "${SOFTWARE_FOLDER}/${MG_FOLDER}"
ENV MG_BINARY_PATH "${SOFTWARE_FOLDER}/${MG_FOLDER}/bin/mg5_aMC"

#### CERN ROOT environment variables
ENV PATH $PATH:$ROOTSYS/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$ROOTSYS/lib


#### Install MadGraph 5
RUN mkdir -p ${SOFTWARE_FOLDER} && true \
    | curl -sSL "https://launchpad.net/mg5amcnlo/2.0/2.9.x/+download/${MG_VERSION}.tar.gz" \
    | tar -xz -C ${SOFTWARE_FOLDER}


#### Install Pythia8
ENV PYTHIA_VERSION "8244"
RUN echo "n" | python3 ${MG_BINARY_PATH}
RUN cd ${SOFTWARE_FOLDER} &&\
    wget --quiet "https://pythia.org/download/pythia${PYTHIA_VERSION:0:2}/pythia${PYTHIA_VERSION}.tgz" && \
    echo "install pythia8 --pythia8_tarball=${SOFTWARE_FOLDER}/pythia${PYTHIA_VERSION}.tgz" | python3 ${MG_BINARY_PATH} &&\
    rm -rf ${SOFTWARE_FOLDER}/pythia${PYTHIA_VERSION}.tgz

#The command below installs by default latest Pythia8
#RUN echo "install pythia8" | python3 ${MG_BINARY_PATH}

#### Install Delphes
RUN echo "install Delphes" | python3 ${MG_BINARY_PATH}

# Turn ON Python2 -> Python3 models conversion
RUN echo "set auto_convert_model T" | python3 ${MG_BINARY_PATH}
RUN echo "import model EWdim6-full" | python3 ${MG_BINARY_PATH}

# Delphes environment variables
ENV ROOT_INCLUDE_PATH "${ROOT_INCLUDE_PATH}:${MG_FOLDER_PATH}/Delphes/external"


#### Set working directory
WORKDIR ${PROJECT_FOLDER}
