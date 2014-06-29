Integration of SMALT into Galaxy and Docker
===========================================

This describes a way to construct a docker image and modify a tool within Galaxy to work with Docker.  The tool I use is SMALT from https://toolshed.g2.bx.psu.edu/repository/find_tools?sort=Repository.name&operation=view_or_manage_repository&id=61631a13f8a13237.  I describe two different methods to construct a docker image:

A. Interactively
B. Using a `Dockerfile`

1. Building a Docker Image
==========================

A. Building a Docker Image Interactively
----------------------------------------

The interactive method of constructing a docker image is a good method for installing all the dependencies for a tool if you're not quite sure exactly what commands you need to run to get the tool working.  This method involves starting up a docker container, and running commands within this container to get your tool working.  Then, you can **commit** this container to an image and save to dockerhub for re-use.

### Step 1: Starting up a Docker base Image

To build a docker image we need a starting point.  The base image we will use is **debian/wheezy** since it contains `apt-get` for installing more software.  To start up this image in an interactive mode please run:

```bash
$ sudo docker run -i -t debian:wheezy
```

This should bring up a prompt that looks like:

```
root@2c1077a38bce:/#
```

Note that the id `2c1077a38bce` can be used later for saving this container to an image.

### Step 2: Installing Basic Dependencies

A few dependencies are required to install SMALT.  These can be installed with:

```bash
$ apt-get update
$ apt-get install python
$ apt-get install wget
$ apt-get install mercurial
```

### Step 3: Installing SMALT

We will install SMALT by downloading the necessary software and copying to `/usr/bin`.  This can be accomplished with:

```bash
$ mkdir tool
$ cd tool

$ wget ftp://ftp.sanger.ac.uk/pub4/resources/software/smalt/smalt-0.7.3.tgz
$ tar -xvvzf smalt-0.7.3.tgz

# because the smalt_wrapper.py finds the binary name based on `uname -i` which is unknown in docker
$ mv smalt-0.7.3/smalt_x86_64 smalt_unknown

$ hg clone https://toolshed.g2.bx.psu.edu/repos/cjav/smalt smalt_deps
$ cp smalt_deps/smalt_wrapper.py .

# add smalt tools to /usr/bin so they're on the PATH
$ ln -s /tool/smalt_unknown /usr/bin
$ ln -s /tool/smalt_wrapper.py /usr/bin

# make smalt_wrapper executable
$ chmod a+x /tool/smalt_wrapper.py
```

You can test out SMALT by trying to run `smalt_unknown` and `smalt_wrapper.py` in the docker container.

### Step 4: Building an Image

To build the docker image from the container, please exit the container and run the following:

```bash
$ sudo docker commit -m "make smalt image" -a "Aaron Petkau" 2c1077a38bce apetkau/smalt-galaxy
```

Please fill in the appropriate information for your image.  In particular, make sure the container id `2c1077a38bce` is correct.

To push this image to dockerhub you can run:

```bash
$ sudo docker push apetkau/smalt-galaxy
```

B. Building an image using a `Dockerfile`
-----------------------------------------

Alternatively, instead of building an image interactively, you can build an image with a `Dockerfile`.  An example Dockerfile can be found in this repository.  To build an image please run:

```bash
$ sudo docker build -t apetkau/smalt-galaxy .
```

More information on Dockerfiles can be found at https://docs.docker.com/reference/builder/.

2. Installing Tool configuration
================================

### Installing Example file

Once a Docker image has been built, it can be integrated into a tool by modifying the tool configuration XML file.  For SMALT, the configuration file is [smalt_wrapper.xml](smalt_wrapper.xml).  This is based on https://toolshed.g2.bx.psu.edu/repos/cjav/smalt/file/54855bd8d107/smalt_wrapper.xml.  And can be installed by running:

```bash
$ cp smalt_wrapper.xml galaxy-central/tools/docker/smalt_wrapper.xml
```

Then, please add this tool to the `tool_conf.xml` by adding:

```xml
 <tool file="docker/smalt_wrapper.xml"/>
```

### List of Changes

The exact changes you I needed to make are:

1. I added the specific docker image name to the requirements by changing:

   ```xml
     <requirements>
       <requirement type="package" version="0.7.3">smalt</requirement>
     </requirements>
   ```
   
   To
   
   ```xml
     <requirements>
           <container type="docker">apetkau/smalt-galaxy</container>
     </requirements>
   ```

2. I had to remove `interpreter` from the command attribute by changing

   ```xml
     <command interpreter="python">
       smalt_wrapper.py
   ```
   
   To
   
   ```xml
     <command>
       smalt_wrapper.py
   ```

3. Running Galaxy
=================

Once the tool is installed, please run Galaxy.  And test out the tool.  Some example files (reference.fasta and reads.fastq) are included.  To make sure it's running in docker you can look for the following `sudo docker run` in the logs:

```
galaxy.jobs.runners DEBUG 2014-06-28 16:50:00,930 (18) command is: sudo docker run -e "GALAXY_SLOTS=$GALAXY_SLOTS" -v /home/aaron/Projects/galaxy-central:/home/aaron/Proj
ects/galaxy-central:ro -v /home/aaron/Projects/galaxy-central/tools/docker:/home/aaron/Projects/galaxy-central/tools/docker:ro -v /home/aaron/Projects/galaxy-central/data
base/job_working_directory/000/18:/home/aaron/Projects/galaxy-central/database/job_working_directory/000/18:rw -v /home/aaron/Projects/galaxy-central/database/files:/home
/aaron/Projects/galaxy-central/database/files:rw -w /home/aaron/Projects/galaxy-central/database/job_working_directory/000/18 --net none apetkau/smalt:v3 /home/aaron/Proj
ects/galaxy-central/database/job_working_directory/000/18/container.sh
```
