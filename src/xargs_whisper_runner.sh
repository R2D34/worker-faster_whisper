number_of_processes=$1

find media_outputs -name 'test-*.mp3' | sort | head -n <number_of_files> | xargs -I {} -P $number_of_processes python3 single_whisper_runner.py {} $number_of_processes
