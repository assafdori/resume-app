# Use a smaller base image
FROM python:3.8-alpine as builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy only the requirements file
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Use a smaller base image for the final image
FROM python:3.8-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.8/site-packages/ /usr/local/lib/python3.8/site-packages/

# Copy the Python script
COPY . .

# Run the Python script
CMD [ "python", "-u", "./health-check.py" ]
