#!/bin/sh

cd $HOME/Dropbox/projects/github_projects/ebola/data
lftp -e 'mget -d genomes/Viruses/*bola*/*; exit' ftp.ncbi.nih.gov
