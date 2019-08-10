#!/bin/bash

(set -x; apt install curl)
(set -x; curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py)
(set -x; python get-pip.py)
(set -x; pip install nanpy)
