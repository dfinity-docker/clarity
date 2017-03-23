FROM ubuntu:trusty
MAINTAINER Enzo Haussecker <enzo@string.technology>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y \
    bison \
    build-essential \
    flex \
    python-dev \
    ragel \
    libgmp-dev \
    libssl-dev \
    wget \
    xz-utils
RUN apt-get clean

WORKDIR /tmp
ENV clang clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04
RUN wget http://releases.llvm.org/3.8.0/${clang}.tar.xz
RUN tar -xf ${clang}.tar.xz
RUN cp -r ${clang}/* /usr/local
RUN rm -r ${clang}*

WORKDIR /tmp
ENV pbc pbc-0.5.14
RUN wget https://crypto.stanford.edu/pbc/files/${pbc}.tar.gz
RUN tar -xf ${pbc}.tar.gz
WORKDIR /tmp/${pbc}
RUN sh configure
RUN make
RUN make install
WORKDIR /tmp
RUN rm -r ${pbc}*

WORKDIR /tmp
ENV go go1.8.linux-amd64
RUN wget https://storage.googleapis.com/golang/${go}.tar.gz
RUN tar -xf ${go}.tar.gz
RUN mv go /usr/local
RUN rm -r ${go}*

ENV GOROOT /usr/local/go
ENV GOPATH /workspace/go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin:/workspace/build/go/bin:/workspace/build/cpp/bin
ENV LD_LIBRARY_PATH /usr/local/lib:/workspace/build/cpp/lib
RUN echo 'export PS1='\''\[\e[0;93m\]developer\[\e[0;97m\]@\[\e[0;93m\]clarity\[\e[0;97m\]:\[\e[0;96m\]\W\[\e[m\e[0;93m\]$\[\e[m\] '\'' '>> /root/.bashrc

RUN mkdir /workspace
WORKDIR /workspace
