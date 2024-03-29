# start by pulling the python image
FROM python:3.8.3
RUN apt-get install ca-certificates

# switch working directory
WORKDIR /app

# copy the requirements file into the image
COPY ./requirements.txt /app/requirements.txt
# install the dependencies and packages in the requirements file
RUN pip3 install --trusted-host=pypi.org --trusted-host=files.pythonhosted.org --user pip-system-certs -r requirements.txt

# copy every content from the local file to the image
COPY . /app

EXPOSE 8080
ENV PORT 8080

RUN python3 download_nltk.py

# configure the container to run in an executed manner
ENTRYPOINT [ "python3" ]

CMD ["main.py" ]