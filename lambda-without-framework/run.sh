#1 - Criar JSON de politicas de segurança
#2 - Criar role de segurança AWS

aws iam create-role \
  --role-name lambda-sem-framework \
  --assume-role-policy-document file://policy.json \
  | tee logs/role.log

#3 - zipar e criar funcao lambda aws
zip function.zip index.js

aws lambda create-function \
  --function-name hello-sem-framework \
  --zip-file fileb://function.zip \
  --handler index.handler \
  --runtime nodejs12.x \
  --role arn:aws:iam::774536537032:role/lambda-sem-framework \
  | tee logs/lambda-create.log

#4 run lambda
aws lambda invoke \
  --function-name hello-sem-framework \
  --log-type Tail \
  logs/lambda-exec.log

#5 após atualizar arquvio precisa zipar novamente
zip function.zip index.js

#6 atualizar funcao lambda aws
aws lambda update-function-code \
  --zip-file fileb://function.zip \
  --function-name hello-sem-framework \
  --publish \
  | tee logs/lambda-update.log

#7 remove function
aws lambda delete-function \
  --function-name hello-sem-framework

#8 remove role
aws iam delete-role \
  --role-name lambda-sem-framework