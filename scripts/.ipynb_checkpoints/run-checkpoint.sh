#!/bin/bash
set -euxo pipefail

COMPILE=false

while getopts "c" flag; do
  case $flag in
    c) COMPILE=true ;;
    *) echo "Usage: bash run.sh [-c]" && exit 1 ;;
  esac
done

# Replace old build artifacts
rm -rf latex/images latex/tables .build pdf
mkdir latex/images latex/tables .build pdf

if [ "$COMPILE" = true ]; then
	docker run --platform linux/amd64 --rm -v "$(pwd):/project" stat-project bash -c "
		Rscript analysis.R &&
		cd /project/latex &&
		for tex_file in *.tex; do
			pdflatex -output-directory=../.build \$tex_file
			pdflatex -output-directory=../.build \$tex_file
			filename=\$(basename \$tex_file .tex)
			cp ../.build/\${filename}.pdf ../pdf/
		done
	"
else
  docker run --platform linux/amd64 --rm -v "$(pwd):/project" stat-project bash -c "
    Rscript analysis.R
  "
fi
