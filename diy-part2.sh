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
[ ! -d small-package ] && mkdir small-package




# for small-package
if [  -d small-package ]
then
    cd small-package  
    if [ ! -d .git ] || [ ! -f .git ] || [ "`ls -A .git`"="" ]
    then
        git init 
        git remote add -f origin https://github.com/kenzok8/small-package.git 
        git config core.sparsecheckout true 
        echo "sms-tool/*" >> .git/info/sparse-checkout 
        echo "luci-app-sms-tool/*" >> .git/info/sparse-checkout
        echo "luci-app-passwall2/*" >> .git/info/sparse-checkout
        echo "luci-app-codeserver/*" >> .git/info/sparse-checkout
        echo "luci-lib-taskd/*" >> .git/info/sparse-checkout
        echo "naiveproxy/*" >> .git/info/sparse-checkout
        echo "luci-app-iperf/*" >> .git/info/sparse-checkout
        echo "luci-app-chinesesubfinder/*" >> .git/info/sparse-checkout
        echo "luci-lib-xterm/*" >> .git/info/sparse-checkout
        echo "taskd/*" >> .git/info/sparse-checkout
        echo "speedtestcli/*" >> .git/info/sparse-checkout
        echo "subconverter/*" >> .git/info/sparse-checkout
        echo "sub-web/*" >> .git/info/sparse-checkout
        echo "speedtest-web/*" >> .git/info/sparse-checkout
        echo "webd/*" >> .git/info/sparse-checkout
        echo "webdav2/*" >> .git/info/sparse-checkout
        echo "wxbase/*" >> .git/info/sparse-checkout
        echo "quickjspp/*" >> .git/info/sparse-checkout
        echo "libcron/*" >> .git/info/sparse-checkout
        echo "jpcre2/*" >> .git/info/sparse-checkout
        echo "rapidjson/*" >> .git/info/sparse-checkout
        echo "toml11/*" >> .git/info/sparse-checkout
        git pull origin main
    else
        git pull origin main
    fi
    
    # echo current path
    echo "current path is: $PWD"
    
fi

cd ..

# clone small depends
git clone https://github.com/kenzok8/small.git
../../scripts/feeds update  -a && ../../scripts/feeds install  -a

    




# modify passwall2 deps
[ -f small-package/luci-app-passwall2/Makefile ] && sed -i '31s/xray-core/v2ray-core/' small-package/luci-app-passwall2/Makefile
[ -f small-package/luci-app-iperf/Makefile ] && sed -i '9s/LUCI_DEPENDS:=+iperf3-ssl/LUCI_DEPENDS:=+iperf3/' small-package/luci-app-iperf/Makefile


# change dir to source root(openwrt)
cd ../..
#modify netdata
[ -f package/feeds/packages/netdata/Makefile ] && sed -i 's/disable-https/enable-https/' package/feeds/packages/netdata/Makefile
[ -f feeds/packages/admin/netdata/Makefile ] && sed -i 's/disable-plugin/enable-plugin/' feeds/packages/admin/netdata/Makefile

#modify ttyd to enable https
[ -f feeds/packages/utils/ttyd/Makefile ] && $(sed -i 's/PKG_VERSION:=1\.6\.3/PKG_VERSION:=1\.7\.3/' feeds/packages/utils/ttyd/Makefile && sed -i 's/PKG_HASH:=.*/PKG_HASH:=c9cf5eece52d27c5d728000f11315d36cb400c6948d1964a34a7eae74b454099/' feeds/packages/utils/ttyd/Makefile) 
[ -f package/feeds/packages/ttyd/Makefile ] && $(sed -i 's/PKG_VERSION:=1\.6\.3/PKG_VERSION:=1\.7\.3/' package/feeds/packages/ttyd/Makefile && sed -i 's/PKG_HASH:=.*/PKG_HASH:=c9cf5eece52d27c5d728000f11315d36cb400c6948d1964a34a7eae74b454099/' package/feeds/packages/ttyd/Makefile) 

[ -d  feeds/packages/utils/ttyd/patches ] && rm -rf feeds/packages/utils/ttyd/patches

[ -d package/feeds/packages/ttyd/patches ] && rm -rf package/feeds/packages/ttyd/patches
