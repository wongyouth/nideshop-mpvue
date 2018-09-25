<template lang="pug">
  .brand-detail
    .container
      .brand-info
        .name
          image.img(:src="brand.app_list_pic_url" background-size="cover")
          .info-box
            .info
              text.txt {{brand.name}}
              text.line
        .desc
          | {{brand.simple_desc}}
      .cate-item
        .b
          block(
            v-for="(item, index) in goodsList"
            :key="item.id"
          )
            a.item(:class="index % 2 === 0 ? 'item-b' : ''" :href="'../goods/goods?id='+item.id")
              image.img(:src="item.list_pic_url" background-size="cover")
              text.name {{item.name}}
              text.price ￥{{item.retail_price}}

</template>

<script>
import util from '../../utils/util'
import api from '../../utils/api'

export default {
  data () {
    return {
      id: 0,
      brand: {},
      goodsList: [],
      page: 1,
      size: 1000
    }
  },

  props: {},

  computed: {},

  mounted () {
    // 页面初始化 options为页面跳转所带来的参数
    this.id = +this.$root.$mp.query.id
    this.getBrand()
  },

  methods: {
    getBrand: function () {
      let that = this
      util.request(api.BrandDetail, { id: that.id }).then(function (res) {
        if (res.errno === 0) {
          that.brand = res.data.brand

          that.getGoodsList()
        }
      })
    },
    getGoodsList () {
      var that = this

      util
        .request(api.GoodsList, {
          brandId: that.id,
          page: that.page,
          size: that.size
        })
        .then(function (res) {
          if (res.errno === 0) {
            that.goodsList = res.data.goodsList
          }
        })
    }
  },

  components: {}
}
</script>

<style>
page{
    background: #f4f4f4;
}
.brand-info .name{
    width: 100%;
    height: 290rpx;
    position: relative;
}

.brand-info .img{
    position: absolute;
    top:0;
    left:0;
    width: 100%;
    height: 290rpx;
}

.brand-info .info-box{
    position: absolute;
    top:0;
    left:0;
    width: 100%;
    height: 290rpx;
    text-align: center;
    display: flex;
    justify-content: center;
    align-items: center;
}

.brand-info .info{
    display: block;
}

.brand-info .txt{
    display: block;
    height: 37.5rpx;
    font-size: 37.5rpx;
    color: #fff;
}

.brand-info .line{
    margin: 0 auto;
    margin-top: 16rpx;
    display: block;
    height: 2rpx;
    width: 145rpx;
    background: #fff;
}

.brand-info .desc{
    background: #fff;
    width: 100%;
    height: auto;
    overflow: hidden;
    padding: 41.5rpx 31.25rpx;
    font-size: 30rpx;
    color: #666;
    line-height: 41.5rpx;
    text-align: center;
}

.cate-item .b{
  width: 750rpx;
  height: auto;
  overflow: hidden;
  border-top: 1rpx solid #f4f4f4;
  margin-top: 20rpx;
}

.cate-item .b .item{
  float: left;
  background: #fff;
  width: 375rpx;
  padding-bottom: 33.333rpx;
  border-bottom: 1rpx solid #f4f4f4;
  height: auto;
  overflow: hidden;
  text-align: center;
}

.cate-item .b .item-b{
 border-right: 1rpx solid #f4f4f4;
}

.cate-item .item .img{
    margin-top: 10rpx;
  width: 302rpx;
  height: 302rpx;
}

.cate-item .item .name{
  display: block;
  width: 365.625rpx;
  height: 35rpx;
  padding: 0 20rpx;
  overflow: hidden;
  margin: 11.5rpx 0 22rpx 0;
  text-align: center;
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