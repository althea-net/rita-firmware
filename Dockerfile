FROM debian:8
RUN useradd -u 1000 -s /bin/bash build; mkdir -p /home/build/
RUN apt-get update; apt-get install -y sudo build-essential libncurses5-dev gawk git subversion libssl-dev gettext unzip zlib1g-dev file python bash python-dev libffi-dev time wget curl
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py
RUN pip install --upgrade ansible
RUN chown -R build /home/build/
USER build
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
