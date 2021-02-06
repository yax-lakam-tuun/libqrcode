FROM ubuntu:20.04

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y build-essential cmake ninja-build gcc-10 g++-10 libstdc++-10-dev && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10

ARG user_name="container_user"
RUN useradd -m $user_name

RUN mkdir -p /home/$user_name/libqrcode/src && chown $user_name:$user_name /home/$user_name/libqrcode/src && \
    mkdir -p /home/$user_name/libqrcode/bin && chown $user_name:$user_name /home/$user_name/libqrcode/bin
COPY --chown=$user_name:$user_name CMakeLists.txt /home/$user_name/libqrcode/src/
COPY --chown=$user_name:$user_name include/ /home/$user_name/libqrcode/src/include
COPY --chown=$user_name:$user_name test/ /home/$user_name/libqrcode/src/test

USER $user_name
WORKDIR /home/$user_name/libqrcode/bin
CMD [ "bash", "-c", "cmake -GNinja -DQRCODE_TESTS_ENABLED:BOOL=True ../src/ && ninja" ]