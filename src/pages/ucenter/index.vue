<template lang="pug">
  .my
    .container
      .profile-info(@click='goLogin')
        img.avatar(:src='userInfo.avatar')
        .info
          text.name {{userInfo.nickname}}
          // text.level {{userInfo.username}}
      .user-menu
        .item
          navigator.a(url='/pages/ucenter/order')
            text.icon.order
            text.txt 我的订单
        .item
          navigator.a(url='/pages/ucenter/coupon')
            text.icon.coupon
            text.txt 优惠券
        .item.no-border
          navigator.a(url='url')
            text.icon.gift
            text.txt 礼品卡
        .item
          navigator.a(url='/pages/ucenter/collect')
            text.icon.address
            text.txt 我的收藏
        .item
          navigator.a(url='/pages/ucenter/footprint')
            text.icon.security
            text.txt 我的足迹
        .item.no-border
          navigator.a(url='url')
            text.icon.kefu
            text.txt 会员福利
        .item
          navigator.a(url='../address')
            text.icon.address
            text.txt 地址管理
        .item
          navigator.a(url='url')
            text.icon.security
            text.txt 账号安全
        .item.no-border
          navigator.a(url='url')
            text.icon.kefu
            text.txt 联系客服
        .item.item-bottom
          navigator.a(url='url')
            text.icon.help
            text.txt 帮助中心
        .item.item-bottom
          navigator.a(url='/pages/ucenter/feedback')
            text.icon.feedback
            text.txt 意见反馈
      // .logout(@click="exitLogin") 退出登录
</template>

<script>
import user from '../../services/user.js'

export default {
  data () {
    return {
      userInfo: {
        nickname: 'Hi,游客',
        username: '点击去登录',
        avatar: 'http://yanxuan.nosdn.127.net/8945ae63d940cc42406c3f67019c5cb6.png'
      },
      token: ''
    }
  },

  props: {},

  computed: {},

  mounted () {
    let userInfo = wx.getStorageSync('userInfo')
    let token = wx.getStorageSync('token')

    // 页面显示
    if (userInfo && token) {
      this.userInfo = userInfo
    }
  },

  methods: {
    goLogin () {
      user
        .loginByWeixin()
        .then(res => {
          Object.assign(this.$data, {
            userInfo: res.data.userInfo
          })
          this.userInfo = res.data.userInfo
          this.token = res.data.token
        })
        .catch(err => {
          console.log(err)
        })
    },
    exitLogin: function () {
      wx.showModal({
        title: '',
        confirmColor: '#b4282d',
        content: '退出登录？',
        success: function (res) {
          if (res.confirm) {
            wx.removeStorageSync('token')
            wx.removeStorageSync('userInfo')
            wx.switchTab({
              url: '/pages/index/index'
            })
          }
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
    width: 100%;
    background: #f4f4f4;
}
.container{
    background: #f4f4f4;
    height: auto;
    overflow: hidden;
    width: 100%;
}
.profile-info{
    width: 100%;
    height: 280rpx;
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: flex-start;
    padding: 0 30.25rpx;
    background: #333;
}

.profile-info .avatar{
    height: 148rpx;
    width: 148rpx;
    border-radius: 50%;
}

.profile-info .info{
    flex: 1;
    height: 85rpx;
    padding-left: 31.25rpx;
}

.profile-info .name{
    display: block;
    height: 45rpx;
    line-height: 45rpx;
    color: #fff;
    font-size: 37.5rpx;
    margin-bottom: 10rpx;
}

.profile-info .level{
    display: block;
    height: 30rpx;
    line-height: 30rpx;
    margin-bottom: 10rpx;
    color: #7f7f7f;
    font-size: 30rpx;
}

.user-menu{
    width: 100%;
    height: auto;
    overflow: hidden;
    background: #fff;
}

.user-menu .item{
    float: left;
    width: 33.33333%;
    height: 187.5rpx;
    border-right: 1px solid rgba(0,0,0,.15);
    border-bottom: 1px solid rgba(0,0,0,.15);
    text-align: center;
}

.user-menu .item .a{
  display: flex;
  width: 100%;
  height: 100%;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.user-menu .item.no-border {
    border-right: 0;
}

.user-menu .item.item-bottom {
    border-bottom: none;
}

.user-menu .icon{
    margin: 0 auto;
    display: block;
    height: 52.803rpx;
    width: 52.803rpx;
    margin-bottom: 16rpx;
}

.user-menu .icon.order{
    background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/sprites/ucenter-sdf6a55ee56-f2c2b9c2f0.png) 0 -437.5rpx no-repeat;
    background-size: 52.803rpx;
}

.user-menu .icon.coupon{
    background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/sprites/ucenter-sdf6a55ee56-f2c2b9c2f0.png) 0 -62.4997rpx no-repeat;
    background-size: 52.803rpx;
}

.user-menu .icon.gift{
    background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/sprites/ucenter-sdf6a55ee56-f2c2b9c2f0.png) 0 -187.5rpx no-repeat;
    background-size: 52.803rpx;
}

.user-menu .icon.address{
    background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/sprites/ucenter-sdf6a55ee56-f2c2b9c2f0.png) 0 0 no-repeat;
    background-size: 52.803rpx;
}

.user-menu .icon.security{
    background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/sprites/ucenter-sdf6a55ee56-f2c2b9c2f0.png) 0 -500rpx no-repeat;
    background-size: 52.803rpx;
}

.user-menu .icon.kefu{
    background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/sprites/ucenter-sdf6a55ee56-f2c2b9c2f0.png) 0 -312.5rpx no-repeat;
    background-size: 52.803rpx;
}

.user-menu .icon.help{
    background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/sprites/ucenter-sdf6a55ee56-f2c2b9c2f0.png) 0 -250rpx no-repeat;
    background-size: 52.803rpx;
}

.user-menu .icon.feedback{
    background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/sprites/ucenter-sdf6a55ee56-f2c2b9c2f0.png) 0 -125rpx no-repeat;
    background-size: 52.803rpx;
}


.user-menu .txt{
    display: block;
    height: 24rpx;
    width: 100%;
    font-size: 24rpx;
    color:#333;
}

.logout{
    margin-top: 50rpx;
    height: 101rpx;
    width: 100%;
    line-height: 101rpx;
    text-align: center;
    background: #fff;
    color: #333;
    font-size: 30rpx;
}
</style>
