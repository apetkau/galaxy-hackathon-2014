# in docker image from 'debian/wheezy'

apt-get update
apt-get install python
apt-get install wget
apt-get install mercurial

mkdir tool
cd tool

wget ftp://ftp.sanger.ac.uk/pub4/resources/software/smalt/smalt-0.7.3.tgz
tar -xvvzf smalt-0.7.3.tgz
mv smalt-0.7.3/smalt_x86_64 smalt_unknown # because `uname -i` gives unknown

hg clone https://toolshed.g2.bx.psu.edu/repos/cjav/smalt smalt_deps
cp smalt_deps/smalt_wrapper.py .

echo "export PATH=/tool/:$PATH" > /etc/profile.d/smalt.sh


# in host system
sudo docker commit -m "Creating SMALT+dependencies image" -a "Aaron Petkau" 81d0bb337043 apetkau/smalt:v1

# add smalt tools to PATH

ln -s /tool/smalt_unknown /usr/bin 
ln -s /tool/smalt_wrapper.py /usr/bin

sudo docker commit -m "Creating SMALT+dependencies image" -a "Aaron Petkau" a96f6ca84897 apetkau/smalt:v2

sudo docker apetkau/smalt:v2

# make smalt_wrapper executable
chmod a+x /tool/smalt_wrapper.py

sudo docker commit -m "make smalt_wrapper executable" -a "Aaron Petkau" 07b937918961 apetkau/smalt:v3
