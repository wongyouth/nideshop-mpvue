<template lang="pug">
  .footprint
    .day-item(v-for='(item,index) in footprintList' :key='index')
      .day-hd {{item[0].add_time}}
      .day-list
        .item(
          v-for='(iitem,iindex) in item'
          :key='iitem.id'
          data-footprint='iitem'
          @longpress='deleteItem(iitem)'
          @click='onClick(iitem)'
        )
          img.img(src='iitem.list_pic_url')
          .info
            .name {{iitem.name}}
            .subtitle {{iitem.goods_brief}}
            .price ￥{{iitem.retail_price}}

</template>

<script>
import util from '../../utils/util'
import api from '../../utils/api'

export default {
  data () {
    return {
      footprintList: []
    }
  },

  props: {},

  computed: {},

  mounted () {
    this.getFootprintList()
  },

  methods: {
    getFootprintList () {
      let that = this
      util.request(api.FootprintList).then(function (res) {
        if (res.errno === 0) {
          console.log(res.data)
          Object.assign(that.$data, {
            footprintList: res.data.data
          })
        }
      })
    },
    deleteItem (footprint) {
      let that = this
      wx.showModal({
        title: '',
        content: '要删除所选足迹？',
        success: function (res) {
          if (res.confirm) {
            util
              .request(
                api.FootprintDelete,
                { footprintId: footprint.id },
                'POST'
              )
              .then(function (res) {
                if (res.errno === 0) {
                  wx.showToast({
                    title: '删除成功',
                    icon: 'success',
                    duration: 2000
                  })
                  that.getFootprintList()
                }
              })
            console.log('用户点击确定')
          }
        }
      })
    },

    onClick (footprint) {
      wx.navigateTo({
        url: '/pages/goods/goods?id=' + footprint.goods_id
      })
    }
  },

  components: {}
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
}

.footprint{
   height: auto;
  overflow: hidden;
  width: 100%;
  border-top: 1px solid #e1e1e1;
}

.day-item{
  height: auto;
  overflow: hidden;
  width: 100%;
  margin-bottom: 20rpx;
}

.day-hd{
  height: 94rpx;
  width: 100%;
  line-height: 94rpx;
  background: #fff;
  padding-left: 30rpx;
  color: #333;
  font-size: 28rpx;
}

.day-list{
  width: 100%;
  height: auto;
  overflow: hidden;
  background: #fff;
  padding-left: 30rpx;
  border-top: 1px solid #e1e1e1;
}

.item{
  height: 212rpx;
  width: 720rpx;
  background: #fff;
  padding: 30rpx 30rpx 30rpx 0;
  border-bottom: 1px solid #e1e1e1;
}

.item:last-child{
  border-bottom: 1px solid #fff;
}

.item .img{
  float: left;
  width: 150rpx;
  height: 150rpx;
}

.item .info{
  float: right;
  width: 540rpx;
  height: 150rpx;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding-left: 20rpx;
}

.item .info .name{
  font-size: 28rpx;
  color: #333;
  line-height: 40rpx;
}


.item .info .subtitle{
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #888;
  line-height: 40rpx;
}

.item .info .price{
  margin-top: 8rpx;
  font-size: 28rpx;
  color: #333;
  line-height: 40rpx;
}

</style>
