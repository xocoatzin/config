# The Google Cloud Platform Python runtime is based on Debian Jessie
# You can read more about the runtime at:
#   https://github.com/GoogleCloudPlatform/python-runtime
FROM gcr.io/google_appengine/python

# Create a virtualenv for dependencies. This isolates these packages from
# system-level packages.
RUN virtualenv -p python3.6 /env

# Setting these environment variables are the same as running
# source /env/bin/activate.
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

RUN pip install --upgrade pip

# Install dependencies to have them cached
RUN pip install --upgrade pip \
    && pip install grpcio \
    && pip install grpcio-tools \
    && pip install google-auth \
    && pip install googleapis-common-protos \
    && pip install six \
    && pip install future \
    && pip install requests \
    && pip install requests[security] \
    && pip install google-auth \
    && pip install google-cloud-datastore \
    && pip install arrow

ADD . /users/
RUN pip install /users/[all] -v

ENTRYPOINT ["users-server"]
