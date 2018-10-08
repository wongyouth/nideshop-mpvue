<template lang="pug">
  .pay-result
    .container
      .pay-result
        .success(v-if='status === true')
          .msg 付款成功
          .btns
            navigator.btn(url='/pages/ucenter/order', open-type='redirect') 查看订单
            navigator.btn(url='/pages/index/index', open-type='switchTab') 继续逛
        .error(v-if='status !== true')
          .msg 付款失败
          .tips
            .p
              | 请在
              text.time 1小时
              | 内完成付款
            .p 否则订单将会被系统取消
          .btns
            navigator.btn(url='/pages/ucenter/order', open-type='redirect') 查看订单
            .btn(@click='payOrder') 重新付款
</template>

<script>
import util from '../../utils/util'
import pay from '../../services/pay'

export default {
  data () {
    return {
      status: false,
      orderId: 0
    }
  },

  props: {},

  computed: {},

  mounted () {
    const { orderId, status } = this.$root.$mp.query

    this.orderId = +(orderId || 24)
    this.status = status === '1'
  },

  methods: {
    payOrder () {
      pay
        .payOrder(parseInt(this.orderId))
        .then(res => {
          Object.assign(this.$data, {
            status: true
          })
        })
        .catch(res => {
          util.showErrorToast('支付失败')
        })
    }
  },

  components: {}
}
</script>

<style>
page {
  min-height: 100%;
  width: 100%;
  background: #fff;
}

.container {
  height: 100%;
  background: #fff;
}

.pay-result {
  background: #fff;
}

.pay-result .msg {
  text-align: center;
  margin: 100rpx auto;
  color: #2bab25;
  font-size: 36rpx;
}

.pay-result .btns {
  display: flex;
  align-items: center;
  justify-content: center;
}

.pay-result .btn {
  text-align: center;
  height: 80rpx;
  margin: 0 20rpx;
  width: 200rpx;
  line-height: 78rpx;
  border: 1px solid #868686;
  color: #000000;
  border-radius: 5rpx;
}

.pay-result .error .msg {
  color: #b4282d;
  margin-bottom: 60rpx;
}

.pay-result .error .tips {
  color: #7f7f7f;
  margin-bottom: 70rpx;
}

.pay-result .error .tips .p {
  font-size: 24rpx;
  line-height: 42rpx;
  text-align: center;
}

.pay-result .error .tips .p {
  line-height: 42rpx;
  text-align: center;
}
</style>
