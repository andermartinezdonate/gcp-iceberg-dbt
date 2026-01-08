#!/usr/bin/env bash
set -e

echo "Bootstrapping environment..."

if [ ! -d ".venv" ]; then
  python3 -m venv .venv
fi

source .venv/bin/activate

python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt

echo "Done."
echo "Activate with: source .venv/bin/activate"
