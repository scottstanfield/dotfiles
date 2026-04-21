#!/usr/bin/env bash
limactl shell deb env GITHUB_TOKEN=$(gh auth token) bash -l
