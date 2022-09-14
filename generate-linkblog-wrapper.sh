#!/bin/bash

PINBOARD_TOKEN=$(<pinboard.token); export PINBOARD_TOKEN

./generate-linkblog.pl
