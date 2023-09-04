#!/bin/bash

slim  build --target mobileann --show-clogs  --include-path-file 'r_path_includes.txt' --publish-port 3838 --http-probe=false
