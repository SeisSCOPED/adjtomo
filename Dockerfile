FROM ghcr.io/seisscoped/container-base

LABEL maintainer="Ian Wang"

RUN cd cd /home/scoped \
    && git clone --branch devel https://github.com/adjtomo/seisflows \
    && git clone --branch devel https://github.com/adjtomo/pyatoa

RUN cd pyatoa \
    && conda install --file requirements.txt \
    && pip install -e . \
    && docker-clean

RUN cd ../../../seisflows \
    && conda install --file requirements.txt \
    && pip install -e . \
    && docker-clean
