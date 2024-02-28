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

FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/thiawndoumbe/Projet_NLP.git .

RUN pip3 install -r requirements.txt

EXPOSE 8501

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]