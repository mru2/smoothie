# Assume everything cloned in www

# Update
sudo apt-get update -y

# Global dependencies
sudo apt-get install python-software-properties build-essential curl -y

# Add repositories for edge packages
sudo add-apt-repository ppa:chris-lea/node.js -y
sudo add-apt-repository ppa:nginx/stable -y
sudo add-apt-repository ppa:chris-lea/redis-server -y
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10

# Neo4j
wget -O - http://debian.neo4j.org/neotechnology.gpg.key | sudo apt-key add -
sudo sh -c "echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list"

sudo apt-get update -y

# Install node
sudo apt-get install nodejs -y

# Install nginx
sudo apt-get install nginx -y

# Install redis
sudo apt-get install redis-server -y

# Install ruby
curl -L https://get.rvm.io | bash -s stable
source .rvm/scripts/rvm
sudo rvm requirements
rvm install 2.0.0
rvm use 2.0.0 --default

# Install neo4j
sudo apt-get install neo4j -y
sudo sed -i 's/#org\.neo4j\.server\.webserver\.address=0\.0\.0\.0/org.neo4j.server.webserver.address=0.0.0.0/' /etc/neo4j/neo4j-server.properties
sudo service neo4j-service restart

# Configure nginx
sudo cp /www/provision/conf/nginx.conf /etc/nginx/sites-available/app
sudo ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/app
sudo rm /etc/nginx/sites-enabled/default
sudo service nginx restart

# Install dependencies
sudo npm install -g bower
sudo npm install -g gulp

cd /www

bower install
bundle install