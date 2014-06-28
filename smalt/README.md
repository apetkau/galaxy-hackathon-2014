Integration of SMALT into Galaxy and Docker
===========================================

The version of SMALT I used was the one defined in https://toolshed.g2.bx.psu.edu/repository/find_tools?sort=Repository.name&operation=view_or_manage_repository&id=61631a13f8a13237.  Hopefully someone finds this useful for integrating other docker-based tools in Galaxy.

Step 1: Building Docker image
-----------------------------

I started with a base docker image of `debian/wheezy` (which has apt-get installed), ran this docker container in an interactive mode.  Installed the dependencies (python, smalt, smalt_wrapper.py, etc), and then commited my new image.  The exact set of instructions can be found at [instructions.sh](instructions.sh).

Step 2: Installing Tool configuration
-------------------------------------

The exact tool configuration file I used can be found at [smalt_wrapper.xml](smalt_wrapper.xml).  This is based on https://toolshed.g2.bx.psu.edu/repos/cjav/smalt/file/54855bd8d107/smalt_wrapper.xml.  And can be installed by running:

```bash
$ cp smalt_wrapper.xml galaxy-central/tools/docker/smalt_wrapper.xml
```

Then, I added the tool to the `tool_conf.xml` by adding

```xml
 <tool file="docker/smalt_wrapper.xml"/>
```

The changes I needed to make are:

Changed

```xml
  <requirements>
    <requirement type="package" version="0.7.3">smalt</requirement>
  </requirements>
```

To

```xml
  <requirements>
        <container type="docker">apetkau/smalt:v3</container>
  </requirements>
```

And changed

```xml
  <command interpreter="python">
    smalt_wrapper.py
```

To

```xml
  <command>
    smalt_wrapper.py
```

Step 3: Running Galaxy
----------------------

I then re-ran Galaxy, uploaded the example files (reference.fasta and reads.fastq) and ran SMALT.  To make sure it's running in docker you can look for the following in the logs:

```
galaxy.jobs.runners DEBUG 2014-06-28 16:50:00,930 (18) command is: sudo docker run -e "GALAXY_SLOTS=$GALAXY_SLOTS" -v /home/aaron/Projects/galaxy-central:/home/aaron/Proj
ects/galaxy-central:ro -v /home/aaron/Projects/galaxy-central/tools/docker:/home/aaron/Projects/galaxy-central/tools/docker:ro -v /home/aaron/Projects/galaxy-central/data
base/job_working_directory/000/18:/home/aaron/Projects/galaxy-central/database/job_working_directory/000/18:rw -v /home/aaron/Projects/galaxy-central/database/files:/home
/aaron/Projects/galaxy-central/database/files:rw -w /home/aaron/Projects/galaxy-central/database/job_working_directory/000/18 --net none apetkau/smalt:v3 /home/aaron/Proj
ects/galaxy-central/database/job_working_directory/000/18/container.sh
```
