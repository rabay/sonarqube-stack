#/bin/bash

#Common Vars
DEFAULT_HEADERS="Content-Type: application/x-www-form-urlencoded"

#Quality Gates
QG_NAME="DefaultQualityGate"
QG_ID="2"

#Quality Gates Metrics
QG_METRIC_1="coverage"
QG_OP_1="LT"
QG_ERROR_1="80"
QG_METRIC_2="security_rating"
QG_OP_2="GT"
QG_ERROR_2="A"
QG_METRIC_3="new_coverage"
QG_OP_3="LT"
QG_ERROR_3="80"
QG_METRIC_4="reliability_rating"
QG_OP_4="GT"
QG_ERROR_4="A"

#Quality Profiles
QP_JAVA_LANGUAGE_ID="java"
# QP_JAVA_DEFAULT_PROFILE="FindBugs+%2B+FB-Contrib"
QP_JAVA_DEFAULT_PROFILE="Sonar+way"
QP_TS_LANGUAGE_ID="ts"
QP_TS_DEFAULT_PROFILE="Sonar+way+recommended"
QP_JS_LANGUAGE_ID="js"
QP_JS_DEFAULT_PROFILE="Sonar+way+Recommended"

# curl -X POST -u admin:admin \
#      -d "name=OpenGate" \
#      -H "$DEFAULT_HEADERS" \
#      'http://localhost:9000/api/qualitygates/create'

# curl -X POST -u admin:admin \
#      -d "id=$QG_ID" \
#      -H "$DEFAULT_HEADERS" \
#      'http://localhost:9000/api/qualitygates/set_as_default'

# curl -X POST -u admin:admin \
#      -d "gateId=$QG_ID&metric=$QG_METRIC_1&error=$QG_ERROR_1&op=$QG_OP_1" \
#      -H "$DEFAULT_HEADERS" \
#      'http://localhost:9000/api/qualitygates/create_condition'

# curl -X POST -u admin:admin \
#      -d "gateId=$QG_ID&metric=$QG_METRIC_2&error=$QG_ERROR_2&op=$QG_OP_2" \
#      -H "$DEFAULT_HEADERS" \
#      'http://localhost:9000/api/qualitygates/create_condition'

# curl -X POST -u admin:admin \
#      -d "gateId=$QG_ID&metric=$QG_METRIC_3&error=$QG_ERROR_3&op=$QG_OP_3" \
#      -H "$DEFAULT_HEADERS" \
#      'http://localhost:9000/api/qualitygates/create_condition'

# curl -X POST -u admin:admin \
#      -d "gateId=$QG_ID&metric=$QG_METRIC_4&error=$QG_ERROR_4&op=$QG_OP_4" \
#      -H "$DEFAULT_HEADERS" \
#      'http://localhost:9000/api/qualitygates/create_condition'

curl -X POST -u admin:admin \
     -d "language=$QP_JAVA_LANGUAGE_ID&qualityProfile=$QP_JAVA_DEFAULT_PROFILE" \
     -H "$DEFAULT_HEADERS" \
     'http://localhost:9000/api/qualityprofiles/set_default'

curl -X POST -u admin:admin \
     -d "language=$QP_TS_LANGUAGE_ID&qualityProfile=$QP_TS_DEFAULT_PROFILE" \
     -H "$DEFAULT_HEADERS" \
     'http://localhost:9000/api/qualityprofiles/set_default'

curl -X POST -u admin:admin \
     -d "language=$QP_JS_LANGUAGE_ID&qualityProfile=$QP_JS_DEFAULT_PROFILE" \
     -H "$DEFAULT_HEADERS" \
     'http://localhost:9000/api/qualityprofiles/set_default'