#!/bin/bash

if test 4 -eq (test -d /home/{$USER}/Screenshots)
then mkdir /home/{$USER}/Screenshots
fi

scrot -s 'screenshot-%Y-%m-%d-%H_%M.jpg' -q 50 && mv /home/{$USER}/Screenshots/*.jpg

