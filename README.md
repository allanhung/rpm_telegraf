RPMBUILD for telegraf
=========================

telegraf rpm

How to Build
=========
    git clone https://github.com/allanhung/rpm_telegraf
    cd rpm_telegraf
    docker run --name=telegraf_build --rm -ti -v $(pwd)/rpms:/root/rpmbuild/RPMS/x86_64 -v $(pwd)/rpms:/root/rpmbuild/RPMS/noarch -v $(pwd)/scripts:/usr/local/src/build centos /bin/bash -c "/usr/local/src/build/build_telegraf.sh 1.4.3"

# check
    docker run --name=telegraf_check --rm -ti -v $(pwd)/rpms:/root/rpmbuild/RPMS centos /bin/bash -c "yum localinstall -y /root/rpmbuild/RPMS/telegraf-*.rpm"


Reference
=========
[telegraf](https://github.com/influxdata/telegraf)
[vsphere plugin](https://github.com/mkuzmin/telegraf/tree/1.3.4-vsphere2)
