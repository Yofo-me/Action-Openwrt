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
if [  -d package/lean/sms-tool ]
then
cd package/lean/sms-tool && git init && git remote add -f origin https://github.com/kenzok8/small-package.git && git config core.sparsecheckout true && echo "sms-tool/*" >> .git/info/sparse-checkout && git pull origin main
fi

# for sms-app
if [  -d package/lean/luci-app-sms ]
then
cd package/lean/luci-sms-app && git init && git remote add -f origin https://github.com/kenzok8/small-package.git && git config core.sparsecheckout true &&   echo "luci-app-sms-tool/*" >> .git/info/sparse-checkout && git pull origin main
fi

# for passwall2
if [  -d package/lean/luci-app-passwall2 ]
then
cd package/lean/luci-app-passwall2 && git init && git remote add -f origin https://github.com/kenzok8/small-package.git && git config core.sparsecheckout true &&  echo "luci-app-passwall2/*" >> .git/info/sparse-checkout && git pull origin main
fi

# modify passwall2 deps
if [ -f package/lean/luci-app-passwall2/Makefile ]
then
  sed -i '31s/xray-core/v2ray-core/' package/lean/luci-app-passwall2/Makefile
fi

#modify netdata
sed -i 's/disable-https/enable-https/' package/feeds/packages/netdata/Makefile
sed -i 's/disable-plugin/enable-plugin/' package/feeds/packages/netdata/Makefile

#modify ttyd to enable https
[ -f feeds/packages/utils/ttyd/Makefile ] && $(sed -i 's/PKG_VERSION:=1\.6\.3/PKG_VERSION:=1\.7\.3/' feeds/packages/utils/ttyd/Makefile && sed -i 's/PKG_HASH:=.*/PKG_HASH:=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855/' feeds/packages/utils/ttyd/Makefile) || echo 'Files not Found'

[ -f package/feeds/packages/ttyd/Makefile ] && $(sed -i 's/PKG_VERSION:=1\.6\.3/PKG_VERSION:=1\.7\.3/' package/feeds/packages/ttyd/Makefile && sed -i 's/PKG_HASH:=.*/PKG_HASH:=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855/' package/feeds/packages/ttyd/Makefile) || echo 'Files not Found'
