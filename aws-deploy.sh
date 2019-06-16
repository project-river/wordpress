SERVICE_NAME=$1
BUILD_NUMBER=$2
CLUSTER=$3
REGION=$4
sed 's/${BUILD_NUMBER}/'${BUILD_NUMBER}'/g;s/${REGION}/'${REGION}'/g' < aws-task-definition-template.json > aws-task-definition.json
echo "aws-task-definition.json generated."

TASK_DEF_RES=`aws ecs register-task-definition --family $SERVICE_NAME --cli-input-json file://aws-task-definition.json --region ${REGION}`
TASK_DEF_ARN=`echo $TASK_DEF_RES | jq -r ".taskDefinition.taskDefinitionArn"`
echo "AWS ECS Task Definition: Done."

SERVICE_UPDATE_RES=`aws ecs update-service --cluster $CLUSTER --service $SERVICE_NAME --task-definition $TASK_DEF_ARN --region ${REGION}`
echo "AWS ECS Service update: Done."
