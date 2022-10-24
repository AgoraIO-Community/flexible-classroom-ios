#!/bin/sh
Certificate=$1

echo $Certificate

sh ../SDK/buildFrameworks.sh || exit 1

python3 cloud_pod.py 1 1

cd ../App

rm -fr ../../App

let "cer=$Certificate & 1"

if [ $cer -gt 0 ]
then
    echo ">>:CertificateA"

    sh ./archive.sh CertificateA || exit 1
fi

let "cer=$Certificate & 2"

if [ $cer -gt 0 ]
then
    echo ">>:CertificateB"

    sh ./archive.sh CertificateB || exit 1
fi

let "cer=$Certificate & 4"

if [ $cer -gt 0 ]
then
    echo ">>:CertificateC"

    sh ./archive.sh CertificateC || exit 1
fi

let "cer=$Certificate & 8"

if [ $cer -gt 0 ]
then
    echo ">>:CertificateD"

    sh ./archive.sh CertificateD || exit 1
fi
