TELEGRAFVER=${1:-'1.4.3'}
VSPHEREVER=${1:-'1.3.4-vsphere2'}
RPMVER="${TELEGRAFVER/-/_}"
export RPMBUILDROOT=/root/rpmbuild
export GOPATH=/usr/share/gocode
export PATH=$GOPATH/bin:$PATH

# go repo
rpm --import https://mirror.go-repo.io/centos/RPM-GPG-KEY-GO-REPO
curl -s https://mirror.go-repo.io/centos/go-repo.repo | tee /etc/yum.repos.d/go-repo.repo
# epel
yum install -y epel-release
yum -y install golang git rpm-build make which ruby-devel rubygems
gem install fpm
# fix rpm marcos
sed -i -e "s#.centos##g" /etc/rpm/macros.dist

# telegraf
go get github.com/influxdata/telegraf
mkdir -p $GOPATH/src/github.com/influxdata
cd $GOPATH/src/github.com/influxdata
git clone --depth=10 -b $TELEGRAFVER https://github.com/influxdata/telegraf.git

# vsphere
mkdir -p $GOPATH/src/github.com/mkuzmin
cd $GOPATH/src/github.com/mkuzmin
git clone --depth=10 -b $VSPHEREVER https://github.com/mkuzmin/telegraf.git

# add vsphere plugin
rsync -avP $GOPATH/src/github.com/mkuzmin/telegraf/plugins/inputs/vsphere $GOPATH/src/github.com/influxdata/telegraf/plugins/inputs
sed -i -e 's#varnish#varnish\"\n        _ \"github.com/influxdata/telegraf/plugins/inputs/vsphere#g' $GOPATH/src/github.com/influxdata/telegraf/plugins/inputs/all/all.go
echo "github.com/vmware/govmomi b63044e5f833781eb7b305bc035392480ee06a82" >> $GOPATH/src/github.com/influxdata/telegraf/Godeps

# build
cd $GOPATH/src/github.com/influxdata/telegraf
$GOPATH/src/github.com/influxdata/telegraf/scripts/build.py --package --platform=linux --arch=amd64
/bin/cp -f $GOPATH/src/github.com/influxdata/telegraf/build/*.rpm $RPMBUILDROOT/RPMS/x86_64
