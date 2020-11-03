#!/bin/bash

TRAVIS_BRANCH="${TRAVIS_BRANCH:?Missing variable TRAVIS_BRANCH}"
TRAVIS_PULL_REQUEST="${TRAVIS_PULL_REQUEST:?Missing variable TRAVIS_PULL_REQUEST}"
NEW_VERSION_TAG="${NEW_VERSION_TAG:?Missing variable NEW_VERSION_TAG}"
NEW_VERSION_DESCRIPTION="${NEW_VERSION_DESCRIPTION:?Missing variable NEW_VERSION_DESCRIPTION}"
GIT_USER_NAME="${GIT_USER_NAME:?Missing variable GIT_USER_NAME}"
GIT_ACCESS_TOKEN="${GIT_ACCESS_TOKEN:?Missing variable GIT_ACCESS_TOKEN}"

# TRAVIS_PULL_REQUEST is false when the source of the pipeline is NOT a pull request
# if the source of the pipeline is a pull request (a non-false answer), set branch to dev
# and deviate to a dry run
if ["${TRAVIS_PULL_REQUEST}" != "false" ]; then
    TRAVIS_BRANCH="dev"
fi

case $TRAVIS_BRANCH in
    "develop" | "dev")
        # Dry run for debug
        echo -n "Dry run push for version ${NEW_VERSION_TAG} with description ${NEW_VERSION_DESCRIPTION}"
        git_configure
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

git_configure() {
    git config --global user.email "travis@travis-ci.org"
    git config --global user.name "Travis CI"
}

git_push_tags() {
    if git checkout -b main; then
        echo -n "Checked out latest version of main branch"
    else
        echo -n "git checkout process failed - exiting!"
        exit 1
    fi
    if git tag ${NEW_VERSION_TAG} -a -m ${NEW_VERSION_DESCRIPTION}; then
        echo -n "Tagged with version ${NEW_VERSION_TAG}"
    else
        echo -n "git tag process failed - exiting!"
        exit 1
    fi
    if git push -q https://${GIT_USER_NAME}:${GIT_ACCESS_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git --tags; then
        echo -n "Release pushed to git successfully"
    else
        echo -n "git push failed - exiting!"
        exit 1
    fi
}
