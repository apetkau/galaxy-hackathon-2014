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

A test tool configuration file `catDocker.xml` is included with Galaxy (or at [catDocker.xml](catDocker.xml)).  This can be setup with the following commands (run within `galaxy-central` directory).

1. Setup `catDocker.xml` tool
   
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

2. Construct a `job_conf.xml` which instructs Galaxy to run tools docker-based tools using docker.
   
   Construct a basic `job_conf.xml` with the following command.
   
   ```bash
   cp job_conf.xml.sample_basic job_conf.xml
   ```
   
   Add a docker destination in `job_conf.xml` to enable running through docker:
   
   ```xml
       <destinations default="docker_local">
          <destination id="local" runner="local"/>
          <destination id="docker_local" runner="local">
            <param id="docker_enabled">true</param>
          </destination>
       </destinations>
   ```
   
   More information can be found in the `job_conf.xml.sample_advanced` file that comes with Galaxy.

3. Enable docker to run using sudo without a password.

   Add docker runner to sudoers file (replace `galaxy` with the username you are running galaxy under):

   ```
   galaxy  ALL = (root) NOPASSWD: SETENV: /usr/bin/docker
   ```

4. Start up Galaxy

   ```bash
   $ sh run.sh
   ```

5. Test

   Run test tool **Concatenate datasets (in docker)**

   Check log file.  If the tool ran you should see entries with `docker` like:

   ```
    command is: sudo docker run -e "GALAXY_SLOTS=$GALAXY_SLOTS" -v /home/aaron/Projects/galaxy-central:/home/aaron/Proje
   cts/galaxy-central:ro -v /home/aaron/Projects/galaxy-central/tools/docker:/home/aaron/Projects/galaxy-central/tools/docker:ro -v /home/aaron/Projects/galaxy-central/datab
   ase/job_working_directory/000/6:/home/aaron/Projects/galaxy-central/database/job_working_directory/000/6:rw -v /home/aaron/Projects/galaxy-central/database/files:/home/aa
   ron/Projects/galaxy-central/database/files:rw -w /home/aaron/Projects/galaxy-central/database/job_working_directory/000/6 --net none busybox:ubuntu-14.04 /home/aaron/Projects/galaxy-central/database/job_working_directory/000/6/container.sh; return_code=$?; if [ -f /home/aaron/Projects/galaxy-central/database/job_working_directory/000/6/wo
   rking_file ] ; then cp /home/aaron/Projects/galaxy-central/database/job_working_directory/000/6/working_file /home/aaron/Projects/galaxy-central/database/files/000/dataset_10.dat ; fi; sh -c "exit $return_code"
   ```

Integrating SMALT with Docker
-----------------------------

This contains information on how to integrated a more complicated tool (SMALT) with Docker.  Please see documentation at [SMALT+Docker](smalt/).
