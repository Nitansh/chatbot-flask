# start by pulling the python image
FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y python3
RUN apt-get -y install python3-pip

# switch working directory
WORKDIR /app

# copy the requirements file into the image
COPY ./requirements.txt /app/requirements.txt
ADD templates /app/templates
ADD static /app/static

RUN pip3 install --trusted-host=pypi.org --trusted-host=files.pythonhosted.org --user pip-system-certs Flask

# install the dependencies and packages in the requirements file
RUN pip3 install --trusted-host=pypi.org --trusted-host=files.pythonhosted.org --user pip-system-certs -r requirements.txt

ENV FLASK_APP=script
ENV FLASK_RUN_HOST 0.0.0.0

# copy every content from the local file to the image
COPY . /app

EXPOSE 8080
ENV PORT 8080

# configure the container to run in an executed manner
ENTRYPOINT [ "python3" ]

CMD ["main.py" ]