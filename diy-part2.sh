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
if [ ! -d package/lean/sms-tool ]
then
  mkdir package/lean/sms-tool
fi

if [ ! -d package/lean/luci-app-sms ]
then
  mkdir package/lean/sms-tool
fi

if [ ! -d package/lean/luci-app-passwall2 ]
then
  mkdir package/lean/sms-tool
fi

# for sms-tool
cd package/lean/sms-tool && git init && git remote add -f origin https://github.com/kenzok8/small-package.git && git config core.sparsecheckout true && echo "sms-tool/*" >> .git/info/sparse-checkout && git pull origin main

# for sms-app
cd package/lean/luci-sms-app && git init && git remote add -f origin https://github.com/kenzok8/small-package.git && git config core.sparsecheckout true &&   echo "luci-app-sms-tool/*" >> .git/info/sparse-checkout && git pull origin main

# for passwall2
cd package/lean/luci-app-passwall2 && git init && git remote add -f origin https://github.com/kenzok8/small-package.git && git config core.sparsecheckout true &&  echo "luci-app-passwall2/*" >> .git/info/sparse-checkout && git pull origin main
# modify passwall2 deps
if [ -f package/lean/luci-app-passwall2/Makefile ]
then
  sed -i '31s/xray-core/v2ray-core/' package/lean/luci-app-passwall2/Makefile
fi


