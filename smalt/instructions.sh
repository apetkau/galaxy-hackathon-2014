# Run docker image 'debian/wheezy' in interactive mode
sudo docker run -i -t debian:wheezy

# Run the below in this image

apt-get update
apt-get install python
apt-get install wget
apt-get install mercurial

mkdir tool
cd tool

wget ftp://ftp.sanger.ac.uk/pub4/resources/software/smalt/smalt-0.7.3.tgz
tar -xvvzf smalt-0.7.3.tgz

# because the smalt_wrapper.py finds the binary name based on `uname -i` which is unknown in docker
mv smalt-0.7.3/smalt_x86_64 smalt_unknown

hg clone https://toolshed.g2.bx.psu.edu/repos/cjav/smalt smalt_deps
cp smalt_deps/smalt_wrapper.py .

# add smalt tools to PATH (probably different ways to do this)
ln -s /tool/smalt_unknown /usr/bin 
ln -s /tool/smalt_wrapper.py /usr/bin

# make smalt_wrapper executable
chmod a+x /tool/smalt_wrapper.py

# exit out of docker image and run the below to commit to new container.  replace the number '07b...' with container id for the above docker container.
sudo docker commit -m "make smalt_wrapper executable" -a "Aaron Petkau" 07b937918961 apetkau/smalt:v3

# push to dockerhub
# please see instructions at http://docs.docker.com/userguide/dockerimages/#push-an-image-to-docker-hub
