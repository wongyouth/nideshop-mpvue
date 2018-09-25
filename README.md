# nideshop-mpvue

基于 <https://github.com/tumobi/nideshop-mini-program> 改写的 `mpvue` 版本

Work in progress

### NideShop商城（微信小程序端）

+ 界面高仿网易严选商城(主要是2016年wap版)
+ 测试数据采集自网易严选商城
+ 功能和数据库参考ecshop
+ 服务端api基于Ｎode.js+ThinkJS+MySQL
+ 计划添加基于Vue.js的后台管理系统、PC版、Ｗap版

**注意：当前版本功能还未完善，请勿商用。**

本项目需要配合NideShop商城服务端使用，GitHub: <https://github.com/tumobi/nideshop>

### 功能列表

- [x] 首页
- [x] 分类首页
- [x] 分类商品
- [ ] 新品首发、人气推荐商品页面
- [x] 商品详情页面，包含加入购物车、收藏商品、商品评论功能
- [ ] 搜索功能
- [x] 专题首页
- [ ] 专题功能
- [ ] 品牌功能
- [ ] 完整的购物流程，商品的加入、编辑、删除、批量选择，收货地址的选择，下单支付
- [x] 购物车页面
- [ ] 会员中心（订单、收藏、足迹、收货地址、意见反馈）

....

### 服务端api

项目地址：https://github.com/tumobi/nideshop

## Build Setup

``` bash
# install dependencies
yarn
# or
npm install

# serve with hot reload at localhost:8080
npm run dev

# build for production with minification
npm run build

# build for production and view the bundle analyzer report
npm run build --report
```