#!/bin/sh

Package_Path="../../../Package"
Product_Path="../../"
Product_App_Path=${Product_Path}/App
#Product_Libs_Path=${Product_Path}/Libs
#Product_Libs_Path="../../../../open-cloudclass-ios/Products/Libs"

mkdir ${Package_Path}

cp -r ${Product_App_Path} ${Package_Path}
#cp -r ${Product_Libs_Path} ${Package_Path}
