# The Google Cloud Platform Python runtime is based on Debian Jessie
# You can read more about the runtime at:
#   https://github.com/GoogleCloudPlatform/python-runtime
FROM gcr.io/google_appengine/python

ADD . /users/
WORKDIR /users

# ENV PROJECT_HOME=/users
RUN make install-dev PROJECT_HOME=/users && \
    make proto PROJECT_HOME=/users

# Setting these environment variables are the same as running
# source /env/bin/activate.
ENV VIRTUAL_ENV /users/.venv3
ENV PATH /users/.venv3/bin:$PATH

ENTRYPOINT ["users-server"]
