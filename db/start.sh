#!/usr/bin/env bash

export RUST_LOG=info
nohup msd --log-dir ./logs server -p msd.pid -l 0.0.0.0:50511 &
