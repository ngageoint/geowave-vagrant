# GeoWave Vagrant README

## Quick Start
To get started, first install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).  Then simply open a terminal in this folder and type:  
`vagrant up`

You can ssh into the box using:  
`vagrant ssh`

## Contents
### Vagrantfile
This file defines the VM that will be deployed.  By default, we create a dual-core CentOS x64 box with 4GB of ram.

For this VM, we also set up a synced folder in the current directory of the host machine which maps to **/home/vagrant** on the guest VM.  

Additionally, the ports used for **Zookeeper (2181)** and **Accumulo Monitor (50095)** are forwarded so that you can access the cluster directly from the host machine.  You can map these ports to any host port of your choosing by changing the host value.

### provision.sh
This script is used by Vagrant to install the dependencies necessary to build GeoWave.

Our only dependencies for building GeoWave are the JDK, Maven and Git.  

GeoWave is then cloned from GitHub and built using the profile **geowave-singlejar**

Finally, we install a geowave service which can be used to create a 2 node Mini-Accumulo cluster running GeoWave.  This is deployed by the class **GeoWaveDemoApp** from **/home/vagrant/geowave/geowave-deploy/target/geowave-singlejar.jar**.  The service is started by default, but you can manually start, stop, and restart the service with the following commands:

`sudo service geowave stop`  
`sudo service geowave start`  
`sudo service geowave restart`  

### geowave
This is the script that is installed to enable GeoWave to run as a service.  

## Workflow
You can edit the GeoWave source files using an IDE of your choosing on the host machine.  To do this, just point your IDE towards the synced folder that was setup by Vagrant.  

If you make a change which requires the Accumulo cluster to be restarted (e.g. you modify an Accumulo iterator), remember to first stop the GeoWave service.  Then, make sure that you build the **geowave-singlejar** profile when building GeoWave, or else **/home/vagrant/geowave/geowave-deploy/target/geowave-singlejar.jar** will not be created and you won't be able to start the GeoWave service.  

### Workflow Note
You may need to setup your git remote with your username in order to push commits to the repo.  You can do that with the following command in the geowave project folder.  
`git remote set-url origin https://username@github.com/ngageoint/geowave.git`

# Origin

GeoWave and related projects were developed at the National Geospatial-Intelligence Agency (NGA) in collaboration with [RadiantBlue Technologies](http://www.radiantblue.com/) and [Booz Allen Hamilton](http://www.boozallen.com/).  The government has ["unlimited rights"](https://github.com/ngageoint/geowave/blob/master/NOTICE) and is releasing this software to increase the impact of government investments by providing developers with the opportunity to take things in new directions. The software use, modification, and distribution rights are stipulated within the [Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0.html) license.  

# Contributing

All pull request contributions to this project will be released under the Apache 2.0 or compatible license.
Software source code previously released under an open source license and then modified by NGA staff is considered a "joint work" (see *17 USC  101*); it is partially copyrighted, partially public domain, and as a whole is protected by the copyrights of the non-government authors and must be released according to the terms of the original open source license.

