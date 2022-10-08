#!/bin/sh
Certificate=$1

echo $Certificate

#./buildFrameworks.sh

python3 cloud_pod.py 0 1

cd ../App

rm -fr ../../App

let "cer=$Certificate & 1"

if [ $cer -gt 0 ]
then
    echo ">>:CertificateA"

    sh ./archive.sh CertificateA
fi

let "cer=$Certificate & 2"

if [ $cer -gt 0 ]
then
    echo ">>:CertificateB"

    sh ./archive.sh CertificateB
fi

let "cer=$Certificate & 4"

if [ $cer -gt 0 ]
then
    echo ">>:CertificateC"

    sh ./archive.sh CertificateC
fi

let "cer=$Certificate & 8"

if [ $cer -gt 0 ]
then
    echo ">>:CertificateD"

    sh ./archive.sh CertificateD
fi
