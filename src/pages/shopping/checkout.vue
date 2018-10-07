<template lang="pug">
  .checkout
    .container
      .address-box
        .address-item(@click='selectAddress', v-if='checkedAddress.id > 0')
          .l
            text.name {{checkedAddress.name}}
            text.default(v-if='checkedAddress.is_default === 1') 默认
          .m
            text.mobile {{checkedAddress.mobile}}
            text.address {{checkedAddress.full_region + checkedAddress.address}}
          .r
            img(src='/static/images/address_right.png')
        .address-item.address-empty(@click='addAddress', v-if='checkedAddress.id <= 0')
          .m 还没有收货地址，去添加
          .r
            img(src='/static/images/address_right.png')
      .coupon-box
        .coupon-item
          .l
            text.name 请选择优惠券
            text.txt {{couponList.length}}张
          .r
            img(src='/static/images/address_right.png')
      .order-box
        .order-item
          .l
            text.name 商品合计
          .r
            text.txt ￥{{goodsTotalPrice}}
        .order-item
          .l
            text.name 运费
          .r
            text.txt ￥{{freightPrice}}
        .order-item.no-border
          .l
            text.name 优惠券
          .r
            text.txt -￥{{couponPrice}}
      .goods-items
        .item(v-for='item in checkedGoodsList', :key='item.id')
          .img
            img(:src='item.list_pic_url')
          .info
            .t
              text.name {{item.goods_name}}
              text.number x{{item.number}}
            .m {{item.goods_specifition_name_value}}
            .b ￥{{item.retail_price}}
      .order-total
        .l 实付：￥{{actualPrice}}
        .r(@click='submitOrder') 去付款
</template>

<script>
import util from '../../utils/util'
import api from '../../utils/api'
import pay from '../../services/pay'

export default {
  data () {
    return {
      checkedGoodsList: [],
      checkedAddress: {},
      checkedCoupon: [],
      couponList: [],
      goodsTotalPrice: 0.0, // 商品总价
      freightPrice: 0.0, // 快递费
      couponPrice: 0.0, // 优惠券的价格
      orderTotalPrice: 0.0, // 订单总价
      actualPrice: 0.0, // 实际需要支付的总价
      addressId: 0,
      couponId: 0
    }
  },

  props: {},

  computed: {},

  onShow: function () {
    // 页面显示
    wx.showLoading({
      title: '加载中...'
    })
    this.getCheckoutInfo()
  },

  mounted () {
    console.log('get addressId')
    // 页面初始化 options为页面跳转所带来的参数
    try {
      var addressId = wx.getStorageSync('addressId')
      if (addressId) {
        Object.assign(this.$data, {
          addressId: addressId
        })
      }

      var couponId = wx.getStorageSync('couponId')
      if (couponId) {
        Object.assign(this.$data, {
          couponId: couponId
        })
      }
    } catch (e) {
      // Do something when catch error
    }
  },

  methods: {
    getCheckoutInfo: function () {
      let that = this
      util
        .request(api.CartCheckout, {
          addressId: that.addressId,
          couponId: that.couponId
        })
        .then(function (res) {
          if (res.errno === 0) {
            console.log(res.data)
            Object.assign(that.$data, {
              checkedGoodsList: res.data.checkedGoodsList,
              checkedAddress: res.data.checkedAddress,
              actualPrice: res.data.actualPrice,
              checkedCoupon: res.data.checkedCoupon,
              couponList: res.data.couponList,
              couponPrice: res.data.couponPrice,
              freightPrice: res.data.freightPrice,
              goodsTotalPrice: res.data.goodsTotalPrice,
              orderTotalPrice: res.data.orderTotalPrice
            })
          }
          wx.hideLoading()
        })
    },
    selectAddress () {
      wx.navigateTo({
        url: '/pages/shopping/address'
      })
    },
    addAddress () {
      wx.navigateTo({
        url: '/pages/shopping/addressAdd'
      })
    },
    submitOrder: function () {
      if (this.addressId <= 0) {
        util.showErrorToast('请选择收货地址')
        return false
      }
      util
        .request(
          api.OrderSubmit,
          { addressId: this.addressId, couponId: this.couponId },
          'POST'
        )
        .then(res => {
          if (res.errno === 0) {
            const orderId = res.data.orderInfo.id
            pay
              .payOrder(parseInt(orderId))
              .then(res => {
                wx.redirectTo({
                  url: '/pages/payResult/payResult?status=1&orderId=' + orderId
                })
              })
              .catch(res => {
                wx.redirectTo({
                  url: '/pages/payResult/payResult?status=0&orderId=' + orderId
                })
              })
          } else {
            util.showErrorToast('下单失败')
          }
        })
    }
  },

  components: {}
}
</script>

<style>
page{
    height: 100%;
    background: #f4f4f4;
}

.address-box{
    width: 100%;
    height: 166.55rpx;
    background: url('http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/icon-normal/address-bg-bd30f2bfeb.png') 0 0 repeat-x;
    background-size: 62.5rpx 10.5rpx;
    margin-bottom: 20rpx;
    padding-top: 10.5rpx;
}

.address-item{
    display: flex;
    height: 155.55rpx;
    background: #fff;
    padding: 41.6rpx 0 41.6rpx 31.25rpx;
}

.address-item.address-empty{
  line-height: 75rpx;
  text-align: center;
}

