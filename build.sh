#!/usr/bin/env bash
# Reproducible build with the TeX Live version of the original submission (2020).
# Requires podman (or docker: export ENGINE=docker).
#   ./build.sh          → build/poster.web3d-scatter-plot.pdf (paper, TeX Live 2020)
#   ./build.sh slides   → build/slides/plotter.pdf            (talk slides, TeX Live 2019 = pdfTeX 1.40.20 as the original)
# openout_any=a: the old latexmk runs bibtex from /src, which must then write its .bbl/.blg to /out
set -euo pipefail
cd "$(dirname "$0")"
ENGINE=${ENGINE:-podman}
if [[ ${1:-} == slides ]]; then
  IMAGE=docker.io/texlive/texlive:TL2019-historic dir=slides out=build/slides main=plotter.tex
else
  IMAGE=docker.io/texlive/texlive:TL2020-historic dir=src out=build main=poster.web3d-scatter-plot.tex
fi
mkdir -p "$out"
"$ENGINE" run --rm -e openout_any=a -v "$PWD/$dir:/src:ro,Z" -v "$PWD/$out:/out:Z" -w /src "$IMAGE" \
  latexmk -pdf -interaction=nonstopmode -outdir=/out "$main"
