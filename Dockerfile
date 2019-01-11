# Lets start small ;-)
FROM python:3.6-alpine
# Copy the flask app into the container
COPY app /app
# Set the appdir as our root
WORKDIR /app
# Install flask
#RUN pip install -r requirements.txt
# Make sure the flask app runs at startup
ENTRYPOINT ["python"]
CMD ["app.py"]