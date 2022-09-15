#!/bin/bash

PINBOARD_TOKEN=$(<pinboard.token); export PINBOARD_TOKEN
LINKBLOG_DIR=$(<linkblog.directory); export LINKBLOG_DIR

./generate-linkblog.pl
