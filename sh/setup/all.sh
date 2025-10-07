#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
. "$(dirname "$0")/../lib/common.sh"
# shellcheck source=./link.sh
. "$(dirname "$0")/link.sh"

usage() { echo "Usage: $0 {link|adopt|unlink|check}"; }

cmd="${1:-}"
case "$cmd" in
  link)   link_all ;;
  adopt)  adopt_all ;;
  unlink) unlink_all ;;
  check)  check_all ;;
  *) usage; exit 2 ;;
esac
