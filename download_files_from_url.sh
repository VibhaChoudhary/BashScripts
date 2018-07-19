#!/bin/bash
set -x
url_path="data/sample_url.txt"
destination="data/output"
cd $destination
wget -i $url_path -nd -P $destination

