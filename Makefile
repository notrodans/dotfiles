# Makefile
SHELL := /usr/bin/env bash

REPO_ROOT ?= $(shell git rev-parse --show-toplevel 2>/dev/null || pwd)
export REPO_ROOT

.PHONY: help install adopt

help:
	@echo "Targets: install | adopt"

install:
	$(SHELL) sh/setup/all.sh link
	$(SHELL) sh/setup/all.sh install

adopt:
	$(SHELL) sh/setup/all.sh adopt
