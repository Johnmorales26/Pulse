#!/usr/bin/env bash
set -uo pipefail

workspace="${1:-$PWD}"
cd "$workspace"

timestamp="$(date +%Y%m%d_%H%M%S)"
report_dir=".flutter_pipeline_reports"
run_dir="$report_dir/$timestamp"
mkdir -p "$run_dir"

summary_file="$run_dir/summary.txt"
errors_file="$run_dir/errors.txt"
report_file="$run_dir/error_report.md"
status_file="$run_dir/status.env"

: > "$summary_file"
: > "$errors_file"

append_summary() {
  printf '%s\n' "$1" >> "$summary_file"
}

append_error() {
  printf '%s\n' "$1" >> "$errors_file"
}

run_step() {
  local step_num="$1"
  local label="$2"
  shift 2
  local log_file="$run_dir/step_${step_num}.log"

  {
    echo "COMMAND: $*"
    echo "WORKDIR: $workspace"
    echo "----- OUTPUT -----"
  } > "$log_file"

  "$@" >> "$log_file" 2>&1
  local code=$?

  append_summary "${step_num}|${label}|$*|${code}|${log_file}"

  if [ "$code" -ne 0 ]; then
    append_error "${step_num}|${label}|$*|${code}|${log_file}"
    return "$code"
  fi
  return 0
}

check_exists() {
  local label="$1"
  local path="$2"
  if [ -e "$path" ]; then
    append_summary "check|${label}|exists ${path}|0|"
    return 0
  fi
  append_error "check|${label}|missing ${path}|1|"
  return 1
}

check_gdart_files() {
  local count
  count="$(find lib test -type f -name '*.g.dart' 2>/dev/null | wc -l | tr -d ' ')"
  if [ "${count:-0}" -gt 0 ]; then
    append_summary "check|generated-dart|found ${count} *.g.dart files|0|"
    return 0
  fi
  append_error "check|generated-dart|no *.g.dart files found under lib/ or test/|1|"
  return 1
}

check_command() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    append_summary "precheck|${cmd}|command available|0|"
    return 0
  fi
  append_error "precheck|${cmd}|command not found|127|"
  return 1
}

write_status() {
  local result="$1"
  {
    echo "RESULT=$result"
    echo "REPORT_FILE=$report_file"
    echo "RUN_DIR=$run_dir"
  } > "$status_file"
}

failure=0

check_command flutter || failure=1
check_command dart || failure=1

if [ "$failure" -eq 0 ]; then
  run_step 1 "flutter clean" flutter clean || failure=1
fi
if [ "$failure" -eq 0 ]; then
  run_step 2 "flutter pub get" flutter pub get || failure=1
fi
if [ "$failure" -eq 0 ]; then
  run_step 3 "flutter pub upgrade" flutter pub upgrade || failure=1
fi
if [ "$failure" -eq 0 ]; then
  run_step 4 "dart run build_runner clean" dart run build_runner clean || failure=1
fi
if [ "$failure" -eq 0 ]; then
  run_step 5 "dart run build_runner build --delete-conflicting-outputs" dart run build_runner build --delete-conflicting-outputs || failure=1
fi

if [ "$failure" -eq 0 ]; then
  check_exists "assets-gen" "lib/gen/assets.gen.dart" || failure=1
fi
if [ "$failure" -eq 0 ]; then
  check_gdart_files || failure=1
fi

if [ "$failure" -eq 0 ]; then
  write_status success
  echo "✅ Success"
  exit 0
fi

{
  echo "# Flutter pipeline error report"
  echo
  echo "- Workspace: \`$workspace\`"
  echo "- Run directory: \`$run_dir\`"
  echo
  echo "## Failed checks"
  echo

  while IFS='|' read -r step label command code log; do
    [ -n "$step" ] || continue
    echo "### ${label}"
    echo
    echo "- Step: \`${step}\`"
    echo "- Command/check: \`${command}\`"
    echo "- Exit code: \`${code}\`"
    if [ -n "$log" ]; then
      echo "- Log: \`${log}\`"
      echo
      echo "#### Last log lines"
      echo
      echo '```text'
      tail -n 40 "$log"
      echo '```'
      echo
    fi
  done < "$errors_file"

  echo "## Step summary"
  echo
  echo "| Step | Label | Command/check | Exit code |"
  echo "| --- | --- | --- | --- |"
  while IFS='|' read -r step label command code log; do
    [ -n "$step" ] || continue
    printf '| %s | %s | `%s` | %s |\n' "$step" "$label" "$command" "$code"
  done < "$summary_file"
} > "$report_file"

write_status error
cat "$report_file"
exit 1
