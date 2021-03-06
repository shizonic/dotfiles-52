#!/bin/sh -e
#
# Install python packages
#

BASE_DIR=${BASE_DIR:-$(cd "$(dirname "$0")/../../../.." || exit; pwd -P)}

cd "$(dirname "$0")" || exit 1
. "../../lib/utils.sh"
. "../../lib/buildenv.sh"

PYTOOLS3=$HOME/.local/lib/pytools3
PIP3=$PYTOOLS3/bin/pip3

_preflight() {
    if ! command -v python3 >/dev/null; then
       printe_h2 "python3 is not installed, skipping python packages..."
       return 1
    fi

    if ! python3 -c 'import venv' 2>/dev/null; then
       printe_h2 "python3 venv is not available, skipping python packages..."
       return 1
    fi
}

_run() {
    _install_pytools3
    _install_pytools3_packages
}

_run_dev() {
    printe_h2 "Installing python dev packages..."

    $PIP3 install --upgrade \
         black \
         flake8 \
         kapitan \
         pip \
         poetry \
         pre-commit \
         proselint \
         pyls-black \
         pyls-isort \
         pyls-mypy \
         python-language-server[flake8]
}

_install_pytools3() {
    printe_h2 "Populating $PYTOOLS3..."

    if ! forced && [ -f "$PIP3" ]; then
       printe_info "$PYTOOLS3 already exists, skipping..."
       return
    fi

    python3 -m venv \
            --clear \
            --without-pip \
            "$PYTOOLS3"

    fetch_url /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
    "$PYTOOLS3/bin/python3" /tmp/get-pip.py
    rm /tmp/get-pip.py
}

_install_pytools3_packages() {
    if [ -f "$PIP3" ]; then
       printe_info "$PYTOOLS3 already exists, skipping..."
       return
    fi

    $PIP3 install --upgrade virtualenv
}

run_with_flavors "$@"
