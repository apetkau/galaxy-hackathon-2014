Integrating Docker-based tools within Galaxy
============================================

This document describes a method for integrating [Docker](http://www.docker.com/) based tools within [Galaxy](http://galaxyproject.org/).  Docker is a method for wrapping up a tool along with all of it's dependencies into a single container which can be distrubted with the help of [Dockerhub](https://hub.docker.com/).  A method to run docker based tools was added to Galaxy in https://bitbucket.org/galaxy/galaxy-central/pull-request/401/allow-tools-and-deployers-to-specify/diff.

Initial Galaxy and Docker Setup
-------------------------------

### Setup Latest Galaxy

Please download and setup the latest Galaxy from galaxy-central.  More detailed instructions are found at https://wiki.galaxyproject.org/Admin/GetGalaxy but the two main commands you need to run are:

```bash
$ hg clone https://bitbucket.org/galaxy/galaxy-central
$ cd galaxy-central
$ sh run.sh
```

### Setup Docker Test Tool

A test tool configuration file `catDocker.xml` is included with Galaxy.  This can be setup with the following commands.

```bash
$ mkdir tools/docker
$ cp test/functional/tools/catDocker.xml tools/docker/
```

Now, in the `tool_conf.xml` file please add a new section for this tool:

```xml
  <section>
    <tool file="docker/catDocker.xml"/>
  </section>
```

Create `job_conf.xml` and add

```bash
cp job_conf.xml.sample_basic job_conf.xml
```

Add in `job_conf.xml`:

```xml
    <destinations default="docker_local">
       <destination id="local" runner="local"/>
       <destination id="docker_local" runner="local">
         <param id="docker_enabled">true</param>
       </destination>
    </destinations>
```

Add docker runner to sudoers file (replace `galaxy` with your username you are running galaxy under):

```
galaxy  ALL = (root) NOPASSWD: SETENV: /usr/bin/docker
```

Run Galaxy

```bash
$ sh run.sh
```

Run test tool **Concatenate datasets (in docker)**

Check log file.  If tool ran you should see entries like:

```
 command is: sudo docker run -e "GALAXY_SLOTS=$GALAXY_SLOTS" -v /home/aaron/Projects/galaxy-central:/home/aaron/Proje
cts/galaxy-central:ro -v /home/aaron/Projects/galaxy-central/tools/docker:/home/aaron/Projects/galaxy-central/tools/docker:ro -v /home/aaron/Projects/galaxy-central/datab
ase/job_working_directory/000/6:/home/aaron/Projects/galaxy-central/database/job_working_directory/000/6:rw -v /home/aaron/Projects/galaxy-central/database/files:/home/aa
ron/Projects/galaxy-central/database/files:rw -w /home/aaron/Projects/galaxy-central/database/job_working_directory/000/6 --net none busybox:ubuntu-14.04 /home/aaron/Projects/galaxy-central/database/job_working_directory/000/6/container.sh; return_code=$?; if [ -f /home/aaron/Projects/galaxy-central/database/job_working_directory/000/6/wo
rking_file ] ; then cp /home/aaron/Projects/galaxy-central/database/job_working_directory/000/6/working_file /home/aaron/Projects/galaxy-central/database/files/000/dataset_10.dat ; fi; sh -c "exit $return_code"
```

Integrating SMALT with Docker
-----------------------------

Please see documentation at [SMALT+Docker](smalt/).
