FROM ubuntu:20.04

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y software-properties-common build-essential cmake ninja-build libstdc++-10-dev

# gcc
RUN apt-get install -y gcc-10 g++-10 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10

# clang    
RUN apt-get install -y wget && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    apt-add-repository -y "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-12 main" && \
    apt-get update && apt-get install -y clang-12 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-12 10 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-12 10
    
ARG user_name="container_user"
RUN useradd -m $user_name

RUN mkdir -p /home/$user_name/libqrcode/src && chown $user_name:$user_name /home/$user_name/libqrcode/src && \
    mkdir -p /home/$user_name/libqrcode/bin && chown $user_name:$user_name /home/$user_name/libqrcode/bin
COPY --chown=$user_name:$user_name CMakeLists.txt /home/$user_name/libqrcode/src/
COPY --chown=$user_name:$user_name include/ /home/$user_name/libqrcode/src/include
COPY --chown=$user_name:$user_name test/ /home/$user_name/libqrcode/src/test

USER $user_name
WORKDIR /home/$user_name/libqrcode/bin
CMD [ "bash", "-c", "cmake -GNinja -DQRCODE_TESTS_ENABLED:BOOL=True -DCMAKE_CXX_COMPILER=clang -DCMAKE_C_COMPILER=clang ../src/ && ninja" ]