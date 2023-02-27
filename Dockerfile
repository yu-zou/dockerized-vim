# Install vim
FROM alpine:3.8 as builder

WORKDIR /tmp

RUN apk add --no-cache \
    build-base \
    git \
    libx11-dev \
    libxpm-dev \
    libxt-dev \
    make \
    ncurses-dev \
    python3 \
    python3-dev \
    perl-dev

RUN git clone https://github.com/vim/vim && cd vim \
    && ./configure \
    --disable-gui \
    --disable-netbeans \
    --enable-multibyte \
    --enable-python3interp \
    --with-features=huge \
    --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu/ \
    --with-compiledby=yuzou93@outlook.com \
    && make install 

# Base vim
FROM alpine:3.8

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/share/vim /usr/local/share/vim
RUN apk add --update --no-cache \
    libice \
    libsm \
    libx11 \
    libxt \
    ncurses \
    python3 \
    perl \
    npm

RUN apk add --update --no-cache \
    git \
    bash

ARG USERNAME=zouyu.zou
ARG GROUPNAME=zouyu.zou
ARG WORKSPACE=/home/zouyu.zou
ARG UID=1000
ARG GID=1000
ARG SHELL=/bin/sh

RUN apk add --no-cache sudo \
    && mkdir -p "${WORKSPACE}" \
    && echo "${USERNAME}:x:${UID}:${GID}:${USERNAME},,,:${WORKSPACE}:${SHELL}" \
    >> /etc/passwd \
    && echo "${USERNAME}::17032:0:99999:7:::" \
    >> /etc/shadow \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" \
    > "/etc/sudoers.d/${USERNAME}" \
    && chmod 0440 "/etc/sudoers.d/${USERNAME}" \
    && echo "${GROUPNAME}:x:${GID}:${USERNAME}" >> /etc/group \
    && chown "${UID}":"${GID}" "${WORKSPACE}"

WORKDIR $WORKSPACE

USER $USERNAME

COPY vimrc ${WORKSPACE}/.vimrc
RUN mkdir ${WORKSPACE}/.vim \
    && sudo chown -R "${UID}":"${GID}" .vimrc .vim/

ENTRYPOINT ["vim"]
