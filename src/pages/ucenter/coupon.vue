<template lang="pug">
  .coupon
    .container
      .coupon-form
        .input-box
          input.coupon-sn(placeholder='请输入优惠码')
          img.clear-icon(src='http:// yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/icon-normal/clear-fb-dd9d604f86.png')
        button.add-btn.disabled 兑换
      .help 使用说明
      .coupon-list
        .item
          .tag 新人专享
          .content
            .left
              .name 限时免单券
              .time 2017.06.08-2017.06.11
            .right
              button.go 去使用
          .condition
            text.txt 简约陶瓷马克杯专享；小米用户福利；限时购、三石福利价、礼品卡及详情页标注不可用券特殊商品除外
            img.icon(src='https:// yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/icon-normal/couponArrow-71315b4145.png')
        .item
          .tag 新人专享
          .content
            .left
              .name 限时免单券
              .time 2017.06.08-2017.06.11
            .right
              button.go 去使用
          .condition
            text.txt 简约陶瓷马克杯专享；小米用户福利；限时购、三石福利价、礼品卡及详情页标注不可用券特殊商品除外
            img.icon(src='https:// yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/icon-normal/couponArrow-71315b4145.png')
</template>

<script>
export default {
  data () {
    return {

    }
  },

  props: {
  },

  computed: {
  },

  mounted () {
  },

  methods: {
    // TODO 兑换功能
  },

  components: {
  }
}
</script>

<style>
page{
    background: #f4f4f4;
    min-height: 100%;
}

.container{
    background: #f4f4f4;
    min-height: 100%;
    padding-top: 30rpx;
}

.coupon-form{
  height: 110rpx;
  width: 100%;
  background: #fff;
  padding-left: 30rpx;
  padding-right: 30rpx;
  padding-top: 20rpx;
  display: flex;
}

.input-box{
  flex: 1;
  height: 70rpx;
  color: #333;
  font-size: 24rpx;
  background: #fff;
  position: relative;
  border: 1px solid rgba(0, 0, 0, 0.15);
  border-radius: 4rpx;
  margin-right: 30rpx;
}

.input-box .coupon-sn{
  position: absolute;
  top: 10rpx;
  left: 30rpx;
  height: 50rpx;
  width: 100%;
  color: #000;
  line-height: 50rpx;
  font-size: 24rpx;
}

.clear-icon{
  position: absolute;
  top: 21rpx;
  right: 30rpx;
  width: 28rpx;
  height: 28rpx;
}

.add-btn{
  height: 70rpx;
  border:none;
  width: 168rpx;
  background: #b4282d;
  border-radius: 0;
  line-height: 70rpx;
  color: #fff;
  font-size: 28rpx;
}

.add-btn.disabled{
  background: #ccc;
}

.help{
  height: 72rpx;
  line-height: 72rpx;
  text-align: right;
  padding-right: 30rpx;
  background: url(https://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/icon-normal/couponHelp-4768607555.png) 590rpx center no-repeat;
  background-size: 28rpx;
  color: #999;
  font-size: 24rpx;
}

.coupon-list{
  width: 100%;
  height: auto;
  overflow: hidden;
  padding-left: 30rpx;
  padding-right: 30rpx;
}

.item{
  position: relative;
  height: 290rpx;
  width: 100%;
  background: linear-gradient(to right,#cfa568,#e3bf79);
  margin-bottom: 30rpx;
  padding-top: 52rpx;
}

.tag{
  height: 32rpx;
  background: #A48143;
  padding-left: 16rpx;
  padding-right: 16rpx;
  position: absolute;
  left: 20rpx;
  color: #fff;
  top: 20rpx;
  font-size: 20rpx;
  text-align: center;
  line-height: 32rpx;
}


.content{
  margin-top: 24rpx;
  margin-left: 40rpx;
  display: flex;
  margin-right: 40rpx;
  flex-direction: row;
  align-items: center;
}

.content .left{
  flex: 1;
}

.name{
  font-size: 44rpx;
  color: #fff;
  margin-bottom: 14rpx;
}

.time{
  font-size: 24rpx;
  color: rgba(255,255,255, 0.8);
  line-height: 30rpx;
}

.content .right{
  width: 162rpx;
}

.go{
  height: 48rpx;
  border:none;
  width: 162rpx;
  background: rgba(255,255,255, 0.8);
  border-radius: 4rpx;
  line-height: 48rpx;
  color: #b69150;
  font-size: 24rpx;
}

.condition{
  position: absolute;
  width: 100%;
  bottom: 0;
  left:0;
  height: 78rpx;
  background: rgba(0,0,0,.08);
  padding: 24rpx 40rpx;
  display: flex;
  flex-direction: row;
}

.condition .txt{
  display: block;
  height: 30rpx;
  flex: 1;
  overflow: hidden;
  font-size: 24rpx;
  line-height: 30rpx;
  color: #fff;
}


.condition .icon{
  margin-left: 30rpx;
  width: 24rpx;
  height: 24rpx;
}
</style>
