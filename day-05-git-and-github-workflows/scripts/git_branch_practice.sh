#!/bin/bash
# Day 5: Advanced Git Workflow Simulation Script
# (Branching, Stashing, Merging, Tagging & Log Inspection)

set -euo pipefail

LAB_REPO="/tmp/git_devops_lab"

echo "=== [1] Setting up practice repository at $LAB_REPO ==="
rm -rf "$LAB_REPO"
mkdir -p "$LAB_REPO"
cd "$LAB_REPO"

git init -b main

# Configure local identity for test repo
git config user.name "DevOps Student"
git config user.email "student@example.com"

# Base commit
echo "# Microservices Core" > README.md
git add README.md
git commit -m "docs: initial project structure"

# Tag initial release
git tag -a v0.1.0 -m "Initial baseline release"

echo -e "\n=== [2] Creating and working on feature branch: feat/api ==="
git switch -c feat/api

echo "const express = require('express');" > server.js
git add server.js
git commit -m "feat(api): initialize express server"

# Simulate stash workflow
echo "// WIP uncommitted work" >> server.js
echo "Stashing work in progress..."
git stash save "WIP: auth middleware"

echo "Current status after stash:"
git status -s

echo "Popping stashed changes back..."
git stash pop
git commit -am "feat(api): complete auth middleware"

echo -e "\n=== [3] Merging feature back into main branch ==="
git switch main
git merge feat/api -m "merge: integrate feat/api into main"

# Tag production release
git tag -a v1.0.0 -m "Production release version 1.0.0"

echo -e "\n=== [4] Commit History Graph ==="
git log --oneline --graph --decorate --all

echo -e "\n=== [5] Tags Created ==="
git tag -n

echo -e "\n=== Git Practice Lab Complete! ==="
