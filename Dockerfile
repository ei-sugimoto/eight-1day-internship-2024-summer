FROM ruby:3.3.3

ENV LANG C.UTF-8
ENV NODE_VERSION v20.15.0
ENV NVM_VERSION v0.39.7
ENV NVM_DIR /usr/local/nvm
ENV YARN_VERSION 4.1.1

RUN mkdir $NVM_DIR \
    && curl https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm i -g yarn \
    && yarn set version $YARN_VERSION \
    && ln -sf $NVM_DIR/versions/node/$NODE_VERSION/bin/node /usr/bin/node \
    && ln -sf $NVM_DIR/versions/node/$NODE_VERSION/bin/yarn /usr/bin/yarn

RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       vim \
                       fonts-vlgothic \
                       default-mysql-client
