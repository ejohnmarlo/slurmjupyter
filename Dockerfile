FROM ubuntu:20.04
#FROM continuumio/miniconda3

SHELL [ "/bin/bash", "--login", "-c" ]

RUN apt-get update -y && apt install -y environment-modules wget iputils-ping git
#RUN mkdir -p /opt
#RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh -O /opt/miniconda.sh
#RUN chmod +x /opt/miniconda.sh && bash /opt/miniconda.sh -b -u -p /opt/miniconda3
#RUN ls /
#RUN echo 'source /opt/miniconda3/etc/profile.d/conda.sh' >> /etc/profile.d/conda.sh
#RUN /opt/miniconda3/bin/conda init bash
#RUN chmod 777 -R /opt

#RUN conda info --envs

#SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]

ENV TZ=Asia/Manila
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN adduser -u 1001 munge --disabled-password --gecos ""
RUN adduser -u 1002 slurm --disabled-password --gecos ""

RUN apt update -y && apt install -y libmunge-dev libmunge2 munge hwloc libhwloc-dev net-tools
##RUN apt install munge -y && apt install vim -y && apt install build-essential -y && apt install git -y && apt-get install mariadb-server -y


COPY config/munge.key /etc/munge/
RUN chown -R munge /etc/munge
RUN chmod 400 /etc/munge/munge.key

COPY config/slurm-22.05.3_1.0_amd64.deb /
RUN dpkg -i /slurm-22.05.3_1.0_amd64.deb
RUN rm -rf /slurm-22.05.3_1.0_amd64.deb

RUN mkdir -p /etc/slurm /etc/slurm/prolog.d /etc/slurm/epilog.d /var/spool/slurm/d
RUN chown slurm /var/spool/slurm/d
##COPY slurm.conf /etc/slurm-llnl/
##COPY cgroup.conf /etc/slurm-llnl/
COPY config/*.conf /etc/slurm/
RUN chown -R slurm /etc/slurm

#ENV LANG C.UTF-8

#RUN apt-get update && apt-get install -y \
#    python3 \
#    python3-pip

#RUN python3 -m pip --no-cache-dir install --upgrade \
#    "pip<20.3" \
#    setuptools

# Some TF tools expect a "python" binary
#RUN ln -s $(which python3) /usr/local/bin/python
##RUN apt install slurm-client -y
RUN apt install curl dirmngr apt-transport-https lsb-release ca-certificates -y
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
#RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install sudo -y && apt install python3.9 python3-pip -y
RUN apt update -y && apt install nodejs -y && npm install -g configurable-http-proxy && pip3 install jupyterlab
#RUN apt update -y && apt install nodejs -y && npm install -g configurable-http-proxy && pip3 install jupyterlab==2.1.2
#RUN apt install libopenmpi-dev -y && pip3 install mpi4py && pip3 install jupyterlab_slurm
RUN pip3 install jupyterlab_slurm
#RUN python3 -m pip install --no-cache-dir jupyterlab==2.1.2 matplotlib
#RUN python3 -m pip install --no-cache-dir jupyter_http_over_ws ipykernel==5.1.1 nbformat==4.4.0 jedi==0.17.2
#RUN jupyter serverextension enable --py jupyter_http_over_ws
#RUN python3 -m pip install --no-cache-dir jupyterlab_slurm
#RUN apt install -y iputils-ping && apt autoremove -y

#RUN apt install curl dirmngr apt-transport-https lsb-release ca-certificates -y
#RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
#RUN apt install python3.9 python3-pip -y
#RUN apt update -y && apt install nodejs -y && npm install -g configurable-http-proxy && pip3 install jupyterlab==2.1.2
#RUN apt install libopenmpi-dev -y && pip3 install mpi4py && pip3 install jupyterlab_slurm


EXPOSE 8888


#ENTRYPOINT ["conda", "run", "-n", "samsung", "/bin/bash", "-c","tail -f /dev/null"]
COPY config/export.file .
RUN cat export.file >> /etc/profile.d/miniconda3.sh
#SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]
#RUN python3 -m ipykernel.kernelspec

COPY config/bash.bashrc /
RUN cat /bash.bashrc >> /etc/bash.bashrc
#RUN export PATH=$PATH:/opt/miniconda3/bin
RUN python3 -m pip install ipykernel

#RUN mkdir -p /cert/live/website /cert/archive/website && chmod 777 -R /cert

COPY config/config_jupyter.sh /
RUN chmod 771 /config_jupyter.sh
#SHELL ["conda", "run", "-n", "pytorch", "/bin/bash","-c"]
ENTRYPOINT ["/bin/bash", "-c","tail -f /dev/null"]
