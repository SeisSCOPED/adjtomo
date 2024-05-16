FROM ghcr.io/seisscoped/pysep

LABEL maintainer="Ian Wang"

RUN apt-get update --yes \
    && apt-get install -yq --no-install-recommends zlib1g-dev \
    && docker-clean

RUN cd /home/scoped \
    && git clone https://github.com/adjtomo/adjdocs \
    && git clone --branch devel https://github.com/adjtomo/seisflows \
    && git clone --branch devel https://github.com/adjtomo/pyatoa \
    && git clone --branch devel --depth=1 https://github.com/specfem/specfem2d \
    && git clone --branch devel --depth=1 https://github.com/specfem/specfem3d

RUN cd /home/scoped/pyatoa \
    && conda env update -f environment.yml -n base \
    && docker-clean

RUN cd /home/scoped/seisflows \
    && conda env update -f environment.yml -n base \
    && docker-clean

ADD scripts/clean_specfem2d_repo.sh /home/scoped/clean_specfem2d_repo.sh 
ADD scripts/clean_specfem3d_repo.sh /home/scoped/clean_specfem3d_repo.sh

# Workaround to use gfortran with intel mpi (not a good engineering practice)
# Thanks to @mnagaso for this code bit
RUN mv /opt/intel/compilers_and_libraries/linux/mpi/intel64/include/mpi.mod \
	   /opt/intel/compilers_and_libraries/linux/mpi/intel64/include/mpi.modbak \
   && ln -s /opt/intel/compilers_and_libraries/linux/mpi/intel64/include/gfortran/9.1.0/mpi.mod \
	  /opt/intel/compilers_and_libraries/linux/mpi/intel64/include

RUN cd /home/scoped/specfem2d \
    && ./configure FC=gfortran CC=gcc CXX=mpicxx MPIFC=mpif90 --with-mpi \
    && make all \
    && bash /home/scoped/clean_specfem2d_repo.sh \
    && rm /home/scoped/clean_specfem2d_repo.sh \
    && docker-clean

RUN cd /home/scoped/specfem3d \
    && ./configure FC=gfortran CC=gcc CXX=mpicxx MPIFC=mpif90 --with-mpi FCFLAGS='-fno-range-check' \
    && make all \
    && bash /home/scoped/clean_specfem3d_repo.sh \
    && rm /home/scoped/clean_specfem3d_repo.sh \
    && docker-clean
