# Install dependencies

sudo yum install -y wget

# Setup JDK
echo "JDK: Downloading..."
wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-sucurebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.rpm -O jdk-8u111-linux-x64.rpm
if [ $? -ne 0 ]; then
  echo "Failed to fetch Java 8 JDK, exiting"
  exit -1;
fi
echo "JDK: Installing..."
sudo yum -y --nogpgcheck localinstall jdk-8u111-linux-x64.rpm

# Setup Maven
echo "Maven: Downloading..."
wget -q https://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz
if [ $? -ne 0 ]; then
  echo "Failed to fetch maven package, exiting"
  exit -1;
fi
echo "Maven: Installing..."
sudo tar -xzf apache-maven-3.2.5-bin.tar.gz -C /usr/local
sudo ln -s /usr/local/apache-maven-3.2.5 /usr/local/maven
sudo printf 'export M2_HOME=/usr/local/maven\nexport M2=$M2_HOME/bin\nexport PATH=$M2:$PATH' > /etc/profile.d/maven.sh
source /etc/profile

# Setup Git
echo "Git: Installing..."
sudo yum -y install git

# Setup GeoWave
echo "GeoWave: Cloning..."
git clone --depth=10 --branch=master https://github.com/ngageoint/geowave.git
git clone --depth=10 --branch=master https://github.com/ngageoint/geowave-vagrant.git
cd geowave
echo "Geowave: Install Dev Tools..."
cd dev-resources
mvn clean install
cd ..
echo "GeoWave: Building..."
mvn clean package -pl examples -am -P geowave-tools-singlejar -DskipITs=true -DskipTests=true -Dfindbugs.skip=true -Dformatter.skip=true -Dtools.finalName=geowave-singlejar

# Install GeoWave service
echo "GeoWave: Installing Service..."
sudo cp /home/vagrant/geowave-vagrant/geowave.sh /etc/init.d/geowave
sudo chmod a+x /etc/init.d/geowave
sudo chkconfig --add geowave
sudo service geowave start
