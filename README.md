Ideas for running Tools in Docker for Galaxy
============

Setup
-----

Instructions based on document from https://bitbucket.org/galaxy/galaxy-central/pull-request/401/allow-tools-and-deployers-to-specify/diff.

Setup Latest Galaxy
-------------------

```bash
$ hg clone https://bitbucket.org/galaxy/galaxy-central
$ sh run.sh
```

Setup Docker Test Tool
----------------------

```bash
# Setup tool
$ mkdir tools/docker
$ cp test/functional/tools/catDocker.xml tools/docker/
```

In `tool_conf.xml` add 

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
    <destination id="docker_local" runner="local">
      <param id="docker_enabled">true</param>
    </destination>
```

Run Galaxy

```bash
$ sh run.sh
```

And test tool **Concatenate datasets (in docker)**
