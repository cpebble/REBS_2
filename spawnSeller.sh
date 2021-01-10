#!/bin/bash

JOLIEFILE=CustomSeller.ol
HOST="socket://localhost"
# This is a rough hack, better argument handling should be implemented

# Tell Jolie which port to listen on
echo "{\"location\": \"$HOST:$1\"}" > start.json

# Now run Jolie Seller interface
jolie CustomSeller.ol $2

# Clean-up
rm start.json