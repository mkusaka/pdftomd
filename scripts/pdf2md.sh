#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash scripts/pdf2md.sh --engine <marker|docling|nougat> --input <path> --output <dir> [-- <extra-args>]

Examples:
  bash scripts/pdf2md.sh --engine marker --input /ABS/PATH/to/input.pdf --output /ABS/PATH/to/out_dir
  bash scripts/pdf2md.sh --engine marker --input /ABS/PATH/to/input_dir --output /ABS/PATH/to/out_dir
  bash scripts/pdf2md.sh --engine docling --input /ABS/PATH/to/input.pdf --output /ABS/PATH/to/out_dir
  bash scripts/pdf2md.sh --engine nougat --input /ABS/PATH/to/input.pdf --output /ABS/PATH/to/out_dir

Notes:
  - The command auto-selects single/batch based on whether --input is a file or directory.
  - Use "--" to pass extra args to the underlying CLI.
EOF
}

engine=""
input_path=""
output_dir=""
extra_args=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --engine)
      engine="$2"
      shift 2
      ;;
    --input)
      input_path="$2"
      shift 2
      ;;
    --output)
      output_dir="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      extra_args=("$@")
      break
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$engine" || -z "$input_path" || -z "$output_dir" ]]; then
  echo "Missing required arguments." >&2
  usage
  exit 1
fi

if [[ ! -e "$input_path" ]]; then
  echo "Input path not found: $input_path" >&2
  exit 1
fi

mkdir -p "$output_dir"

case "$engine" in
  marker)
    if [[ -d "$input_path" ]]; then
      cmd=(uv run marker "$input_path" --output_dir "$output_dir")
    else
      cmd=(uv run marker_single "$input_path" --output_format markdown --output_dir "$output_dir")
    fi
    ;;
  docling)
    cmd=(uv run docling --from pdf --to md --output "$output_dir" "$input_path")
    ;;
  nougat)
    cmd=(uvx --isolated --python 3.11 --from nougat-ocr --constraints constraints/nougat.txt nougat "$input_path" -o "$output_dir" --markdown)
    ;;
  *)
    echo "Unknown engine: $engine" >&2
    usage
    exit 1
    ;;
esac

if [[ ${#extra_args[@]} -gt 0 ]]; then
  cmd+=("${extra_args[@]}")
fi
"${cmd[@]}"
