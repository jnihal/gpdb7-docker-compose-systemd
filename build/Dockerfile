FROM gcr.io/data-gpdb-public-images/gpdb7-rocky8-test-multiarch

# To enable systemd on docker
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

COPY install-dependencies.sh /opt
COPY setup-gpadmin.sh /opt
COPY update-bashrc.sh /opt

RUN /opt/install-dependencies.sh
RUN /opt/setup-gpadmin.sh
RUN /opt/update-bashrc.sh
