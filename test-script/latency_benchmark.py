import argparse
import datetime

import requests
import time
import csv
import boto3
import io

# Initialize S3 client outside the loop for efficiency
s3_client = boto3.client('s3')


def get_image_data(source_type, path_or_key, bucket_name=None):
    """
    Returns image bytes based on the source type.
    """
    # if source_type == 's3':
    #     print(f"Downloading {path_or_key} from S3 bucket {bucket_name}...")
    #     buffer = io.BytesIO()
    #     s3_client.download_fileobj(bucket_name, path_or_key, buffer)
    #     buffer.seek(0)
    #     return buffer.getvalue()
    # else:
    print(f"Reading {path_or_key} from local disk...")
    with open(path_or_key, 'rb') as f:
        return f.read()


def run_benchmark(url, source_type, path_or_key, bucket, csv_name, rounds):
    print(f"Starting benchmark: {rounds} rounds against {url}")
    results = []

    for i in range(rounds):
        print(f"\n--- Round {i + 1} ---")

        # 1. Fetch image data (Memory-efficient approach)
        print(f"Loading image data...")
        image_bytes = get_image_data(source_type, path_or_key, bucket)

        # 2. Perform the request
        print(f"Sending request...")
        start = time.perf_counter()
        try:
            # Send binary data directly
            print(f"Sending request with image data to {url}")
            response = requests.post(url, files={"image": ("upload.jpeg",image_bytes, "image/jpeg")}, headers={
                                                                     'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36'},
                                     timeout=60)
            if response.status_code != 200:
                print(f"Warning: Received status code {response.status_code} with message {response.text}")
            else:
                print(f"Request successful.")
            end = time.perf_counter()

            latency = (end - start) * 1000
            print(f"Total Latency: {latency:.2f}ms")
            results.append([i + 1, latency, response.status_code])

        except Exception as e:
            print(f"Error during request: {e}")

        # 3. 30-minute sleep between rounds (only if more rounds remain)
        if i < rounds - 1:
            print("Sleeping for 30 minutes to force cold start...")
            time.sleep(1800)
            print(f"Round {i + 1} complete.")

    # Save to CSV
    print("Writing results to CSV...")
    
    final_csv_name = csv_name if csv_name else f"latency_test_{datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")}.csv"
    with open(final_csv_name, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['Round', 'Total Latency (ms)', 'Status code'])
        writer.writerows(results)
    print(f"\nDone! Results saved to {final_csv_name}")
    
    # if source_type == 's3':
    #     print("Uploading CSV to S3...")
    #     s3_client.upload_file(csv_name, bucket, csv_name)
        
    print("Benchmark completed successfully.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Benchmark Latency of API Endpoint with image data from local or S3")
    parser.add_argument("--url", required=True, help="API Endpoint URL")
    parser.add_argument("--source", choices=['local', 's3'], required=True, help="Data source type")
    parser.add_argument("--path", required=True, help="Local file path or S3 key")
    # parser.add_argument("--bucket", help="S3 Bucket name (required if source is s3)")
    parser.add_argument("--csv", help="Output CSV filename")
    parser.add_argument("--rounds", type=int, default=5, help="Number of test rounds")

    args = parser.parse_args()

    # Validation
    # if args.source == 's3' and not args.bucket:
    #     parser.error("The --bucket argument is required when --source is 's3'")

    run_benchmark(args.url, args.source, args.path, None, args.csv, args.rounds)

# image link: https://unsplash.com/photos/water-reflection-of-coconut-palm-trees-wAn4RfmXtxU?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
