<template lang="pug">
.topic-detail
  scroll-view.container
    scroll-view.content
      wx-parse(
        v-if='topic.content'
        :content='topic.content'
      )
    .topic-goods
    scroll-view.comments
      .h
        text.t 精选留言
        image.i(@click='postComment' src='http://nos.netease.com/mailpub/hxm/yanxuan-wap/p/20150730/style/img/icon-normal/comment-add-2aca147c3f.png')
      .has-comments(v-if='commentList.length > 0 ')
        .b
          .item(v-for='item in commentList' :key='item.id')
            .info
              .user
                image.avatar(:src='item.user_info.avatar')
                text.nickname {{item.user_info.nickname}}
              .time {{item.add_time}}
            .comment
              | {{item.content}}
        .load(v-if='commentCount > 5')
          a(:href="'/pages/topicComment/topicComment?typeId=1&valueId=' + topic.id") &#x67E5;&#x770B;&#x66F4;&#x591A;
      .no-comments(v-if='commentList.length <= 0')
        .b
          image.icon(src='http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/icon-normal/no-comment-560f87660a.png')
          text.txt 等你来留言
    scroll-view.rec-box
      .h
        text.txt 专题推荐
      .b
        a.item(
          v-for='item in topicList'
          :key='item.id'
          :href="'../topicDetail/topicDetail?id=' + item.id"
        )
          image.img(:src='item.scene_pic_url')
          text.title {{item.title}}

</template>

<script>
import util from '../../utils/util'
import api from '../../utils/api'
import wxParse from 'mpvue-wxparse'

export default {
  data () {
    return {
      id: 0,
      topic: {},
      topicList: [],
      commentCount: 0,
      commentList: []
    }
  },

  props: {},

  computed: {},

  mounted () {
    this.id = +this.$root.$mp.query.id
    this.getDetail()
    this.getCommentList()
  },

  methods: {
    getDetail () {
      // 页面初始化 options为页面跳转所带来的参数
      var that = this

      util.request(api.TopicDetail, { id: that.id }).then(function (res) {
        if (res.errno === 0) {
          Object.assign(that.$data, {
            topic: res.data
          })

          // WxParse.wxParse('topicDetail', 'html', res.data.content, that)
        }
      })

      util.request(api.TopicRelated, { id: that.id }).then(function (res) {
        if (res.errno === 0) {
          Object.assign(that.$data, {
            topicList: res.data
          })
        }
      })
    },
    getCommentList () {
      let that = this
      util
        .request(api.CommentList, { valueId: that.id, typeId: 1, size: 5 })
        .then(function (res) {
          if (res.errno === 0) {
            Object.assign(that.$data, {
              commentList: res.data.data,
              commentCount: res.data.count
            })
          }
        })
    },
    postComment () {
      wx.navigateTo({
        url:
          '/pages/commentPost/commentPost?valueId=' + this.id + '&typeId=1'
      })
    }
  },

  components: {
    wxParse
  }
}
</script>

<style scoped>
.content{
    width: 100%;
    height: auto;
    font-size: 0;
}

.content image{
    display: inline-block;
    width: 100%;
}

.comments{
    width: 100%;
    height: auto;
    padding-left:30rpx;
    background: #fff;
    margin-top: 20rpx;
}

.comments .h{
    height: 93rpx;
    line-height: 93rpx;
    width: 720rpx;
    padding-right: 30rpx;
    border-bottom: 1px solid #d9d9d9;
}

.comments .h .t{
    display: block;
    float: left;
    width: 50%;
    font-size: 29rpx;
    color: #333;
}

.comments .h .i{
    display: block;
    float: right;
    margin-top: 30rpx;
    width: 33rpx;
    height: 33rpx;
}

.comments .b{
    height: auto;
    width: 720rpx;
}

.comments .item{
    height: auto;
    width: 720rpx;
    overflow: hidden;
    border-bottom: 1px solid #d9d9d9;
}

.comments .info{
    height: 127rpx;
    width: 100%;
    padding: 33rpx 0 27rpx 0;
}

.comments .user{
    float: left;
    width: auto;
    height: 67rpx;
    line-height: 67rpx;
    font-size: 0;
}

.comments .user .avatar{
    display: block;
    float: left;
    width: 67rpx;
    height: 67rpx;
    margin-right: 17rpx;
    border-radius: 50%;
}

.comments .user .nickname{
    display: block;
    width: auto;
    float: left;
    height: 66rpx;
    overflow: hidden;
    font-size: 29rpx;
    line-height: 66rpx;
}

.comments .time{
    display: block;
    float: right;
    width: auto;
    height: 67rpx;
    line-height: 67rpx;
    color: #7f7f7f;
    font-size: 25rpx;
    margin-right: 30rpx;
}

.comments .comment{
    width: 720rpx;
    padding-right: 30rpx;
    line-height: 45.8rpx;
    margin-bottom: 30rpx;
    font-size: 29rpx;
    color: #333;
}

.comments .load{
    width: 720rpx;
    height: 108rpx;
    line-height: 108rpx;
    text-align: center;
    font-size: 38.5rpx;
}

.no-comments{
    height: 297rpx;
}

.no-comments .txt{
    height: 43rpx;
    line-height: 43rpx;
    display: block;
    width: 100%;
    text-align: center;
    font-size: 29rpx;
    color: #7f7f7f;
}

.no-comments .icon{
    margin: 48rpx auto 18rpx auto;
    height: 130rpx;
    display: block;
    width: 115rpx;
}


.rec-box{
    width: 690rpx;
    height: auto;
    margin: 0 30rpx;
}

.rec-box .h{
    position: relative;
    width: 690rpx;
    height: 96rpx;
    /*border-bottom: 1px solid #d0d0d0;*/
    margin-bottom: 32rpx;
}

.rec-box .h .txt{
    display: inline-block;
    position: absolute;
    background: #f4f4f4;
    top: 59rpx;
    left: 200rpx;
    width: 290rpx;
    height: 45rpx;
    line-height: 45rpx;
    font-size: 30rpx;
    color: #999;
    text-align: center;
}

.rec-box .b .item{
    width: 690rpx;
    height: 397rpx;
    padding: 24rpx 24rpx 30rpx 24rpx;
    background: #fff;
    margin-bottom: 30rpx;
}

.rec-box .b .item .img{
    height: 278rpx;
    width: 642rpx;
}

.rec-box .b .item .title{
    display: block;
    margin-top: 30rpx;
    height: 30rpx;
    width: 642rpx;
    font-size: 28rpx;
}
</style>