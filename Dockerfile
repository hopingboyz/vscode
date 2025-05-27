# Use official Ubuntu 22.04 base image
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    git \
    curl \
    vim \
    sudo \
    locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install Jupyter and data science packages
RUN pip3 install --no-cache-dir \
    notebook \
    jupyterlab \
    numpy \
    pandas \
    matplotlib \
    seaborn \
    scikit-learn \
    scipy \
    ipywidgets \
    tqdm \
    requests \
    plotly \
    sympy

# Create a persistent working directory inside the container
RUN mkdir -p /root/notebooks
WORKDIR /root/notebooks

# Expose Jupyter port
EXPOSE 8888

# Start Jupyter Notebook as root without token/password
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
