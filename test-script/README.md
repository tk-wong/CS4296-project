# Test Script

This directory contains the code for the test script that will be used to conduct the cold start test and load test. The test script is written in Python and uses the `uv` package manager to manage the dependencies. The test script will send requests to the server and measure the latency of the responses. The results will be printed out and stored in a CSV file for further analysis.

## Usage

load test:
``` 
uv run ./load_test_benchmark.py --url  <url> --path ../assets/test_image.jpg --csv <csv_name> --requests <request> --concurrency <workers>
```
cold test:
```
 uv run ./cold_start_benchmark.py --url  <url> --path ../assets/test_image.jpg --csv <csv-name> --rounds <round>
 ```
The parameters that need to be replaced can be found in the following table:
| Parameter    | Meaning |
|---|---|
| `<url>`      | The URL to access the server (`http://<ip-address>:8000/image`) **(required)** |
| `<csv_name>` | Output CSV filename *(optional, default: `<test>_<date>.csv`)* |
| `<request>`  | Total number of requests *(optional, default: `50`)* |
| `<workers>`  | Number of workers *(optional, default: `5`)* |
| `<round>`    | Number of rounds for the cold start test *(optional, default: `10`)* |

## Installation
1. Download and install `uv` by following the instructions in the following link: https://docs.astral.sh/uv/#installation
2. Clone the repository into your local machine
3. cd into CS4296-project/test-script
4. Use the following command to install the dependencies: `uv sync`
5. Run the test script using the commands provided in the Usage section above.