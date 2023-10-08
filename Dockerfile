# Use specific version of nvidia cuda image
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# Set shell and noninteractive environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /

# Update and upgrade the system packages (Worker Template)
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y ca-certificates curl bash ffmpeg python3-pip && \
    apt-get autoremove -y && \
    apt-get clean -y

# Install Python dependencies (Worker Template)
COPY builder/requirements.txt /requirements.txt

RUN pip install -r /requirements.txt --no-cache-dir && \
    rm /requirements.txt

# Copy and run script to fetch models
COPY builder/fetch_small_model.py /fetch_small_model.py

RUN python3 /fetch_small_model.py && \
    rm /fetch_small_model.py

# Copy source code into image
COPY src .

# Set default command
CMD python -u /rp_handler.py