<template lang="pug">
  .order
    .container
      .orders
        a.order(:href="'./orderDetail?id=' + item.id", v-for='item in orderList', :key='item.id')
          .h
            .l 订单编号：{{item.order_sn}}
            .r {{item.order_status_text}}
          .goods(v-for='(gitem, gindex) in item.goodsList', :key='gitem.id')
            .img
              img(:src='gitem.list_pic_url')
            .info
              text.name {{gitem.goods_name}}
              text.number 共{{gitem.number}}件商品
            .status
          .b
            .l 实付：￥{{item.actual_price}}
            .r
              button.btn(@click='payOrder(item)', v-if='item.handleOption.pay') 去付款
</template>

<script>
import util from '../../utils/util'
import api from '../../utils/api'

export default {
  data () {
    return {
      orderList: []
    }
  },

  props: {},

  computed: {},

  beforeMount () {
    this.getOrderList()
  },

  methods: {
    getOrderList () {
      let that = this
      util.request(api.OrderList).then(function (res) {
        if (res.errno === 0) {
          console.log(res.data)
          Object.assign(that.$data, {
            orderList: res.data.data
          })
        }
      })
    },
    payOrder (order) {
      wx.redirectTo({
        url: `/pages/pay/pay?orderId=${order.id}&actualPrice=${order.actual_price}`
      })
    }
  },

  components: {}
}
</script>

<style>
page{
    height: 100%;
    width: 100%;
    background: #f4f4f4;
}

.orders{
    height: auto;
    width: 100%;
    overflow: hidden;
}

.order{
    margin-top: 20rpx;
    background: #fff;
}

.order .h{
    height: 83.3rpx;
    line-height: 83.3rpx;
    margin-left: 31.25rpx;
    padding-right: 31.25rpx;
    border-bottom: 1px solid #f4f4f4;
    font-size: 30rpx;
    color: #333;
}

.order .h .l{
    float: left;
}

.order .h .r{
    float: right;
    color: #b4282d;
    font-size: 24rpx;
}

.order .goods{
    display: flex;
    align-items: center;
    height: 199rpx;
    margin-left: 31.25rpx;
}

.order .goods .img{
    height:145.83rpx;
    width:145.83rpx;
    background: #f4f4f4;
}

.order .goods .img image{
    height:145.83rpx;
    width:145.83rpx;
}

.order .goods .info{
    height: 145.83rpx;
    flex: 1;
    padding-left: 20rpx;
}

.order .goods .name{
    margin-top: 30rpx;
    display: block;
    height: 44rpx;
    line-height: 44rpx;
    color: #333;
    font-size: 30rpx;
}

.order .goods .number{
    display: block;
    height: 37rpx;
    line-height: 37rpx;
    color: #666;
    font-size: 25rpx;
}

.order .goods .status{
    width:105rpx;
    color: #b4282d;
    font-size: 25rpx;
}

.order .b{
    height: 103rpx;
    line-height: 103rpx;
    margin-left: 31.25rpx;
    padding-right: 31.25rpx;
    border-top: 1px solid #f4f4f4;
    font-size: 30rpx;
    color: #333;
}

.order .b .l{
    float: left;
}

.order .b .r{
    float: right;
}

.order .b .btn{
    margin-top: 19rpx;
    height: 64.5rpx;
    line-height: 64.5rpx;
    text-align: center;
    padding: 0 20rpx;
    border-radius: 5rpx;
    font-size: 28rpx;
    color: #fff;
    background: #b4282d;
}
</style>
