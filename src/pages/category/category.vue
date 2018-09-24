<template lang="pug">
  .container
    .cate-nav
      scroll-view.cate-nav-body(
        :scroll-x="true" style="width: 750rpx;" :scroll-left="scrollLeft"
      )
        .item(
          v-for="(item,index) in navList"
          :key='item.id'
          :class="id == item.id ? 'active' : ''"
          @click="switchCate(item.id, $event)")
          .name {{item.name}}
    scroll-view(:scroll-y="true" :scroll-top="scrollTop" :style="'height:'+scrollHeight")
      .cate-item
        .h
          text.name {{currentCategory.name}}
          text.desc {{currentCategory.front_name}}
        .b
          a.item(
            :class="(iindex + 1) % 2 == 0 ? 'item-b' : ''"
            :href="'/pages/goods/goods?id='+iitem.id"
            v-for="(iitem,iindex) in goodsList"
            :key='iindex'
          )
            img.img(:src="iitem.list_pic_url" background-size="cover")
            text.name {{iitem.name}}
            text.price ￥{{iitem.retail_price}}

</template>

<script>
import util from '../../utils/util'
import api from '../../utils/api'

export default {
  data () {
    return {
      // text:"这是一个页面"
      navList: [],
      goodsList: [],
      id: 0,
      currentCategory: {},
      scrollLeft: 0,
      scrollTop: 0,
      scrollHeight: 0,
      page: 1,
      size: 10000
    }
  },

  props: {},

  computed: {},

  mounted () {
    var that = this
    if (this.$root.$mp.query.id) {
      this.id = +this.$root.$mp.query.id
    }

    wx.getSystemInfo({
      success: function (res) {
        that.scrollHeight = res.windowHeight
      }
    })

    this.getCategoryInfo()
  },

  methods: {
    getCategoryInfo: function () {
      let that = this
      util.request(api.GoodsCategory, { id: this.id }).then(function (res) {
        if (res.errno === 0) {
          Object.assign(that.$data, {
            navList: res.data.brotherCategory,
            currentCategory: res.data.currentCategory
          })

          // nav位置
          let currentIndex = 0
          let navListCount = that.navList.length
          for (let i = 0; i < navListCount; i++) {
            currentIndex += 1
            if (that.navList[i].id === that.id) {
              break
            }
          }
          if (currentIndex > navListCount / 2 && navListCount > 5) {
            that.scrollLeft = currentIndex * 60
          }
          that.getGoodsList()
        } else {
          // 显示错误信息
        }
      })
    },
    getGoodsList: function () {
      var that = this

      util
        .request(api.GoodsList, {
          categoryId: that.id,
          page: that.page,
          size: that.size
        })
        .then(function (res) {
          that.goodsList = res.data.goodsList
        })
    },
    switchCate: function (id, event) {
      console.log(event)
      if (this.id === id) {
        return false
      }
      var clientX = event.clientX
      var currentTarget = event.currentTarget

      if (clientX < 60) {
        this.scrollLeft = currentTarget.offsetLeft - 60
      } else if (clientX > 330) {
        this.scrollLeft = currentTarget.offsetLeft
      }
      this.id = id

      this.getCategoryInfo()
    }
  },

  components: {}
}
</script>

<style lang="stylus" scoped>
.container{
    background: #f9f9f9;
}
.cate-nav{
    position: fixed;
    left:0;
    top:0;
    z-index: 1000;
}

.cate-nav-body{
    height: 84rpx;
    white-space: nowrap;   
    background: #fff;
    border-top: 1px solid rgba(0,0,0,.15);
    overflow: hidden;
}

.cate-nav .item{
    display: inline-block;
    height: 84rpx;
    min-width: 130rpx;
    padding: 0 15rpx;
}

.cate-nav .item .name{
    display: block;
    height: 84rpx;
    padding: 0 20rpx;
    line-height: 84rpx;
    color: #333;
    font-size: 30rpx;
    width: auto;
}

.cate-nav .item.active .name{
    color: #ab2b2b;
    border-bottom: 2px solid #ab2b2b;
}

.cate-item{
    margin-top: 94rpx;
    height: auto;
    overflow: hidden;
}

.cate-item .h{
    height: 145rpx;
    width: 750rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.cate-item .h .name{
    display: block;
    height: 35rpx;
    margin-bottom: 18rpx;
    font-size: 30rpx;
    color: #333;
}

.cate-item .h .desc{
    display: block;
    height: 24rpx;
    font-size: 24rpx;
    color: #999;
}

.cate-item .b{
  width: 750rpx;
  padding: 0 6.25rpx;
  height: auto;
  overflow: hidden;
}

.cate-item .b .item{
  float: left;
  background: #fff;
  width: 365rpx;
  margin-bottom: 6.25rpx;
  padding-bottom: 33.333rpx;
  height: auto;
  overflow: hidden;
  text-align: center;
}

.cate-item .b .item-b{
  margin-left: 6.25rpx;
}

.cate-item .item .img{
  width: 302rpx;
  height: 302rpx;
}

.cate-item .item .name{
  display: block;
  width: 365.625rpx;
  height: 35rpx;
  margin: 11.5rpx 0 22rpx 0;
  text-align: center;
  overflow: hidden;
  padding: 0 20rpx;
  font-size: 30rpx;
  color: #333;
}

.cate-item .item .price{
  display: block;
  width: 365.625rpx;
  height: 30rpx;
  text-align: center;
  font-size: 30rpx;
  color: #b4282d;
}
</style>