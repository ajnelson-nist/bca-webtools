#!/usr/bin/env bash

SCRIPT_PATH=$(dirname $(readlink -f $0 ) )

##
# Bash script to provision VM, used to set up BCA environment.
#
# Be aware this script is only the first time you issue the
#    vagrant up
# command, or following a
#    vagrant destroy
#    vagrant up
# combination.  See the README for further detais.
##

# Install python-dev
sudo apt-get install -y python-dev

# Install pip and flask
sudo apt-get install -y python-pip
sudo pip install flask

# Needed for libewf
sudo apt-get install zlib1g-dev

# Install Postgress as back end database
sudo apt-get install -y postgresql

# PGAdmin 3 for database management
sudo apt-get install -y pgadmin3

# Postgress dev package
sudo apt-get install -y postgresql-server-dev-9.3

# psycopg2 and flask SQL Alchemy
sudo pip install -U psycopg2
sudo pip install Flask-SQLAlchemy

# libtalloc
sudo apt-get install -y libtalloc2
sudo apt-get install -y libtalloc-dev

# Check postgress setup
check_install postgresql postgresql

# Start postgress and setup up postgress user
sudo service postgresql start
sudo -u postgres psql -c"ALTER user postgres WITH PASSWORD 'bcadmin'"
sudo -u postgres psql -c"CREATE user bcadmin WITH PASSWORD 'bcadmin'"
sudo -u postgres createdb -O bcadmin bcdb
sudo service postgresql restart

# Install libewf 
cd /tmp
sudo wget https://53efc0a7187d0baa489ee347026b8278fe4020f6.googledrive.com/host/0B3fBvzttpiiSMTdoaVExWWNsRjg/libewf-20140608.tar.gz
tar -xzvf libewf-20140608.tar.gz
cd libewf-20140608
bootstrap
./configure --enable-v1-api
make
sudo make install
sudo ldconfig

# Install sleuthkit
cd /tmp
sudo wget http://sourceforge.net/projects/sleuthkit/files/latest/download?source=files -O sleuthkit.tar.gz
tar -xzvf sleuthkit.tar.gz
wget https://4a014e8976bcea5c2cd7bfa3cac120c3dd10a2f1.googledrive.com/host/0B3fBvzttpiiScUxsUm54cG02RDA/tsk4.1.3_external_type.patch
sed  -i '/TSK_IMG_TYPE_EWF_EWF = 0x0040,  \/\/\/< EWF version/a \
\
        TSK_IMG_TYPE_EXTERNAL = 0x1000,  \/\/\/< external defined format which at least implements TSK_IMG_INFO, used by pytsk' /tmp/sleuthkit-4.1.3/tsk/img/tsk_img.h
cd sleuthkit-4.1.3
./configure
make
sudo make install
sudo ldconfig

# Python tsck bindings
sudo apt-get install -y git
cd /tmp
git clone https://github.com/py4n6/pytsk
cd pytsk
python setup.py build
sudo python setup.py install

# Dependencies for Python Bokeh
# See http://bokeh.pydata.org/en/latest/docs/installation.html#install-dependencies
# Some are already satsified from earlier Flask install
sudo apt-get install -y redis-server

# Minimum deps for scipy in pip
sudo apt-get install -y python python-dev libatlas-base-dev gcc gfortran g++

# Install scipy
# pip installs currently cause errors - back to apt-get
# sudo pip install scipy
# sudo pip install numpy
sudo apt-get install -y python-scipy

sudo pip install pandas
sudo pip install redis
sudo pip install tornado
sudo pip install greenlet
sudo pip install pyzmq
# Already have dateutil
#sudo pip install python-dateutil

# Bokeh testing dependencies
sudo pip install beautifulsoup
sudo pip install colorama
# Couldn't find pdiff???
#sudo pip install pdiff
sudo pip install boto
sudo pip install nose
sudo pip instal mock
sudo pip install coverage
sudo pip install websocket-client

# Install blaze for future stuff
# See https://groups.google.com/a/continuum.io/forum/#!topic/bokeh/vM8erulLZ7o
# for alternate packaging that actually works
sudo pip install blaze

# Now install some additional deps and bokeh itself (npm and node)
sudo apt-get install -y npm node
sudo pip install bokeh

# FOR REFERENCE ONLY - download bokeh samples
#>>> import bokeh.sampledata
#>>> bokeh.sampledata.download()

# Now install Bokeh from source
##cd /tmp
##git clone https://github.com/bokeh/bokeh.git
##cd bokeh/bokehjs
# More instruction here if we decide to do this in the future. For now, pip.

# link to the shared image folder
#sudo mkdir /home/bcadmin
#sudo ln -s /vagrant/disk-images /home/bcadmin/disk_images

#start the server
#cd /vagrant
#python runserver.py &
