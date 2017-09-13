ARG LTS_SLUG=lts-7.19

FROM fpco/stack-build:$LTS_SLUG

ARG STACK_GLOBAL_PROJECT=/root/.stack/global-project

WORKDIR $STACK_GLOBAL_PROJECT

ADD stack.yaml .
RUN stack setup

RUN npm install socket.io
ENV NODE_PATH=$STACK_GLOBAL_PROJECT/node_modules

WORKDIR /

EXPOSE 6400

CMD ["bash"]
