FROM quay.io/centos/centos:stream8
LABEL maintainer "ueno.s <ueno.s@gamestudio.co.jp>"

# Add external files
COPY files/run.sh /usr/local/bin/run.sh
COPY files/p4.auth /etc/logrotate.d/p4.auth
COPY files/p4.commands /etc/logrotate.d/p4.commands
COPY files/p4.errors /etc/logrotate.d/p4.errors
COPY files/p4.events /etc/logrotate.d/p4.events
COPY files/p4.integrity /etc/logrotate.d/p4.integrity
COPY files/p4.log /etc/logrotate.d/p4.log
COPY files/CheckCaseTrigger.py /usr/local/bin/CheckCaseTrigger.py
COPY files/CheckCaseTrigger3.py /usr/local/bin/CheckCaseTrigger3.py
COPY files/P4Triggers.py /usr/local/bin/P4Triggers.py

ARG P4NAME=master
ARG P4TCP=1666
ARG P4USER=super
ARG P4PASSWD=Passw0rd
ARG P4CASE=0
ARG P4HOME=/opt/perforce/servers

ENV P4NAME=$P4NAME \
    P4TCP=$P4TCP \
    P4PORT=ssl:$P4TCP \
    P4USER=$P4USER \
    P4PASSWD=$P4PASSWD \
    P4HOME=$P4HOME \
    P4ROOT=$P4HOME/$P4NAME \
    CASE_INSENSITIVE=$P4CASE

RUN dnf -y install procps git yum-utils glibc-locale-source sudo glibc-langpack-ja glibc glibc-common tzdata logrotate cronie openssl \
    && dnf -y upgrade \
    && dnf -y update \
    && cd /lib/systemd/system/sysinit.target.wants/ && \
    for i in *; do \
        [ $i == systemd-tmpfiles-setup.service ] || rm -vf $i ; \
    done ; \
    rm -vf /lib/systemd/system/multi-user.target.wants/* && \
    rm -vf /etc/systemd/system/*.wants/* && \
    rm -vf /lib/systemd/system/local-fs.target.wants/* && \
    rm -vf /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -vf /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -vf /lib/systemd/system/basic.target.wants/* && \
    rm -vf /lib/systemd/system/anaconda.target.wants/* && \
    mkdir -p /etc/selinux/targeted/contexts/ && \
    echo '<busconfig><selinux></selinux></busconfig>' > /etc/selinux/targeted/contexts/dbus_contexts \
    && dnf clean all --enablerepo='*' \
    && dnf clean metadata --enablerepo='*' \
    && dnf clean all --enablerepo='*' \
    && rm -rf /var/cache/yum \
    && rpm --import https://package.perforce.com/perforce.pubkey \
    && dnf config-manager --add-repo https://gist.githubusercontent.com/radicalgrimoire/f235f327baacdf6f109903eec5d9a717/raw/f54bb09d6a73d390762feaf0ef3344d128677dc9/perforce.centos.repo \
    && dnf install -y helix-p4d python3 \
    && curl -kL https://bootstrap.pypa.io/pip/3.6/get-pip.py | python3 \
    && pip install p4python \
    && chmod +x /usr/local/bin/run.sh \
    && chmod 644 /etc/logrotate.d/p4.auth \
    && chmod 644 /etc/logrotate.d/p4.commands \
    && chmod 644 /etc/logrotate.d/p4.errors \
    && chmod 644 /etc/logrotate.d/p4.events \
    && chmod 644 /etc/logrotate.d/p4.integrity \
    && chmod 644 /etc/logrotate.d/p4.log \
    && systemctl enable crond \
    && git clone https://github.com/perforce/helix-authentication-extension.git /opt/helix-authentication-extension \
    && run.sh \
    && pushd /opt/helix-authentication-extension \
    && rm -Rf .git \
    && p4 extension --package loginhook \
    && p4 trust -y -f \
    && cp ~/.p4* /opt/perforce/ \
    && chown perforce:perforce /opt/perforce/.p4* \
    && p4 configure set dm.user.noautocreate=2 \
    && popd

ENV P4ROOT=$P4HOME/$P4NAME/root

VOLUME [ "/opt/perforce/servers" ]

ENTRYPOINT ["run.sh"]

CMD [ "/sbin/init" ]