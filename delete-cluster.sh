#!/bin/bash

source env.config

kops delete cluster --name ${cluster_name} --yes
