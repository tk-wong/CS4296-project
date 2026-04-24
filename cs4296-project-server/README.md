# CS4296 project server

This directory contains the code for the web server that will be used for testing the latency.


Other than the deployment instructions in the root README, we provide extra instructions for deploying the server to AWS Lambda and using Docker to deploy the server in EC2 instance by building the docker image and the zip file for AWS Lambda deployment from source.

## Deploy to AWS lambda
1. create the lambda function with python 3.13 runtime
2. create a deployment package with the following command:
    ```bash
    pip3 install --platform manylinux2014_x86_64 -t dependencies --only-binary=:all: .
    ```
3. zip the dependencies and upload to lamba function 
4. press "Deploy" to deploy the function

## Docker
1. build the docker image with the following command:
    ```bash 
     sudo docker build -t project-server:project-server .
    ```
2. run the docker container with the following command:
    ```bash
    sudo docker run -d --name project-server -p 8000:8000 project-server:project-server
    ```

## paths
-  `/`: this path will return a simple string "Hello, World!" to test the connectivity of the server.
- `/image`: this path will receive a JPEG image and process the image by resizing it to smaller than or equal to 300x300 and return the processed image converted to PNG format.