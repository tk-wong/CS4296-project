# Demo script

This directory contains the code for the demo script that will be used to demo the server functionality. The script will send a request to the server and print out the result (The header and the metadata of the image received). 

## Installation
1. Install uv following the instructions in the following link: https://docs.astral.sh/uv/#installation
2. Clone the repository into the instance
3. cd into CS4296-project/demo-script
4. set the `.env` file with reference on the `.env.example` file. The `.env` file should contain the URL of the server that you want to demo. For example, if you want to demo the server deployed on AWS Lambda, you can set the URL to be the function URL created in the deployment step.
    ```
    URL=http://<function-url>
    ```
5. rename the `.env-template` file to `.env`.
6. use the following command to install the dependencies: `uv sync`
7. run the following command to start the demo: `uv run demo-request.py`