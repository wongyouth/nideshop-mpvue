<template lang="pug">
  .brand
    .container
      .brand-list
        a.item(
          v-for="item in brandList"
          :key="item.id"
          :href="'../brandDetail/brandDetail?id=' + item.id"
        )
          .img-bg
            image(:src="item.app_list_pic_url" background-size="cover")
          .txt-box
            .line
              text.name {{item.name}}
              text.s |
              text.price {{item.floor_price}}元起

</template>

<script>
import util from '../../utils/util'
import api from '../../utils/api'

export default {
  data () {
    return {
      brandList: [],
      page: 1,
      size: 10,
      totalPages: 1
    }
  },

  props: {},

  computed: {},

  mounted () {
    this.getBrandList()
  },

  methods: {
    getBrandList: function () {
      wx.showLoading({
        title: '加载中...'
      })
      let that = this
      util
        .request(api.BrandList, { page: that.page, size: that.size })
        .then(function (res) {
          if (res.errno === 0) {
            Object.assign(that.$data, {
              brandList: that.brandList.concat(res.data.data),
              totalPages: res.data.totalPages
            })
          }
          wx.hideLoading()
        })
    },
    onReachBottom () {
      if (this.totalPages > this.page) {
        this.page = this.page + 1
      } else {
        return false
      }

      this.getBrandList()
    }
  },

  components: {}
}
</script>

<style scoped>
.brand-list .item{
    display: block;
    width: 750rpx;
    height: 416rpx;
    position: relative;
    margin-bottom: 4rpx;
}

.brand-list .item .img-bg{
    position: absolute;
    left:0;
    top:0;
    z-index: 0;
    width: 750rpx;
    height: 417rpx;
    overflow: hidden;
}

.brand-list .item .img-bg image{
    width: 750rpx;
    height: 416rpx;
}

.brand-list .item .txt-box{
    position: absolute;
    left:0;
    top:0;
    display: table;
    z-index: 0;
    width: 750rpx;
    height: 417rpx;
}

.brand-list .item .line{
    display: table-cell;
    vertical-align: middle;
    text-align: center;
    height: 63rpx;
    line-height: 63rpx;
}

.brand-list .item .line text{
    font-size: 35rpx;
    font-weight: 700;
    text-shadow: 1rpx 1rpx rgba(0,0,0,.32);
    color: #fff;
}

.brand-list .item .line .s{
    padding: 0 10rpx;
    font-size: 40rpx;
}
</style>