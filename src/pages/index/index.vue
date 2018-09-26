<template lang="pug">
  .container
    swiper.banner(indicator-dots="true" autoplay="true" interval="3000" duration="1000")
      swiper-item(
        v-for='item in banner'
        :key='item.id'
      )
        a(:href="item.link")
          img(:src="item.image_url" style='background-size:cover;')
    .m-menu
      a.item(
        v-for='item in channel'
        :key='item.id'
        :href='item.url'
      )
        img(:src="item.icon_url" style='background-size:cover;')
        text {{item.name}}
    .a-section.a-brand
      .h
        a(href="../brand/index")
          text.txt 品牌制造商直供
      .b
        .item.item-1(v-for="item in brands" :key="item.id")
          a(:href="'/pages/brand/detail?id=' + item.id")
            .wrap
              img.img(:src="item.new_pic_url" mode="aspectFill")
              .mt
                text.brand {{item.name}}
                text.price {{item.floor_price}}
                text.unit 元起
    .a-section.a-new(v-if="newGoods.length > 0")
      .h
        div
          a(href="../goods/new")
            text.txt 周一周四 · 新品首发
      .b
        .item(
          v-for="(item,index) in newGoods"
          :key="item.id"
        )
          a(:href="'../goods/goods?id='+item.id")
            img.img(:src="item.list_pic_url" style='background-size:cover;')
            text.name {{item.name}}
            text.price ￥{{item.retail_price}}
    .a-section.a-popular(v-if="hotGoods.length > 0")
      .h
        div
          a(href="../goods/hot")
            text.txt 人气推荐
      .b
        .item(v-for="(item,index) in hotGoods" :key="item.id")
          a(:href="'/pages/goods/goods?id='+item.id")
            img.img(:src="item.list_pic_url" style="background-size:cover;")
            .right
              .text
                text.name {{item.name}}
                text.desc {{item.goods_brief}}
                text.price ￥{{item.retail_price}}
    .a-section.a-topic(v-if="topics.length > 0")
      .h
        div
          a(href="../topic/topic" open-type="switchTab")
            text.txt 专题精选
      .b
        scroll-view.list(:scroll-x="true")
          .item(v-for="(item,index) in topics" :key="item.id")
            a(:href="'../topicDetail/topicDetail?id='+item.id")
              img.img(:src="item.scene_pic_url" style="background-size:cover")
              .np
                text.name {{item.title}}
                text.price ￥{{item.price_info}}元起
              text.desc {{item.subtitle}}
    .good-grid(v-for="item in floorGoods" :key="item.id")
      .h
        div
          text {{item.name}}
      .b
        block(v-for="(iitem,iindex) in item.goodsList" :key="iitem.id")
          .item(class="iindex % 2 == 0 ? '' : 'item-b'")
            a.a(:href="'../goods/goods?id='+ iitem.id")
              img.img(:src="iitem.list_pic_url" style="background-size:cover;")
              text.name {{iitem.name}}
              text.price ￥{{iitem.retail_price}}
        .item.item-b.item-more
          a.more-a(:href="'/pages/category/category?id='+item.id")
            .txt {{'更多'+item.name+'好物'}}
            img.icon(src="../../../static/images/icon_go_more.png" style="background-size:cover")
</template>

<script>
// const util = require('../../utils/util.js')
import util from '../../utils/util'
const api = require('../../utils/api.js')
// const user = require('../../services/user.js')

