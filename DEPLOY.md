# Before
On ec2 micro instance with ebs and default AMI
Security group : open 6379
( To ssh from a public FreeWifi : `sudo ifconfig en1 mtu 1460 )
> ssh -i keypair.pem ec2_user@server-ip

# Install rvm
> \curl -L https://get.rvm.io | bash -s stable --rails --autolibs=enabled

## OpenSSL dependencies needed
> sudo yum install zlib-devel
> sudo yum install openssl
> rvm pkg install openssl # Deprecated, rvm autolibs should be used
> rvm reinstall all --force

<!-- http://multiplethreads.wordpress.com/2013/02/23/setting-up-rails-nginx-thin-amazon-ec2-capistrano/ -->

<!-- http://velenux.wordpress.com/2012/01/10/running-sinatra-and-other-rack-apps-on-nginx-unicorn/ -->

<!-- https://gist.github.com/wlangstroth/3740923 -->

<!-- http://stevenwilliamalexander.wordpress.com/2012/08/09/linux-setup-rubysinatraunicornnginx-server-97339/ -->

<!-- http://recipes.sinatrarb.com/p/deployment/nginx_proxied_to_unicorn -->

# Install nginx
> sudo yum install nginx

# Install unicorn
> gem install unicorn

# Install redis
<!-- https://gist.github.com/MrRuru/5408784 -->
> wget https://gist.github.com/MrRuru/5408784/raw/89d2302076ef3123f9849d36a96029196fdc9c38/install-redis.sh
> chmod +x install-redis.sh
> ./install-redis.sh

> cd /usr/local/src/redis-2.6.12

> sudo mkdir /etc/redis /var/lib/redis
> sudo cp src/redis-server src/redis-cli /usr/local/bin
> sudo cp redis.conf /etc/redis

> sudo nano /etc/redis/redis.conf

> [..]
> daemonize yes<
> [..]

> [..]
> bind 127.0.0.1
> [..]

> [..]
> dir /var/lib/redis
> [..]

> cd /etc/init.d
> sudo wget https://raw.github.com/saxenap/install-redis-amazon-linux-centos/master/redis-server
> sudo chmod 755 /etc/init.d/redis-server

> sudo chkconfig --add redis-server
> sudo chkconfig --level 345 redis-server on

> sudo service redis-server start


# Deploy 

## Before 
Install node (for assets compression)
> git clone git://github.com/joyent/node.git
> cd node
> ./configure
> make
> sudo make install

Set up shared folders
mkdir shared/sockets

# ...