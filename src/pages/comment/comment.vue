<template lang="pug">
.comment
  .comments
    .h
      .item(:class="showType === 0 ? 'active' : ''" @click='switchTab')
        .txt 全部({{allCount}})
      .item(:class="showType === 0 ? '' : 'active'" @click='switchTab')
        .txt 有图({{hasPicCount}})
    .b
      .item(v-for='item in comments' :key='item.id')
        .info
          .user
            image(:src='item.user_info.avatar')
            text {{item.user_info.nickname}}
          .time {{item.add_time}}
        .comment {{item.content}}
        .imgs(v-if='item.pic_list.length > 0')
          image.img(v-for='(pitem,_) in item.pic_list' :key='pitem.id' :src='pitem.pic_url')
        //- .spec
          text.item 白色 2件
        //- .customer-service(v-if='item.commentReplyVO')
          text.u 小选回复：
          text.c {{item.commentReplyVO.replyContent}}

</template>

<script>
import util from '../../utils/util'
import api from '../../utils/api'

export default {
  data () {
    return {
      comments: [],
      allCommentList: [],
      picCommentList: [],
      typeId: 0,
      valueId: 0,
      showType: 0,
      allCount: 0,
      hasPicCount: 0,
      allPage: 1,
      picPage: 1,
      size: 20
    }
  },

  props: {},

  computed: {},

  mounted () {
    this.typeId = +this.$root.$mp.query.typeId
    this.valueId = +this.$root.$mp.query.valueId
    this.getCommentCount()
    this.getCommentList()
  },

  methods: {
    getCommentCount: function () {
      let that = this
      util
        .request(api.CommentCount, {
          valueId: that.valueId,
          typeId: that.typeId
        })
        .then(function (res) {
          if (res.errno === 0) {
            Object.assign(that.$data, {
              allCount: res.data.allCount,
              hasPicCount: res.data.hasPicCount
            })
          }
        })
    },
    getCommentList: function () {
      let that = this
      util
        .request(api.CommentList, {
          valueId: that.valueId,
          typeId: that.typeId,
          size: that.size,
          page: that.showType === 0 ? that.allPage : that.picPage,
          showType: that.showType
        })
        .then(function (res) {
          if (res.errno === 0) {
            if (that.showType === 0) {
              Object.assign(that.$data, {
                allCommentList: that.allCommentList.concat(res.data.data),
                allPage: res.data.currentPage,
                comments: that.allCommentList.concat(res.data.data)
              })
            } else {
              Object.assign(that.$data, {
                picCommentList: that.picCommentList.concat(res.data.data),
                picPage: res.data.currentPage,
                comments: that.picCommentList.concat(res.data.data)
              })
            }
          }
        })
    },
    switchTab: function () {
      Object.assign(this.$data, {
        showType: this.showType === 1 ? 0 : 1
      })

      this.getCommentList()
    },
    onReachBottom: function () {
      console.log('onPullDownRefresh')
      if (this.showType === 0) {
        if (this.allCount / this.size < this.allPage) {
          return false
        }

        Object.assign(this.$data, {
          allPage: this.allPage + 1
        })
      } else {
        if (this.hasPicCount / this.size < this.picPage) {
          return false
        }

        Object.assign(this.$data, {
          picPage: this.picPage + 1
        })
      }

      this.getCommentList()
    }
  },

  components: {}
}
</script>

<style scoped>
.comments{
    width: 100%;
    height: auto;
    padding-left:30rpx;
    background: #fff;
    margin: 20rpx 0;
}

.comments .h{
    position: fixed;
    left:0;
    top:0;
    z-index: 1000;
    width: 100%;
    display: flex;   
    background: #fff;
    height: 84rpx;
    border-bottom: 1px solid rgba(0,0,0,.15);
}

.comments .h .item{
    display: inline-block;
    height: 82rpx;
    width: 50%;
    padding: 0 15rpx;
    text-align: center;
}

.comments .h .item .txt{
    display: inline-block;
    height: 82rpx;
    padding: 0 20rpx;
    line-height: 82rpx;
    color: #333;
    font-size: 30rpx;
    width: 170rpx;
}

.comments .h .item.active .txt{
    color: #ab2b2b;
    border-bottom: 4rpx solid #ab2b2b;
}

.comments .b{
    margin-top: 85rpx;
    height: auto;
    width: 720rpx;
}

.comments .b.no-h{
    margin-top: 0;
}

.comments .item{
    height: auto;
    width: 720rpx;
    overflow: hidden;
    border-bottom: 1px solid #d9d9d9;
    padding-bottom: 25rpx;
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

.comments .user image{
    float: left;
    width: 67rpx;
    height: 67rpx;
    margin-right: 17rpx;
    border-radius: 50%;
}

.comments .user text{
    display: inline-block;
    width: auto;
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
    font-size: 29rpx;
    margin-bottom: 16rpx;
}

.comments .imgs{
    width: 720rpx;
    height: 150rpx;
    margin-bottom: 25rpx;
}

.comments .imgs .img{
    height: 150rpx;
    width: 150rpx;
    margin-right: 28rpx;
}

.comments .spec{
    width: 720rpx;
    height: 25rpx;
    font-size: 24rpx;
    color: #999;
}

.comments .spec .item{
    color: #7f7f7f;
    font-size: 25rpx;
}

.comments .customer-service{
    width: 690rpx;
    height: auto;
    overflow: hidden;
    margin-top: 23rpx;
    background: rgba(0,0,0,.03);
    padding: 21rpx;
}


.comments .customer-service .u{
    font-size: 24rpx;
    color: #333;
    line-height: 37.5rpx;
}

.comments .customer-service .c{
    font-size: 24rpx;
    color: #999;
    line-height: 37.5rpx;
}
</style>
