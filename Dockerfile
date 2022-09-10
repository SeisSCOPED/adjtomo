FROM ghcr.io/seisscoped/pysep

LABEL maintainer="Ian Wang"

RUN apt-get update --yes \
    && apt-get install -yq --no-install-recommends zlib1g-dev \
    && docker-clean

RUN cd /home/scoped \
    && git clone --branch devel https://github.com/adjtomo/seisflows \
    && git clone --branch devel https://github.com/adjtomo/pyatoa \
    && git clone --branch devel https://github.com/geodynamics/specfem3d \
    && git clone --branch devel https://github.com/geodynamics/specfem2d

RUN cd /home/scoped/pyatoa \
    && conda install --file requirements.txt \
    && pip install -e . \
    && docker-clean

RUN cd /home/scoped/seisflows \
    && conda install --file requirements.txt \
    && pip install -e . \
    && docker-clean

RUN cd /home/scoped/specfem2d \
    && ./configure FC=gfortran CC=gcc CXX=mpicxx MPIFC=mpif90 --with-mpi \
    && make all \
    && docker-clean

RUN cd /home/scoped/specfem3d \
    && ./configure FC=gfortran CC=gcc CXX=mpicxx MPIFC=mpif90 --with-mpi \
    && make all \
    && docker-clean
