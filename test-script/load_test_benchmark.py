import argparse
import datetime

import requests
import time

import csv

from concurrent.futures import ThreadPoolExecutor


def get_image_data(path_or_key):
    with open(path_or_key, 'rb') as f:
        return f.read()


def send_request(url, image_bytes):
    """Sends a single POST request to the API."""
    try:
        start = time.perf_counter()
        # Ensure 'image' matches the FastAPI UploadFile field name
        files = {"image": ("upload.jpeg", image_bytes, "image/jpeg")}
        response = requests.post(url, files=files, timeout=60)
        latency = (time.perf_counter() - start) * 1000
        return latency, response.status_code
    except Exception as e:
        return None, str(e)


def run_load_test(arguments):
    print(f"\n{'=' * 50}")
    print(f"STARTING LOAD TEST")
    print(f"URL: {arguments.url}")
    print(f" Concurrency: {arguments.concurrency}")
    print(f"Target: {arguments.requests} requests")
    print(f"{'=' * 50}\n")
    # print(f"Start Timestamp: {int(time.time())}")

    print("Fetching image data...")
    img_data = get_image_data(arguments.path)
    print(f"Successfully loaded image data ({len(img_data)} bytes).")

    results = []

    # Progress counter
    completed = 0

    with ThreadPoolExecutor(max_workers=arguments.concurrency) as executor:
        print(f"Spawning {arguments.concurrency} worker threads...")
        futures = [executor.submit(send_request, arguments.url, img_data) for _ in range(arguments.requests)]

        for future in futures:
            latency, status = future.result()
            results.append((latency, status))

            # Progress logging
            completed += 1
            if completed % 10 == 0 or completed == arguments.requests:
                print(f"Progress: {completed}/{arguments.requests} requests completed...")

    # Log completion
    print(f"\n{'=' * 50}")
    print("LOAD TEST FINISHED")

    # Summary calculation
    latencies = [r[0] for r in results if r[0] is not None]
    if latencies:
        avg = sum(latencies) / len(latencies)
        print(f"Average Latency: {avg:.2f} ms")
        print(f"Max Latency: {max(latencies):.2f} ms")
    else:
        print("No latency is found. There may be an error occurred during the requests.")
        print(f"{'=' * 50}")
        exit(1)

    # CSV Writing
    output_filename = arguments.csv if arguments.csv else f"load_test_{datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")}.csv"
    print(f"Writing results to {output_filename}...")
    with open(output_filename, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['Timestamp', 'Latency (ms)', 'Status_Code'])
        for lat, status in results:
            writer.writerow([time.time(), lat, status])

    # print(f"End Timestamp: {int(time.time())}")
    print(f"{'=' * 50}\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Performance Load Test for FastAPI")
    parser.add_argument("--url", required=True, help="API Endpoint URL")
    parser.add_argument("--path", required=True, help="Local file path")
    parser.add_argument("--requests", type=int, default=50, help="Total number of requests")
    parser.add_argument("--concurrency", type=int, default=5, help="Number of concurrent workers")
    parser.add_argument("--csv", help="Output filename")

    args = parser.parse_args()
    run_load_test(args)