export default {
  data () {
    return {
      newGoods: [],
      hotGoods: [],
      topics: [],
      brands: [],
      floorGoods: [],
      banner: [],
      channel: []
    }
  },

  props: {},

  computed: {},

  mounted () {},

  methods: {
    getIndexData: function () {
      let that = this
      util.request(api.IndexUrl).then(function (res) {
        if (res.errno === 0) {
          Object.assign(that.$data, {
            newGoods: res.data.newGoodsList,
            hotGoods: res.data.hotGoodsList,
            topics: res.data.topicList,
            brands: res.data.brandList,
            floorGoods: res.data.categoryList,
            banner: res.data.banner,
            channel: res.data.channel
          })
        }
      })
    }
  },

  onShareAppMessage: function () {
    return {
      title: 'NideShop',
      desc: '仿网易严选微信小程序商城',
      path: '/pages/index/index'
    }
  },

  onLoad: function (options) {
    this.getIndexData()
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
.banner {
  width: 750rpx;
  height: 417rpx;

  image {
    width: 100%;
    height: 417rpx;
  }
}

.m-menu {
  display: flex;
  height: 181rpx;
  width: 750rpx;
  flex-flow: row nowrap;
  align-items: center;
  justify-content: space-between;
  background-color: #fff;

  .item {
    flex: 1;
    display: block;
    padding: 20rpx 0;
  }

  image {
    display: block;
    width: 58rpx;
    height: 58rpx;
    margin: 0 auto;
    margin-bottom: 12rpx;
  }

  text {
    display: block;
    font-size: 24rpx;
    text-align: center;
    margin: 0 auto;
    line-height: 1;
    color: #333;
  }
}

.a-section {
  width: 750rpx;
  height: auto;
  overflow: hidden;
  background: #fff;
  color: #333;
  margin-top: 20rpx;

  .h {
    display: flex;
    flex-flow: row nowrap;
    align-items: center;
    justify-content: center;
    height: 130rpx;

    .txt {
      padding-right: 30rpx;
      background: url('http://ac-3yr0g9cz.clouddn.com/2cdba05369e10f934e54.png') right 4rpx no-repeat;
      background-size: 16.656rpx 27rpx;
      display: inline-block;
      height: 36rpx;
      font-size: 33rpx;
      line-height: 36rpx;
    }
  }
}

.a-brand {
  .b {
    width: 750rpx;
    height: auto;
    overflow: hidden;
    position: relative;
  }

  .wrap {
    position: relative;
  }

  .img {
    position: absolute;
    left: 0;
    top: 0;
  }

  .mt {
    position: absolute;
    z-index: 2;
    padding: 27rpx 31rpx;
    left: 0;
    top: 0;

    .brand {
      display: block;
      font-size: 33rpx;
      height: 43rpx;
      color: #333;
    }
  }

  .item-1 {
    float: left;
    width: 375rpx;
    height: 252rpx;
    overflow: hidden;
    border-top: 1rpx solid #fff;
    margin-left: 1rpx;

    &:nth-child(2n {
      & + 1) {
        margin-left: 0;
        width: 374rpx;
      }
    }

    .img {
      width: 375rpx;
      height: 253rpx;
    }
  }
}

.a-brand .mt .price, .a-brand .mt .unit {
  font-size: 25rpx;
  color: #999;
}

.a-new {
  .b {
    width: 750rpx;
    height: auto;
    overflow: hidden;
    padding: 0 31rpx 45rpx 31rpx;

    .item {
      float: left;
      width: 302rpx;
      margin-top: 10rpx;
      margin-left: 21rpx;
      margin-right: 21rpx;
    }

    .item-b {
      margin-left: 42rpx;
    }

    .img {
      width: 302rpx;
      height: 302rpx;
    }

    .name {
      text-align: center;
      display: block;
      width: 302rpx;
      height: 35rpx;
      margin-bottom: 14rpx;
      overflow: hidden;
      font-size: 30rpx;
      color: #333;
    }

    .price {
      display: block;
      text-align: center;
      line-height: 30rpx;
      font-size: 30rpx;
      color: #b4282d;
    }
  }
}

.a-popular {
  width: 750rpx;
  height: auto;
  overflow: hidden;

  .b {
    .item {
      border-top: 1px solid #d9d9d9;
      margin: 0 20rpx;
      height: 264rpx;
      width: 710rpx;
    }

    .img {
      margin-top: 12rpx;
      margin-right: 12rpx;
      float: left;
      width: 240rpx;
      height: 240rpx;
    }

    .right {
      float: left;
      height: 264rpx;
      width: 456rpx;
      display: flex;
      flex-flow: row nowrap;
    }

    .text {
      display: flex;
      flex-wrap: nowrap;
      flex-direction: column;
      justify-content: center;
      overflow: hidden;
      height: 264rpx;
      width: 456rpx;
    }

    .name {
      width: 456rpx;
      display: block;
      color: #333;
      line-height: 50rpx;
      font-size: 30rpx;
    }

    .desc {
      width: 456rpx;
      display: block;
      color: #999;
      line-height: 50rpx;
      font-size: 25rpx;
    }

    .price {
      width: 456rpx;
      display: block;
      color: #b4282d;
      line-height: 50rpx;
      font-size: 33rpx;
    }
  }
}

.a-topic {
  .b {
    height: 533rpx;
    width: 750rpx;
    padding: 0 0 48rpx 0;

    .list {
      height: 533rpx;
      width: 750rpx;
      white-space: nowrap;
    }

    .item {
      display: inline-block;
      height: 533rpx;
      width: 680.5rpx;
      margin-left: 30rpx;
      overflow: hidden;

      &:last-child {
        margin-right: 30rpx;
      }
    }

    .img {
      height: 387.5rpx;
      width: 680.5rpx;
      margin-bottom: 30rpx;
    }

    .np {
      height: 35rpx;
      margin-bottom: 13.5rpx;
      color: #333;
      font-size: 30rpx;

      .price {
        margin-left: 20.8rpx;
        color: #b4282d;
      }
    }

    .desc {
      display: block;
      height: 30rpx;
      color: #999;
      font-size: 24rpx;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
  }
}

.good-grid {
  width: 750rpx;
  height: auto;
  overflow: hidden;

  .h {
    display: flex;
    flex-flow: row nowrap;
    align-items: center;
    justify-content: center;
    height: 130rpx;
    font-size: 33rpx;
    color: #333;
  }

  .b {
    width: 750rpx;
    padding: 0 6.25rpx;
    height: auto;
    overflow: hidden;

    .item {
      float: left;
      background: #fff;
      width: 365rpx;
      margin-bottom: 6.25rpx;
      height: 452rpx;
      overflow: hidden;
      text-align: center;

      .a {
        height: 452rpx;
        width: 100%;
      }
    }

    .item-b {
      margin-left: 6.25rpx;
    }
  }

  .item {
    .img {
      margin-top: 20rpx;
      width: 302rpx;
      height: 302rpx;
    }

    .name {
      display: block;
      width: 365.625rpx;
      padding: 0 20rpx;
      overflow: hidden;
      height: 35rpx;
      margin: 11.5rpx 0 22rpx 0;
      text-align: center;
      font-size: 30rpx;
      color: #333;
    }

    .price {
      display: block;
      width: 365.625rpx;
      height: 30rpx;
      text-align: center;
      font-size: 30rpx;
      color: #b4282d;
    }
  }

  .more-item {
    height: 100%;
    width: 100%;
  }

  .more-a {
    .txt {
      height: 33rpx;
      width: 100%;
      line-height: 33rpx;
      color: #333;
      font-size: 33rpx;
    }

    .icon {
      margin: 60rpx auto 0 auto;
      width: 70rpx;
      height: 70rpx;
    }
  }
}

.more-a {
  height: 100%;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
</style>