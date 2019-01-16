FROM debian:latest

# Install necessary linux packages from apt-get
RUN apt-get update --fix-missing && apt-get install -y eatmydata

RUN eatmydata apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git \
    libfreetype6-dev \
    swig \
    mpich \
    pkg-config \
    gcc \
    wget \
    curl \
    vim \
    nano

# Install anaconda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

# Setup anaconda path
ENV PATH /opt/conda/bin:$PATH

# Install gcc to make it work with brainiak
RUN ["/bin/bash", "-c", "conda install -y gcc"]

# update setuptools
RUN conda update setuptools

# install jupyter lab
RUN conda install -c conda-forge jupyterlab

# Install packages needed
RUN pip install --upgrade git+https://github.com/IntelPNI/brainiak \
    hypertools \
    seaborn \
    scikit-learn \
    ffmpeg \
    scipy

# add some useful directories as mirrors of directors in the same location on your computer
ADD data /data
ADD code /code
ADD figs /figs

# Finally, expose a port from within the docker so we can use it to run
# jupyter notebooks
EXPOSE 9999
