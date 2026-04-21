import argparse
import requests
import time
from concurrent.futures import ThreadPoolExecutor

def send_request(url, image_bytes):
    start = time.perf_counter()
    try:
        # Match the 'image' field expected by FastAPI
        files = {"image": ("upload.jpeg", image_bytes, "image/jpeg")}
        response = requests.post(url, files=files, timeout=60)
        return (time.perf_counter() - start) * 1000, response.status_code
    except Exception as e:
        return None, str(e)

def run_load_test(url, image_bytes, num_requests, concurrency):
    print(f"Starting load test: {num_requests} requests, {concurrency} concurrent...")
    with ThreadPoolExecutor(max_workers=concurrency) as executor:
        futures = [executor.submit(send_request, url, image_bytes) for _ in range(num_requests)]
        results = [f.result() for f in futures]

    # Calculate stats
    successful = [r[0] for r in results if r[0] is not None]
    print(f"Avg Latency: {sum(successful)/len(successful):.2f}ms")