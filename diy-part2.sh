#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

cd package/lean/ && git clone -b js https://github.com/gngpp/luci-theme-design.git
echo $PWD
[ ! -d sms-tool ] && mkdir sms-tool


[ ! -d luci-app-sms ] && mkdir luci-app-sms


[ ! -d luci-app-passwall2 ] && mkdir luci-app-passwall2

# for sms-tool
if [  -d sms-tool ]
then
    cd sms-tool  
    git init 
    git remote add -f origin https://github.com/kenzok8/small-package.git 
    git config core.sparsecheckout true 
    echo "sms-tool/*" >> .git/info/sparse-checkout 
    git pull origin main
fi

cd ..
# for sms-app
if [  -d luci-app-sms ]
then
    cd luci-sms-app  
    git init 
    git remote add -f origin https://github.com/kenzok8/small-package.git 
    git config core.sparsecheckout true 
    echo "luci-app-sms-tool/*" >> .git/info/sparse-checkout
    git pull origin main
fi

cd ..
# for passwall2
if [  -d luci-app-passwall2 ]
then
    cd luci-app-passwall2 
    git init 
    git remote add -f origin https://github.com/kenzok8/small-package.git 
    git config core.sparsecheckout true 
    echo "luci-app-passwall2/*" >> .git/info/sparse-checkout 
    git pull origin main
fi

cd ..
# modify passwall2 deps
[ -f luci-app-passwall2/Makefile ] && sed -i '31s/xray-core/v2ray-core/' package/lean/luci-app-passwall2/Makefile

# change dir to source root(openwrt)
cd ../..
#modify netdata
[ -f package/feeds/packages/netdata/Makefile ] && sed -i 's/disable-https/enable-https/' package/feeds/packages/netdata/Makefile
[ -f feeds/packages/admin/netdata/Makefile ] && sed -i 's/disable-plugin/enable-plugin/' feeds/packages/admin/netdata/Makefile

#modify ttyd to enable https
[ -f feeds/packages/utils/ttyd/Makefile ] && $(sed -i 's/PKG_VERSION:=1\.6\.3/PKG_VERSION:=1\.7\.3/' feeds/packages/utils/ttyd/Makefile && sed -i 's/PKG_HASH:=.*/PKG_HASH:=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855/' feeds/packages/utils/ttyd/Makefile) 
[ -f package/feeds/packages/ttyd/Makefile ] && $(sed -i 's/PKG_VERSION:=1\.6\.3/PKG_VERSION:=1\.7\.3/' package/feeds/packages/ttyd/Makefile && sed -i 's/PKG_HASH:=.*/PKG_HASH:=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855/' package/feeds/packages/ttyd/Makefile) 
