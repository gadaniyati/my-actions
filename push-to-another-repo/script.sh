#!/bin/sh -l
set -e

echo "> Starting - Push to another repository script"

SRC_DIR="build-dist"
DEST_DIR=""
DEST_REPO_NAME="test-private"
DEST_REPO_USERNAME="destine-u"
DEST_BRANCH="push-from-gh"
USER_EMAIL="gadaniyati@gmail.com"
USER_NAME="gadaniyati"
SERVER="github.com"
COMMIT_MSG="test commit"
echo "> Parameters"

echo "> Git version"
git --version

echo "> Setting Git configuration"
git config --global user.email "$USER_EMAIL"
git config --global user.name "$USER_NAME"
git lfs install


echo "> Destination Repository URL - Using API Token"
REPO_URL="https://$DEST_REPO_USERNAME:$API_TOKEN@$SERVER/$DEST_REPO_USERNAME/$DEST_REPO_NAME.git"
echo $REPO_URL

echo "> Setup directories"
CURR_DIR=$(pwd)
echo "CURR_DIR - $CURR_DIR"
DEST_CLONE_DIR=$(mktemp -d)
echo "DEST_CLONE_DIR - $DEST_CLONE_DIR"

echo "> Cloning destination git repository $DEST_REPO_USERNAME/$DEST_REPO_NAME"
git clone "$REPO_URL" "$DEST_CLONE_DIR"
cd "$DEST_CLONE_DIR"
ls -la

git checkout $DEST_BRANCH || git checkout -b $DEST_BRANCH
git status

echo "[+] Copying contents of source repo folder $SRC_DIR to folder $DEST_DIR in destination git repo $DESTINATION_REPOSITORY_NAME"
if [ -f $CURR_DIR/$SRC_DIR ]; then
    cp -a $CURR_DIR/$SRC_DIR $DEST_CLONE_DIR/$DEST_DIR
elif [ -d $CURR_DIR/$SRC_DIR ]; then
    cp -a $CURR_DIR/$SRC_DIR/* $DEST_CLONE_DIR/$DEST_DIR
fi

# cp -ra "$CURR_DIR/$SRC_DIR" "$DEST_CLONE_DIR/$DEST_DIR"

git status

echo "> Setting Git configuration"
git config --global --add safe.directory "$DEST_CLONE_DIR"

git add .
git commit -m "${COMMIT_MSG}" || echo
git push -u origin $DEST_BRANCH

echo "> Completed - Push to another repository script"