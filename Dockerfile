FROM openjdk:11-jre-slim

LABEL maintainer="Victor Rabay <victor.rabay@gmail.com>"

RUN apt-get update \
    && apt-get install -y apt-utils \
    && apt-get install -y curl gnupg2 unzip procps \
    && rm -rf /var/lib/apt/lists/*

# 7.9.3
ENV SONAR_VERSION="6.7.7" \
    SONARQUBE_HOME="/opt/sonarqube" \
    SONARQUBE_JDBC_USERNAME="sonar" \
    SONARQUBE_JDBC_PASSWORD="sonar" \
    SONARQUBE_JDBC_URL="" \
    sonar.web.javaOpts="-Xmx512m -Xms512m" \
    sonar.ce.javaOpts="-Xmx512m -Xms512m" \
    sonar.search.javaOpts="-Xmx1024m -Xms1024m" \
    sonar.log.level="INFO" \
    sonar.updatecenter.activate="false" \
    PLGN_JAVA_VRSN="5.13.0.18197" \
    PLGN_JVSCRPT_VRSN="3.2.0.5506" \
    PLGN_KTLN_VRSN="1.5.0.315" \
    PLGN_TYPSCRPT_VRSN="1.1.0.1079"

# Http port
EXPOSE 9000

RUN groupadd -r sonarqube && useradd -r -g sonarqube sonarqube

# pub   2048R/D26468DE 2015-05-25
#       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
# uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
# sub   2048R/06855C1D 2015-05-25
RUN set -x \
    && for server in $(shuf -e ha.pool.sks-keyservers.net \
                    hkp://p80.pool.sks-keyservers.net:80 \
                    keyserver.ubuntu.com \
                    hkp://keyserver.ubuntu.com:80 \
                    pgp.mit.edu) ; do \
        gpg --batch --keyserver "$server" --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE && break || : ; \
    done \
    && cd /opt \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip -q sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && chown -R sonarqube:sonarqube sonarqube \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

# Get latest plugins on https://docs.sonarqube.org/display/PLUG/Plugin+Library
RUN set -x \
    && rm -rf $SONARQUBE_HOME/extensions/plugins/*checkstyle*.jar \
    && rm -rf $SONARQUBE_HOME/extensions/plugins/*java*.jar \
    && rm -rf $SONARQUBE_HOME/extensions/plugins/*javascript*.jar \
    && rm -rf $SONARQUBE_HOME/extensions/plugins/*kotlin*.jar

#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*pmd*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*ansible*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*csharp*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*css*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*flex*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*go-plugin*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*findbugs*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*html*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*php*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*yaml*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*python*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*ruby*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*scala*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*typescript*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*vbnet*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*xml*.jar \
#     && rm -rf $SONARQUBE_HOME/extensions/plugins/*dependency-check*.jar

RUN set -x \
    && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-java-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-java-plugin/sonar-java-plugin-$PLGN_JAVA_VRSN.jar \
    && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-typescript-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-typescript-plugin/sonar-typescript-plugin-$PLGN_TYPSCRPT_VRSN.jar \
    && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-javascript-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-javascript-plugin/sonar-javascript-plugin-$PLGN_JVSCRPT_VRSN.jar \
    && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-kotlin-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-kotlin-plugin/sonar-kotlin-plugin-$PLGN_KTLN_VRSN.jar    

#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-checkstyle-plugin.jar -fSL https://github.com/checkstyle/sonar-checkstyle/releases/download/4.29/checkstyle-sonar-plugin-4.29.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-pmd-plugin.jar -fSL https://github.com/jensgerdes/sonar-pmd/releases/download/3.2.1/sonar-pmd-plugin-3.2.1.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-ansible-plugin.jar -fSL https://github.com/sbaudoin/sonar-ansible/releases/download/v2.3.0/sonar-ansible-plugin-2.3.0.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-csharp-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-csharp-plugin/sonar-csharp-plugin-8.3.0.14607.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-css-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-css-plugin/sonar-css-plugin-1.2.0.1325.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-flex-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-flex-plugin/sonar-flex-plugin-2.5.1.1831.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-go-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-go-plugin/sonar-go-plugin-1.6.0.719.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-findbugs-plugin.jar -fSL https://github.com/spotbugs/sonar-findbugs/releases/download/3.11.1/sonar-findbugs-plugin-3.11.1.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-html-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-html-plugin/sonar-html-plugin-3.2.0.2082.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-php-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-php-plugin/sonar-php-plugin-3.3.0.5166.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-yaml-plugin.jar -fSL https://github.com/sbaudoin/sonar-yaml/releases/download/v1.5.1/sonar-yaml-plugin-1.5.1.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-python-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-python-plugin/sonar-python-plugin-2.5.0.5733.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-ruby-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-ruby-plugin/sonar-ruby-plugin-1.5.0.315.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-scala-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-scala-plugin/sonar-scala-plugin-1.5.0.315.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-vbnet-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-vbnet-plugin/sonar-vbnet-plugin-8.3.0.14607.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-xml-plugin.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-xml-plugin/sonar-xml-plugin-2.0.1.2020.jar \
#     && curl -o $SONARQUBE_HOME/extensions/plugins/sonar-dependency-check-plugin.jar -fSL https://github.com/dependency-check/dependency-check-sonar-plugin/releases/download/2.0.4/sonar-dependency-check-plugin-2.0.4.jar \
#     && chown -R sonarqube:sonarqube $SONARQUBE_HOME/extensions/plugins/

RUN ls -lha $SONARQUBE_HOME/extensions/plugins/

COPY resources/run.sh $SONARQUBE_HOME/bin/run.sh 
COPY resources/healthcheck.sh $SONARQUBE_HOME/bin/healthcheck.sh
COPY resources/config.sh $SONARQUBE_HOME/bin/config.sh

HEALTHCHECK CMD $SONARQUBE_HOME/bin/healthcheck.sh

WORKDIR $SONARQUBE_HOME

RUN set -x \
    && chown -R sonarqube:sonarqube $SONARQUBE_HOME \
    && chmod -v u=rwx,g=rwx,o=rx $SONARQUBE_HOME/bin/run.sh \
    && chmod -v u=rwx,g=rwx,o=rx $SONARQUBE_HOME/bin/healthcheck.sh \
    && chmod -v u=rwx,g=rwx,o=rx $SONARQUBE_HOME/bin/config.sh

USER sonarqube

ENTRYPOINT ["./bin/run.sh"] 