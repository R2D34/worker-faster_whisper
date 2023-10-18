

import os
import sys
import time
from faster_whisper import WhisperModel
from runpod.serverless.utils import rp_cuda
import datetime



if __name__ == "__main__":
    #generate random id 

    # REturn error if this is run as script with fewer than 2 arguments
    if len(sys.argv) < 3:
        print("Usage: python3 whisper_runner.py <file_name> <current_batching>")
        sys.exit(1)

    
    
    #Start counting execution time with time 
    scenario = f"small--batch-{sys.argv[2]}--file-{sys.argv[1]}"

    logs_path = os.path.join("logs", scenario)
    results_path = os.path.join("results", scenario)
    #Make sure path directories exist
    os.makedirs(os.path.dirname(logs_path), exist_ok=True)
    os.makedirs(os.path.dirname(results_path), exist_ok=True)
    
    with open(f"logs/{scenario}", "w") as f:

        
        # Record the start time
        start_time = time.time()

        # Your code or function to measure the time for goes here


        # Convert start time and elapsed time to human-readable formats
        start_time_str = datetime.datetime.fromtimestamp(start_time).strftime('%Y-%m-%d %H:%M:%S')

        init_msg = f"Start time:: {start_time_str}\n"

        f.write(init_msg)



        # Get the file_name from argv1
        audio_input = sys.argv[1]
        model = WhisperModel(
                    "small",
                    device="cuda" if rp_cuda.is_available() else "cpu",
                    compute_type="float16" if rp_cuda.is_available() else "int8")
        whisper_results = model.transcribe(audio_input)
        with open(f"results/{scenario}", "w") as rf:

            for result in whisper_results:
                print(result)
                rf.write(result)
                rf.write("\n")
                    # Calculate elapsed time in seconds
        end_time = time.time()
        elapsed_seconds = end_time - start_time
        elapsed_time_str = str(datetime.timedelta(seconds=elapsed_seconds))
        end_time_str = datetime.datetime.fromtimestamp(end_time).strftime('%Y-%m-%d %H:%M:%S')
        f.write(f"Elapsed time (seconds): {elapsed_seconds}\n")
        f.write(f"End time: {end_time_str}\n")

