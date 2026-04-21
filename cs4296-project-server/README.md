# CS4296 project server
## Deploy to AWS lambda
1. create the lambda function with python 3.13 runtime
2. create a deployment package with the following command:
```bash
pip3 install --platform manylinux2014_x86_64 -t dependencies --only-binary=:all: .
```
3. zip the dependencies and upload to lamba function 