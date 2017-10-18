
# php70-drupal
FROM registry.access.redhat.com/rhscl/php-70-rhel7

# TODO: Put the maintainer name in the image metadata
# MAINTAINER Stephen Kolar Stephen.W.Kolar@hpe.com

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV DRUPAL_VERSION=7.50

USER root

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for serving Drupal for hud.gov \
      io.k8s.display-name="Drupal 7.50" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,html,php,drupal"

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
# RUN yum clean all -y

# TODO (optional): Copy the builder files into /opt/app-root
COPY ./src/000-default.conf.template /opt/app-root/etc/
COPY ./src/phpinfo.php /opt/app-root/src/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
RUN chown -R 1001:1001 /usr/libexec/s2i && rm -f /usr/libexec/s2i/*
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
