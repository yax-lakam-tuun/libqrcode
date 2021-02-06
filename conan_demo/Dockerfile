FROM ubuntu:20.04

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y build-essential cmake ninja-build gcc-10 g++-10 libstdc++-10-dev && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10 && \
    apt-get install -y python3-pip && pip3 install conan

ARG user_name="container_user"
RUN useradd -m $user_name 

# library
RUN mkdir -p /home/$user_name/libqrcode/library && chown $user_name:$user_name /home/$user_name/libqrcode/library
COPY --chown=$user_name:$user_name CMakeLists.txt /home/$user_name/libqrcode/library/
COPY --chown=$user_name:$user_name conanfile.py /home/$user_name/libqrcode/library/
COPY --chown=$user_name:$user_name include/ /home/$user_name/libqrcode/library/include

# conan demo
RUN mkdir -p /home/$user_name/libqrcode/demo/src && chown $user_name:$user_name /home/$user_name/libqrcode/demo/src && \
    mkdir -p /home/$user_name/libqrcode/demo/bin && chown $user_name:$user_name /home/$user_name/libqrcode/demo/bin
COPY --chown=$user_name:$user_name demo/ /home/$user_name/libqrcode/demo/src

USER $user_name
WORKDIR /home/$user_name/libqrcode/demo/bin
RUN conan create ../../library demo/test && \
    conan install ../src && \
    cmake -GNinja ../src && \
    ninja

ENTRYPOINT [ "./demo" ]