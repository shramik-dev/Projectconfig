FROM  jetty
# Take the war and copy to webapps of tomcat
COPY target/*.war /var/lib/jetty/webapps/dockeransible.war
