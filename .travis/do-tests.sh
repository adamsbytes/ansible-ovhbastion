#!/bin/bash
DOCKER_CONTAINER_NAME="${DOCKER_CONTAINER_NAME:-ansible-test}"
DOCKER_BUILD_NAME="${1:-testct}"
DOCKER_INVENTORY_FILE="${DOCKER_INVENTORY_FILE:-docker_local}"
DOCKER_PLAYBOOK_FILE="${DOCKER_PLAYBOOK_FILE:-docker-playbook.yml}"
TEST_FILES_DIR="ansible-ovhbastion/tests"
DOCKERFILE_PATH="${TEST_FILES_DIR}/"
INVENTORY_PATH="${TEST_FILES_DIR}/${DOCKER_INVENTORY_FILE}"
PLAYBOOK_OLD_PATH="${TEST_FILES_DIR}/${DOCKER_PLAYBOOK_FILE}"
PLAYBOOK_PATH="${DOCKER_PLAYBOOK_FILE}"

# TRAVIS_PULL_REQUEST is false when the source of the pipeline is NOT a pull request
# if the source of the pipeline is a not a pull request (i.e., main branch),
# don't run the tests
if [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
    echo "No test for main branch!"
    exit 0
fi

# Init a virtual environment
docker build "${DOCKERFILE_PATH}" -t "${DOCKER_BUILD_NAME}"
docker run -ti --privileged --name "${DOCKER_CONTAINER_NAME}" -d -P "${DOCKER_BUILD_NAME}"

# Run ansible role against environment
cp "${PLAYBOOK_OLD_PATH}" .
if [[ -f "${PLAYBOOK_PATH}" ]]; then
    ansible-playbook -i "${INVENTORY_PATH}" "${PLAYBOOK_PATH}" -vvv
else
    echo "Cannot find playbook!"
    echo "PLAYBOOK_PATH: ${PLAYBOOK_PATH}"
    exit 1
fi

# Run tests to verify success

# Kill docker container
docker stop "${DOCKER_CONTAINER_NAME}"
docker rm "${DOCKER_CONTAINER_NAME}"
