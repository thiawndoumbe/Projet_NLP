# Use an official Python runtime as a parent image
# FROM python:3.9-slim


# # Use an official Python runtime as a parent image
# FROM python:3.8

# # Set the working directory to /app
# WORKDIR /app

# # Copy the current directory contents into the container at /app
# COPY . /app

# # Install any needed packages specified in requirements.txt
# RUN pip install --no-cache-dir -r requirements.txt


# # Set the working directory in the container
# WORKDIR /app

# # Copy the current directory contents into the container
# COPY . /app

# # Install any needed packages specified in requirements.txt
# RUN pip install --no-cache-dir -r requirements.txt

# # Make port 8000 available to the world outside this container
# EXPOSE 8000

# # Define environment variable
# ENV NAME World

# # Run app.py when the container launches
# CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]


# app/Dockerfile

# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory to /app
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone your project from GitHub
RUN git clone https://github.com/thiawndoumbe/Projet_NLP.git .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that FastAPI will run on
EXPOSE 8000

# Set the environment variable for the FastAPI application
ENV UVICORN_CMD="uvicorn app:app --host 0.0.0.0 --port 8000 --reload"

# Start the FastAPI application
CMD ["bash", "-c", "$UVICORN_CMD"]
