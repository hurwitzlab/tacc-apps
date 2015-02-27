#!/bin/bash

# Agave automatically writes these scheduler
# directives when you submit a job but we have to
# do it by hand when writing our test

#SBATCH -p development
#SBATCH -t 00:30:00
#SBATCH -n 16
#SBATCH -A iPlant-Collabs
#SBATCH -J test-metavelvet
#SBATCH -o test-metavelvet.o%j

OUT_DIR='out'
KMER_SIZE=51
INS_LENGTH=260
INPUT_FILE_FORMAT='fasta'
INPUT_READ_CATEGORY='shortPaired' # short is default
INPUT_TARBALL='HMP.small.tar.gz'
INPUT_DIR='input'

if [[ ! ${INPUT_FILE_FORMAT:0:1} == "-" ]]; then 
    INPUT_FILE_FORMAT="-${INPUT_FILE_FORMAT}" 
fi

if [[ ! ${INPUT_READ_CATEGORY:0:1} == "-" ]]; then 
    INPUT_READ_CATEGORY="-${INPUT_READ_CATEGORY}" 
fi

tar -xvf bin.tgz

export PATH=$PATH:"$PWD/bin"

if [[ ! -d $INPUT_DIR ]]; then
    mkdir $INPUT_DIR
fi

tar -C $INPUT_DIR -zxvf $INPUT_TARBALL

echo "velveth $OUT_DIR $KMER_SIZE $INPUT_FILE_FORMAT $INPUT_READ_CATEGORY"
exit;

find $INPUT_DIR -type f | \
  xargs velveth $OUT_DIR $KMER_SIZE $INPUT_FILE_FORMAT $INPUT_READ_CATEGORY

for FILE in Sequences Roadmaps
do
    if [[ ! -e "$OUT_DIR/$FILE" ]]; then
        echo "Missing \"$FILE\" file after velveth"
        exit;
    fi
done

velvetg $OUT_DIR -exp_cov auto -ins_length $INS_LENGTH

if [[ ! -e "$OUT_DIR/Graph2" ]]; then
    echo "Missing 'Graph2' file after velvetg"
    exit;
fi

                                                              10,1          Top
fi

meta-velvetg $OUT_DIR

if [[ ! -e "$OUT_DIR/meta-velvetg.contigs.fa" ]]; then
    echo "Missing 'meta-velvetg.contigs.fa' file after meta-velvetg"
    exit;
fi

rm -rf bin
