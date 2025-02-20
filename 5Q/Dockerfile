# Use Ubuntu as the base image
FROM ubuntu:latest

# Set working directory
WORKDIR /app

# Install required packages
RUN apt-get update && apt-get install -y bash nano

# Copy script and CSV file into the container
COPY menu_script.sh /app/menu_script.sh
COPY data.csv /app/data.csv

# Give execution permissions to the script
RUN chmod +x /app/menu_script.sh

# Run the script inside the container
CMD ["/bin/bash", "/app/menu_script.sh"]
