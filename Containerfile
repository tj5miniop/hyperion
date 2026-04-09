FROM ghcr.io/tj5miniop/hyperion-ci as hyperion-bootc
COPY ../scripts/ /tmp 

# run build.sh script 

USER root
WORKDIR /tmp 
RUN chmod +x build.sh && \
    bash build.sh

LABEL containers.bootc=1
RUN bootc container lint