.address-box .l{
    width: 125rpx;
    height: 100%;
}

.address-box .l .name{
    margin-left: 6.25rpx;
    margin-top: -7.25rpx;
    display: block;
    width: 125rpx;
    height: 43rpx;
    line-height: 43rpx;
    font-size: 30rpx;
    color: #333;
    margin-bottom: 5rpx;

}

.address-box .l .default{
    margin-left: 6.25rpx;
    display: block;
    width: 62rpx;
    height: 33rpx;
    border-radius: 5rpx;
    border: 1px solid #b4282d;
    font-size: 20.5rpx;
    text-align: center;
    line-height: 29rpx;
    color: #b4282d;
}

.address-box .m{
    flex: 1;
    height: 72.25rpx;
    color: #999;
}

.address-box .mobile{
    display: block;
    height: 29rpx;
    line-height: 29rpx;
    margin-bottom: 6.25rpx;
    font-size: 30rpx;
    color:#333;
}

.address-box .address{
    display: block;
    height: 37.5rpx;
    line-height: 37.5rpx;
    font-size: 25rpx;
    color:#666;
}

.address-box .r{
    width: 77rpx;
    height: 77rpx;
    display: flex;
    justify-content: center;
    align-items: center;
}

.address-box .r image{
    width: 52.078rpx;
    height: 52.078rpx;
}

.coupon-box{
    width: 100%;
    height: auto;
    overflow: hidden;
    background: #fff;
}

.coupon-box .coupon-item{
    width: 100%;
    height: 108.3rpx;
    overflow: hidden;
    background: #fff;
    display: flex;
    padding-left: 31.25rpx;
}

.coupon-box .l{
    flex: 1;
    height: 43rpx;
    line-height: 43rpx;
    padding-top: 35rpx;
}

.coupon-box .l .name{
    float: left;
    font-size: 30rpx;
    color: #666;
}

.coupon-box .l .txt{
    float: right;
    font-size: 30rpx;
    color: #666;
}

.coupon-box .r{
    margin-top: 15.5rpx;
    width: 77rpx;
    height: 77rpx;
    display: flex;
    justify-content: center;
    align-items: center;
}

.coupon-box .r image{
    width: 52.078rpx;
    height: 52.078rpx;
}

.order-box{
    margin-top: 20rpx;
    width: 100%;
    height: auto;
    overflow: hidden;
    background: #fff;
}

.order-box .order-item{
    height: 104.3rpx;
    overflow: hidden;
    background: #fff;
    display: flex;
    margin-left: 31.25rpx;
    padding-right: 31.25rpx;
    padding-top: 26rpx;
    border-bottom: 1px solid #d9d9d9;
}

.order-box .order-item .l{
    float: left;
    height: 52rpx;
    width: 50%;
    line-height: 52rpx;
    overflow: hidden;
}

.order-box .order-item .r{
    float: right;
    text-align: right;
    width: 50%;
    height: 52rpx;
    line-height: 52rpx;
    overflow: hidden;
}

.order-box .order-item.no-border{
    border-bottom: none;
}

.goods-items{
    margin-top: 20rpx;
    width: 100%;
    height: auto;
    overflow: hidden;
    background: #fff;
    padding-left: 31.25rpx;
    margin-bottom: 120rpx;
}

.goods-items .item{
    height: 192rpx;
    padding-right: 31.25rpx;
    display: flex;
    align-items: center;
    border-bottom: 1px solid rgba(0,0,0,0.15);
}

.goods-items .item.no-border{
    border-bottom: none;
}


.goods-items .item:last-child{
    border-bottom: none;
}

.goods-items .img{
    height: 145.83rpx;
    width: 145.83rpx;
    background-color: #f4f4f4;
    margin-right: 20rpx;
}

.goods-items .img image{
    height: 145.83rpx;
    width: 145.83rpx;
}

.goods-items .info{
    flex: 1;
    height: 145.83rpx;
    padding-top: 5rpx;
}

.goods-items .t{
    height:  33rpx;
    line-height: 33rpx;
    margin-bottom: 10rpx;
    overflow: hidden;
    font-size: 30rpx;
    color: #333;
}

.goods-items .t .name{
    display: block;
    float: left;
}

.goods-items .t .number{
    display: block;
    float: right;
    text-align: right;
}

.goods-items .m {
    height:  29rpx;
    overflow: hidden;
    line-height: 29rpx;
    margin-bottom: 25rpx;
    font-size: 25rpx;
    color: #666;
}

.goods-items .b {
    height:  41rpx;
    overflow: hidden;
    line-height: 41rpx;
    font-size: 30rpx;
    color: #333;
}

.order-total{
    position: fixed;
    left:0;
    bottom: 0;
    height: 100rpx;
    width: 100%;
    display: flex;
}

.order-total .l{
    flex: 1;
    height: 100rpx;
    line-height: 100rpx;
    color: #b4282d;
    background: #fff;
    font-size: 33rpx;
    padding-left: 31.25rpx;
    border-top: 1rpx solid rgba(0,0,0,0.2);
    border-bottom: 1rpx solid rgba(0,0,0,0.2);
}

.order-total .r{
    width: 233rpx;
    height: 100rpx;
    background: #b4282d;
    border: 1px solid #b4282d;
    line-height: 100rpx;
    text-align: center;
    color: #fff;
    font-size: 30rpx;
}
</style>
