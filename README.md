# CS 4296 project

This repository contains the code for the CS 4296 project. The project is a study on the latency between the VM instance and the serverless serives. 

## Structure
The repository is structured as follows:
- `cs4296-project-server`: This directory contains the code for the web server that will be used to measure the latency.
- `demo-script`: This directory contains the code for the demo script that will be used to demo the server functionality.
- `AWS-ECS-task`: This directory contains the JSON configuration for the AWS ECS task that will be used to deploy the server on AWS.
- `experiment-data`: This directory contains the data collected from the experiments.
- `test-script`: This directory contains the code for the test script that will be used to conduct the cold start test and load test.

## Deployment
The brief idea of experiment workflow is as follows:
1.	Set up all the servers in EC2 instances, AWS ECS, and AWS Lambda
2.	Set up another EC2 instance in the same region of the servers
3.	Use the script to do experiments
4.	Review the result printed out and stored in the CSV file

All the server, except AWS Lambda, will listen the port 8000. You can use http:<ip-address>:8000/image to access the path that process the image (replace <ip-address> with the actual IP address of the server.)

### Set up EC2 instance (deploy directly)
1.	Initialize the instance with Ubuntu 24.04 as the operating system and t3.small as instance type
2.	Set the inbound rule of the instance to allow listening from port 8000
3.	Start the instance and use ssh to connect to it
4.	Clone the repository into the instance
5.	cd into CS4296-project/cs4296-project-server
6.	use the provided test script to start the server. It will update and upgrade all the software inside the instance to ensure all the functionality can be worked as expected. Then, it will install uv, a Python package and project manager. Finally, it use uv to install all the dependencies and start the server.
### Set up EC2 instance (deploy using docker)
1.	Initialize the instance with Ubuntu 24.04 as the operating system and t3.small as instance type
2.	Set the inbound rule of the instance to allow listening from port 8000
3.	Start the instance and use ssh to connect to it
4.	Install docker by following the instructions in the following link: https://docs.docker.com/engine/install/ubuntu/
5.	Run the container using the following command: `docker run -p 8000:8000 ghcr.io/tk-wong/cs4296-project-server:latest`
### AWS Fargate with AWS ECS and elastic container registry (ECR)
1.	Create a new repository in ECR
2.	Clone the repository into the cloudshell in the AWS console
3.	Follow the instructions in the ECR repository to add the container into the repository
4.	Create a new ECS task using the provided JSON file ("AWS-ECS-task/cs4296-project-deploy-container.json")
5.	Create a new cluster in AWS ECS
6.	Run a service that uses Fargate and the task in the service to deploy the server
### AWS lambda
1.	Import the provided zip file ("cs4296-project-server\dependencies.zip") into the function
2.	Press “Deploy” to deploy it
3.	Create a function URL in Configuration > Function URL
4.	Set the Auth type of the URL to be NONE to ensure it can be accessed anywhere
5.	Use the created URL to access the service
8.2.5	Running testing script in EC2 instance
1.	Initialize the instance with Ubuntu 24.04 as the operating system and t3.small as instance type
2.	Set the inbound rule of the instance to allow listening from port 8000
3.	Start the instance and use ssh to connect to it
4.	Install uv following the instructions in the following link: https://docs.astral.sh/uv/#installation 
5.	Clone the repository into the instance
6.	cd into CS4296-project/test-script
7.	use the following command to install the dependencies: uv sync
8.	run the following commands to for load test and cold start test respectively
