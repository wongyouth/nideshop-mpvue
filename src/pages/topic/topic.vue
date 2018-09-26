<template lang="pug">
  .container
    scroll-view.topic-list(:scroll-y="true" :style="'scroll-top:'+scrollTop")
      a.item(
        v-for="item in topicList"
        :key="item.id"
        :href="'../topic/detail?id='+item.id"
      )
        img.img(:src="item.scene_pic_url")
        .info
          text.title {{item.title}}
          text.desc {{item.subtitle}}
          text.price {{item.price_info}}元起
      .page(v-if="showPage")
        .prev(:class="page <= 1 ? 'disabled' : ''" @click="prevPage") 上一页
        .next(:class="(count / size) < page +1 ? 'disabled' : ''" @click="nextPage") 下一页

</template>

<script>
import util from '../../utils/util'
var api = require('../../utils/api.js')

export default {
  data () {
    return {
      // text:"这是一个页面"
      topicList: [],
      page: 1,
      size: 10,
      count: 0,
      scrollTop: 0,
      showPage: false
    }
  },

  props: {},

  computed: {},

  mounted () {},

  methods: {
    nextPage: function (event) {
      console.log()
      if (this.page + 1 > this.count / this.size) {
        return true
      }
      this.page += 1

      this.getTopic()
    },
    getTopic: function () {
      let that = this
      Object.assign(this.$data, {
        scrollTop: 0,
        showPage: false,
        topicList: []
      })
      // 页面渲染完成
      wx.showToast({
        title: '加载中...',
        icon: 'loading',
        duration: 2000
      })

      util
        .request(api.TopicList, { page: that.page, size: that.size })
        .then(function (res) {
          if (res.errno === 0) {
            Object.assign(that.$data, {
              scrollTop: 0,
              topicList: res.data.data,
              showPage: true,
              count: res.data.count
            })
          }
          wx.hideToast()
        })
    },
    prevPage: function (event) {
      if (this.page <= 1) {
        return false
      }
      this.page -= 1

      this.getTopic()
    }
  },

  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    this.getTopic()
  },
  onReady: function () {
    // 页面渲染完成
  },
  onShow: function () {
    // 页面显示
  },
  onHide: function () {
    // 页面隐藏
  },
  onUnload: function () {
    // 页面关闭
  }
}
</script>

<style lang="stylus" scoped>
page ,.container{
   width: 750rpx;
    height: 100%;
    overflow: hidden;
    background: #f4f4f4;
}
.topic-list{
    width: 750rpx;
    height: 100%;
    overflow: hidden;
    background: #f4f4f4;
}

.topic-list .item{
    width: 100%;
    height: 625rpx;
    overflow: hidden;
    background: #fff;
    margin-bottom: 20rpx;
}

.topic-list .img{
    width: 100%;
    height: 415rpx;
}

.topic-list .info{
    width: 100%;
    height: 210rpx;
    overflow: hidden;
}

.topic-list .title{
    display: block;
    text-align: center;
    width: 100%;
    height: 33rpx;
    line-height: 35rpx;
    color: #333;
    overflow: hidden;
    font-size: 35rpx;
    margin-top: 30rpx;
}

.topic-list .desc{
    display: block;
    text-align: center;
    position: relative;
    width: auto;
    height: 24rpx;
    line-height: 24rpx;
    overflow: hidden;
    color: #999;
    font-size: 24rpx;
    margin-top: 16rpx;
    margin-bottom: 30rpx;
}

.topic-list .price{
    display: block;
    text-align: center;
    width: 100%;
    height: 27rpx;
    line-height: 27rpx;
    overflow: hidden;
    color: #b4282d;
    font-size: 27rpx;
}


.page{
    width: 750rpx;
    height: 108rpx;
    background: #fff;
    margin-bottom: 20rpx;
}

.page view{
    height: 108rpx;
    width: 50%;
    float: left;
    font-size: 29rpx;
    color: #333;
    text-align: center;
    line-height: 108rpx;
}

.page .prev{
    border-right: 1px solid #D9D9D9;
}

.page .disabled{
    color: #ccc;
}
</style>