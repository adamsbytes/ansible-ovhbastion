#!/bin/bash

TRAVIS_BRANCH="${TRAVIS_BRANCH:?Missing variable}"
TRAVIS_PULL_REQUEST="${TRAVIS_PULL_REQUEST:?Missing variable}"
NEW_VERSION_TAG="${NEW_VERSION_TAG:?Missing variable}"
NEW_VERSION_DESCRIPTION="${NEW_VERSION_DESCRIPTION:?Missing variable}"
GIT_USER_NAME="${GIT_USER_NAME:?Missing variable}"
GIT_ACCESS_TOKEN="${GIT_ACCESS_TOKEN:?Missing variable}"

# TRAVIS_PULL_REQUEST is false when the source of the pipeline is NOT a pull request
# if the source of the pipeline is a pull request (a non-false answer), set branch to dev
# and deviate to a dry run
if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
    TRAVIS_BRANCH="dev"
fi

git_configure() {
    git config --global user.email "travis@travis-ci.org"
    git config --global user.name "Travis CI"
}

git_push_tags() {
    if git checkout -f main; then
        echo "Checked out latest version of main branch"
    else
        echo "git checkout process failed - exiting!"
        exit 1
    fi
    if git tag "${NEW_VERSION_TAG}" -a -m "${NEW_VERSION_DESCRIPTION}"; then
        echo "Tagged with version ${NEW_VERSION_TAG}"
    else
        echo "git tag process failed - exiting!"
        exit 1
    fi
    if git push -q https://"${GIT_USER_NAME}":"${GIT_ACCESS_TOKEN}"@github.com/"${TRAVIS_REPO_SLUG}".git --tags; then
        echo "Release pushed to git successfully"
    else
        echo "git push failed - exiting!"
        exit 1
    fi
}

case $TRAVIS_BRANCH in
    "develop" | "dev")
        # Dry run for debug
        echo "Dry run push for version ${NEW_VERSION_TAG} with description ${NEW_VERSION_DESCRIPTION}"
        git_configure
        git status
        ;;

    "main")
        # Push tags to git
        git_configure
        git_push_tags
        ;;

    *)
        # Error due to invalid branch
        echo "Invalid branch. Current value of TRAVIS_BRANCH: $TRAVIS_BRANCH"
        exit 1
        ;;
esac
