# Galaxy - SMALT
# From https://toolshed.g2.bx.psu.edu/repository/view_repository?sort=Repository.name&operation=view_or_manage_repository&changeset_revision=54855bd8d107&id=ec70d959cc6d865d

FROM debian:wheezy

MAINTAINER Aaron Petkau, aaron.petkau@gmail.com

# make sure the package repository is up to date
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mercurial

RUN mkdir /tmp/smalt
WORKDIR /tmp/smalt

RUN wget ftp://ftp.sanger.ac.uk/pub4/resources/software/smalt/smalt-0.7.3.tgz
RUN tar -xvvzf smalt-0.7.3.tgz
RUN cp smalt-0.7.3/smalt_x86_64 /usr/bin/smalt_unknown

RUN hg clone https://toolshed.g2.bx.psu.edu/repos/cjav/smalt smalt_deps
RUN cp smalt_deps/smalt_wrapper.py /usr/bin/smalt_wrapper.py
RUN chmod a+x /usr/bin/smalt_wrapper.py

RUN apt-get clean && rm -rf /tmp/smalt && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
