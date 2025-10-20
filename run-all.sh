#!/usr/bin/env bash
# run-all.sh - Run all scripts to create GEDA and QVI AIDs

# GEDA and QVI Setup
./task-scripts/geda/geda-aid-create.sh
./task-scripts/verifier/recreate-with-geda-aid.sh
./task-scripts/qvi/qvi-aid-delegate-create.sh
./task-scripts/geda/geda-delegate-approve.sh
./task-scripts/qvi/qvi-aid-delegate-finish.sh
./task-scripts/geda/geda-oobi-resolve-qvi.sh

# QVI Credential
./task-scripts/geda/geda-registry-create.sh
./task-scripts/geda/geda-acdc-issue-qvi.sh # includes the IPEX Grant
./task-scripts/qvi/qvi-acdc-admit-qvi.sh
./task-scripts/qvi/qvi-oobi-resolve-verifier.sh
./task-scripts/qvi/qvi-acdc-present-qvi.sh
exit 0

# LE and LE credential
./task-scripts/le/le-aid-create.sh
./task-scripts/qvi/qvi-registry-create.sh
./task-scritpts/qvi/qvi-acdc-issue-le.sh
./task-scripts/le/le-acdc-admit-le.sh
./task-scripts/le/le-acdc-present-le.sh

# Person and OOR Credential
./task-scripts/person/person-aid-create.sh
./task-scripts/le/le-registry-create.sh
./task-scripts/le/le-acdc-issue-oor-auth.sh
./task-scripts/qvi/qvi-acdc-admit-oor-auth.sh
./task-scripts/qvi/qvi-acdc-issue-oor.sh
./task-scripts/person/person-acdc-admit-oor.sh

# Person and ECR Credential
./task-scripts/le/le-acdc-issue-ecr-auth.sh
./task-scripts/qvi/qvi-acdc-admit-ecr-auth.sh
./task-scripts/qvi/qvi-acdc-issue-ecr.sh
./task-scripts/person/person-acdc-admit-ecr.sh

# Person present OOR Credential to verifier (Sally)
./task-scripts/person/person-acdc-present-oor.sh
