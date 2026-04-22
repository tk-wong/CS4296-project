# CS4296 project server
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