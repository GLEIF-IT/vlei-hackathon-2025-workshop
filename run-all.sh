#!/usr/bin/env bash
# run-all.sh - Run all scripts to create GEDA and QVI AIDs

# GEDA and QVI Setup
./task-scripts/geda/geda-aid-create.sh
./task-scripts/qvi/qvi-aid-delegate-create.sh
./task-scripts/geda/geda-delegate-approve.sh
./task-scripts/qvi/qvi-aid-delegate-finish.sh

# QVI Credential
./task-scripts/geda/geda-registry-create.sh
./task-scripts/geda/geda-acdc-issue-qvi.sh
exit 0
./task-scripts/qvi/qvi-admit-qvi.sh
./task-scripts/qvi/qvi-present-qvi.sh

# LE and LE credential
./task-scripts/le/le-create-aid.sh
./task-scripts/qvi/qvi-create-registry.sh
./task-scritpts/qvi/qvi-issue-le.sh
./task-scripts/le/le-admit-le.sh
./task-scripts/le/le-present-le.sh

# Person and OOR Credential
./task-scripts/person/person-create-aid.sh
./task-scripts/le/le-create-registry.sh
./task-scripts/le/le-issue-oor-auth.sh
./task-scripts/qvi/qvi-admit-oor-auth.sh
./task-scripts/qvi/qvi-issue-oor.sh
./task-scripts/person/person-admit-oor.sh

# Person and ECR Credential
./task-scripts/le/le-issue-ecr-auth.sh
./task-scripts/qvi/qvi-admit-ecr-auth.sh
./task-scripts/qvi/qvi-issue-ecr.sh
./task-scripts/person/person-admit-ecr.sh

# Person present OOR Credential to verifier (Sally)
./task-scripts/person/person-present-oor.sh
