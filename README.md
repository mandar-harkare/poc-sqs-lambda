
# POC


## Build

```npm install```

## Test

### Unit:

```npm run test```

Individual Test:
You can invoke individual tests as follows:
```npm run test -- -t 'the test description'```

e.g. 
```npm run test -- -t 'when they go to an invalid HTTP endpoint then the result is 500'```

  
## Static Code Analysis

ESLint:
```npm run verify``` or ```npm run verify-fix```

## Deployment

```
cd deploy/terraform
terraform init
terraform workspace new poc_work
terraform workspace select poc_work
terraform plan
terraform deploy
```
## Testing

The POC lambda can be manually tested by sending a message to the message queue.

For example:

```bash
aws sqs send-message --queue-url https://sqs.{aws-region}.amazonaws.com/{accCode}/{queueName} --message-body "HelloWorld"
```
Your lambda should be triggered by once this message reaches the queue and then the lambda should process the message, in our case it will just print the message.

### Where to check the logged messages?
 Login to AWS console >> Search for Lambda >> Type in your lambda name >> Click on Monitoring >> Click on cloud watch logs >> Select the latest log group and you should see your message.