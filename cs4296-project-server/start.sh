#!/usr/bin/env bash
# download and install dependencies
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get install -y curl
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env 

uv sync --no-dev 

# run the application
sudo $(which uv) run uvicorn main:app --host 0.0.0.0 --port 8000