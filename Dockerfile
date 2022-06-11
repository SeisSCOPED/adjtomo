FROM ghcr.io/seisscoped/container-base

LABEL maintainer="Ian Wang"

RUN cd /home/scoped \
    && git clone --branch devel https://github.com/adjtomo/seisflows \
    && git clone --branch devel https://github.com/adjtomo/pyatoa

RUN cd /home/scoped/pyatoa \
    && conda install --file requirements.txt \
    && pip install -e . \
    && docker-clean

RUN cd /home/scoped/seisflows \
    && conda install --file requirements.txt \
    && pip install -e . \
    && docker-clean
