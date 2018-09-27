<template lang="pug">
  .comment-post
    .container
      .post-comment
        .input-box
          textarea.content(:focus='true', @input='bindInpuntValue', :maxlength='140', placeholder='留言经过筛选后，对所有人可见')
          text.count {{140 - content.length}}
        .btns
          .close(@click="onClose") 取消
          .post(@click="onPost") 发表
</template>

<script>
import util from '../../utils/util'
import api from '../../utils/api'

export default {
  data () {
    return {
      typeId: 0,
      valueId: 0,
      content: ''
    }
  },

  props: {},

  computed: {
  },

  mounted () {
    this.typeId = +this.$root.$mp.query.typeId
    this.valueId = +this.$root.$mp.query.valueId
  },

  methods: {
    onClose () {
      wx.navigateBack({
        delta: 1
      })
    },
    onPost () {
      let that = this

      if (!this.content) {
        util.showErrorToast('请填写评论')
        return false
      }

      util
        .request(
          api.CommentPost,
          {
            typeId: that.typeId,
            valueId: that.valueId,
            content: that.content
          },
          'POST'
        )
        .then(function (res) {
          if (res.errno === 0) {
            wx.showToast({
              title: '评论成功',
              complete: function () {
                wx.navigateBack({
                  delta: 1
                })
              }
            })
          }
          console.log(res)
        })
    },
    bindInpuntValue (event) {
      let value = event.target.value

      // 判断是否超过140个字符
      if (value && value.length > 140) {
        return false
      }

      Object.assign(this.$data, {
        content: value
      })
      console.log(event.target)
    }
  },

  components: {}
}
</script>

<style>
page, .container {
  height: 100%;
  background: #f4f4f4;
}

.post-comment {
  width: 750rpx;
  height: auto;
  overflow: hidden;
  padding: 30rpx;
}

.post-comment .input-box {
  height: 337.5rpx;
  width: 690rpx;
  position: relative;
  background: #fff;
}

.post-comment .input-box .content {
  position: absolute;
  top: 0;
  left: 0;
  display: block;
  background: #fff;
  font-size: 29rpx;
  color: #333;
  height: 300rpx;
  width: 650rpx;
  padding: 20rpx;
}

.post-comment .input-box .count {
  position: absolute;
  bottom: 20rpx;
  right: 20rpx;
  display: block;
  height: 30rpx;
  width: 50rpx;
  font-size: 29rpx;
  color: #999;
}

.post-comment .btns {
  height: 108rpx;
}

.post-comment .close {
  float: left;
  height: 108rpx;
  line-height: 108rpx;
  text-align: left;
  color: #666;
  padding: 0 30rpx;
}

.post-comment .post {
  float: right;
  height: 108rpx;
  line-height: 108rpx;
  text-align: right;
  padding: 0 30rpx;
}
</style>
