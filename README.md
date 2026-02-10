# pdftomd

PDF to Markdown helper scripts for uv projects.

## Setup

Install any engines you plan to use:

```bash
uv add marker-pdf
uv add docling
uv add nougat-ocr
```

Nougat uses an isolated `uvx` run with constraints in `constraints/nougat.txt` and
Python 3.11 to avoid transformers/tokenizers compatibility issues with other engines.

## Usage

Single file or batch is auto-selected based on whether `--input` is a file or directory.
The output directory is created if it does not exist.

```bash
bash scripts/pdf2md.sh --engine marker --input /ABS/PATH/to/input.pdf --output /ABS/PATH/to/out_dir
bash scripts/pdf2md.sh --engine marker --input /ABS/PATH/to/input_dir --output /ABS/PATH/to/out_dir

bash scripts/pdf2md.sh --engine docling --input /ABS/PATH/to/input.pdf --output /ABS/PATH/to/out_dir
bash scripts/pdf2md.sh --engine docling --input /ABS/PATH/to/input_dir --output /ABS/PATH/to/out_dir

bash scripts/pdf2md.sh --engine nougat --input /ABS/PATH/to/input.pdf --output /ABS/PATH/to/out_dir
bash scripts/pdf2md.sh --engine nougat --input /ABS/PATH/to/input_dir --output /ABS/PATH/to/out_dir
```

## Passing extra CLI args

Use `--` to pass extra options to the underlying CLI.

```bash
bash scripts/pdf2md.sh --engine marker --input /ABS/PATH/to/input.pdf --output /ABS/PATH/to/out_dir -- --force_ocr
bash scripts/pdf2md.sh --engine docling --input /ABS/PATH/to/input.pdf --output /ABS/PATH/to/out_dir -- --image-export-mode referenced
bash scripts/pdf2md.sh --engine docling --input /ABS/PATH/to/input.pdf --output /ABS/PATH/to/out_dir -- --ocr --ocr-lang ja
```

## Local artifacts

This repo ignores `data/` for local inputs/outputs.
