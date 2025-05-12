#!/bin/bash

USE_CASE="$1"

[ -f "reports/use-case/${USE_CASE}.md" ] &&
[ -f "reports/robustness/${USE_CASE}.drawio.png" ] &&
[ -f "reports/sequence/${USE_CASE}.plantuml" ] && echo "OK"
