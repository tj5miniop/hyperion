FROM ghcr.io/tj5miniop/hyperion-ci as hyperion-bootc
COPY ../scripts/ /tmp/scripts 

# run build.sh script 

USER root
WORKDIR /tmp/scripts
RUN chmod +x /tmp/scripts/*.sh && \
    bash build.sh && \
    bash initramfs.sh && \ 
    bash shell.sh

LABEL containers.bootc=1
RUN bootc container lint
