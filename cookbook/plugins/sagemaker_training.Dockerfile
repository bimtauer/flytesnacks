FROM python:3.8-buster

WORKDIR /root
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONPATH /root

# Install the AWS cli separately to prevent issues with boto being written over
RUN pip install awscli

# Setup a virtual environment
ENV VENV /opt/venv
# Virtual environment
RUN python3 -m venv ${VENV}
ENV PATH="${VENV}/bin:$PATH"

# Install Python dependencies
COPY sagemaker_training/requirements.txt /root
RUN pip install -r /root/requirements.txt

# Setup Sagemaker entrypoints
ENV SAGEMAKER_PROGRAM /opt/venv/bin/flytekit_sagemaker_runner.py
RUN pip install --upgrade sagemaker-training==3.6.2 natsort

# Copy the actual code
COPY sagemaker_training/ /root/sagemaker_training
COPY sagemaker_training/Makefile /root

# This tag is supplied by the build script and will be used to determine the version
# when registering tasks, workflows, and launch plans
ARG tag
ENV FLYTE_INTERNAL_IMAGE $tag
