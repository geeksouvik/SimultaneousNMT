#!/bin/bash 


if [ -z $PYTHON ]; then
    if [ -n `which python3` ]; then
        export PYTHON=python3
    else
        if [ -n `which python2`]; then
            export PYTHON=python2
        else
            if [ -n `which python`]; then
                export PYTHON=python
            fi
        fi
    fi 
fi

if [ -z $PYTHON ]; then
    echo "Please set PYTHON to a Python interpreter"
    exit 1 
fi

echo "Using $PYTHON"

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )
CODE_DIR=${SCRIPT_DIR}/..

DATA_DIR=${CODE_DIR}/data


$PYTHON ${CODE_DIR}/data/extract_file.py \
    -s='fr' -t='en' \
    --source-dev=newstest2011.fr \
    --target-dev=newstest2011.en \
    --outdir=${DATA_DIR}

$PYTHON -c "from __future__ import print_function; import theano; print('theano available!')"



# extract dictionaries
$PYTHON ${CODE_DIR}/data/build_dict.py ${DATA_DIR}/europarl-v7.fr-en.fr.tok
$PYTHON ${CODE_DIR}/data/build_dict.py ${DATA_DIR}/europarl-v7.fr-en.en.tok

# shuffle traning data
$PYTHON ${CODE_DIR}/data/shuffle.py ${DATA_DIR}/europarl-v7.fr-en.en.tok ${DATA_DIR}/europarl-v7.fr-en.fr.tok 