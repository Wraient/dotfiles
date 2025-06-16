#!/bin/bash

# Reload v4l2loopback with two devices
sudo modprobe -r v4l2loopback
sudo modprobe v4l2loopback devices=2 video_nr=2,3 exclusive_caps=1

# Start FFmpeg to rotate the feed
ffmpeg -i /dev/video2 -vf "transpose=1" -f v4l2 /dev/video3

