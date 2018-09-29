<template lang="pug">
  .container
    .service-policy
      .item 30天无忧退货
      .item 48小时快速退款;
      .item 满88元免邮费
    .no-cart(v-if="cartGoods.length <= 0")
      .c
        img(src="http://nos.netease.com/mailpub/hxm/yanxuan-wap/p/20150730/style/img/icon-normal/noCart-a8fe3f12e5.png")
        text 去添加点什么吧
    .cart-view(v-if="cartGoods.length > 0")
      .list
        .group-item
          .goods
            .item(:class="isEditCart ? 'edit' : ''" v-for="(item,index) in cartGoods" :key="item.id")
              .checkbox(:class="item.checked ? 'checked' : ''" @click="checkedItem(index)")
              .cart-goods
                img.img(:src="item.list_pic_url")
                .info
                  .t
                    text.name {{item.goods_name}}
                    text.num x{{item.number}}
                  .attr {{ isEditCart ? '已选择:' : ''}}{{item.goods_specifition_name_value}}
                  .b
                    text.price ￥{{item.retail_price}}
                    .selnum
                      .cut(@click="cutNumber(index)") -
                      input.number(:value="item.number" :disabled="true" type="number")
                      .add(@click="addNumber(index)") +
        //-.group-item
          .header
            .promotion
              text.tag 满赠
              text.txt 再加26元, 3件赠1件蔓越莓干
              image.icon(src="http://nos.netease.com/mailpub/hxm/yanxuan-wap/p/20150730/style/img/icon-normal/go-b67cb9718d.png")
            .get 领赠品
          .goods
            .item
              .checkbox
              .cart-goods
                image.img(src="http://yanxuan.nosdn.127.net/04e05e9de3a471b1f6479dd137b459a8.png")
                .info
                  .t
                    text.name 秋冬保暖加厚细羊毛被
                    text.num x1
                  .attr 220*240cm
                  .b
                    text.price ￥199.99
                    .open 优惠活动
      .cart-bottom
        .checkbox(:class="checkedAllStatus ? 'checked' : ''" @click="checkedAll") 全选({{cartTotal.checkedGoodsCount}})
        .total {{!isEditCart ? '￥'+cartTotal.checkedGoodsAmount : ''}}
        .delete(@click="editCart") {{!isEditCart ? '编辑' : '完成'}}
        .checkout(@click="deleteCart" v-if="isEditCart") 删除所选
        .checkout(@click="checkoutOrder" v-if="!isEditCart") 下单

</template>

<script>
import util from '../../utils/util'
import api from '../../utils/api'

export default {
  data () {
    return {
      cartGoods: [],
      cartTotal: {
        goodsCount: 0,
        goodsAmount: 0.0,
        checkedGoodsCount: 0,
        checkedGoodsAmount: 0.0
      },
      isEditCart: false,
      checkedAllStatus: true,
      editCartList: []
    }
  },

  props: {},

  computed: {},

  mounted () {},

  onShow: function () {
    // 页面显示
    this.getCartList()
  },

  methods: {
    getCartList: function () {
      let that = this
      util.request(api.CartList).then(function (res) {
        if (res.errno === 0) {
          console.log(res.data)
          Object.assign(that.$data, {
            cartGoods: res.data.cartList,
            cartTotal: res.data.cartTotal
          })
        }

        Object.assign(that.$data, {
          checkedAllStatus: that.isCheckedAll()
        })
      })
    },
    isCheckedAll: function () {
      // 判断购物车商品已全选
      return this.cartGoods.every(function (element, index, array) {
        if (element.checked) {
          return true
        } else {
          return false
        }
      })
    },
    checkedItem: function (itemIndex) {
      let that = this

      if (!this.isEditCart) {
        util
          .request(
            api.CartChecked,
            {
              productIds: that.cartGoods[itemIndex].product_id,
              isChecked: that.cartGoods[itemIndex].checked ? 0 : 1
            },
            'POST'
          )
          .then(function (res) {
            if (res.errno === 0) {
              console.log(res.data)
              Object.assign(that.$data, {
                cartGoods: res.data.cartList,
                cartTotal: res.data.cartTotal
              })
            }

            Object.assign(that.$data, {
              checkedAllStatus: that.isCheckedAll()
            })
          })
      } else {
        // 编辑状态
        let tmpCartData = this.cartGoods.map(function (
          element,
          index,
          array
        ) {
          if (index === itemIndex) {
            element.checked = !element.checked
          }

          return element
        })

        Object.assign(that.$data, {
          cartGoods: tmpCartData,
          checkedAllStatus: that.isCheckedAll(),
          'cartTotal.checkedGoodsCount': that.getCheckedGoodsCount()
        })
      }
    },
    getCheckedGoodsCount: function () {
      let checkedGoodsCount = 0
      this.cartGoods.forEach(function (v) {
        if (v.checked === true) {
          checkedGoodsCount += v.number
        }
      })
      console.log(checkedGoodsCount)
      return checkedGoodsCount
    },
    checkedAll: function () {
      let that = this

      if (!this.isEditCart) {
        var productIds = this.cartGoods.map(function (v) {
          return v.product_id
        })
        util
          .request(
            api.CartChecked,
            {
              productIds: productIds.join(','),
              isChecked: that.isCheckedAll() ? 0 : 1
            },
            'POST'
          )
          .then(function (res) {
            if (res.errno === 0) {
              console.log(res.data)
              Object.assign(that.$data, {
                cartGoods: res.data.cartList,
                cartTotal: res.data.cartTotal
              })
            }

            Object.assign(that.$data, {
              checkedAllStatus: that.isCheckedAll()
            })
          })
      } else {
        // 编辑状态
        let checkedAllStatus = that.isCheckedAll()
        let tmpCartData = this.cartGoods.map(function (v) {
          v.checked = !checkedAllStatus
          return v
        })

        Object.assign(that.$data, {
          cartGoods: tmpCartData,
          checkedAllStatus: that.isCheckedAll(),
          'cartTotal.checkedGoodsCount': that.getCheckedGoodsCount()
        })
      }
    },
    editCart: function () {
      var that = this
      if (this.isEditCart) {
        this.getCartList()
        Object.assign(this.$data, {
          isEditCart: !this.isEditCart
        })
      } else {
        // 编辑状态
        let tmpCartList = this.cartGoods.map(function (v) {
          v.checked = false
          return v
        })
        Object.assign(this.$data, {
          editCartList: this.cartGoods,
          cartGoods: tmpCartList,
          isEditCart: !this.isEditCart,
          checkedAllStatus: that.isCheckedAll(),
          'cartTotal.checkedGoodsCount': that.getCheckedGoodsCount()
        })
      }
    },
    updateCart: function (productId, goodsId, number, id) {
      let that = this

      util
        .request(
          api.CartUpdate,
          {
            productId: productId,
            goodsId: goodsId,
            number: number,
            id: id
          },
          'POST'
        )
        .then(function (res) {
          if (res.errno === 0) {
            console.log(res.data)
            Object.assign(that.$data, {
              // cartGoods: res.data.cartList,
              // cartTotal: res.data.cartTotal
            })
          }

          Object.assign(that.$data, {
            checkedAllStatus: that.isCheckedAll()
          })
        })
    },
    cutNumber: function (itemIndex) {
      let cartItem = this.cartGoods[itemIndex]
      let number = cartItem.number - 1 > 1 ? cartItem.number - 1 : 1
      cartItem.number = number
      Object.assign(this.$data, {
        cartGoods: this.cartGoods
      })
      this.updateCart(
        cartItem.product_id,
        cartItem.goods_id,
        number,
        cartItem.id
      )
    },
    addNumber: function (itemIndex) {
      let cartItem = this.cartGoods[itemIndex]
      let number = cartItem.number + 1
      cartItem.number = number
      Object.assign(this.$data, {
        cartGoods: this.cartGoods
      })
      this.updateCart(
        cartItem.product_id,
        cartItem.goods_id,
        number,
        cartItem.id
      )
    },
    checkoutOrder: function () {
      // 获取已选择的商品
      var checkedGoods = this.cartGoods.filter(function (
        element,
        index,
        array
      ) {
        if (element.checked) {
          return true
        } else {
          return false
        }
      })

      if (checkedGoods.length <= 0) {
        return false
      }

      wx.navigateTo({
        url: '../shopping/checkout'
      })
    },
    deleteCart: function () {
      // 获取已选择的商品
      const that = this

      let productIds = this.cartGoods.filter(function (
        element,
        index,
        array
      ) {
        if (element.checked) {
          return true
        } else {
          return false
        }
      })

      if (productIds.length <= 0) {
        return false
      }

      productIds = productIds.map(function (element, index, array) {
        if (element.checked) {
          return element.product_id
        }
      })

      util
        .request(
          api.CartDelete,
          {
            productIds: productIds.join(',')
          },
          'POST'
        )
        .then(function (res) {
          if (res.errno === 0) {
            console.log(res.data)
            let cartList = res.data.cartList.map(v => {
              console.log(v)
              v.checked = false
              return v
            })

            Object.assign(that.$data, {
              cartGoods: cartList,
              cartTotal: res.data.cartTotal
            })
          }

          Object.assign(that.$data, {
            checkedAllStatus: that.isCheckedAll()
          })
        })
    }
  },

  components: {}
}
</script>

<style lang="stylus">
page{
    height: 100%;
    min-height: 100%;
    background: #f4f4f4;
}
.container{
    background: #f4f4f4;
    width: 100%;
    height: auto;
    min-height: 100%;
    overflow: hidden;
}
.service-policy{
    width: 750rpx;
    height: 73rpx;
    background: #f4f4f4;
    padding: 0 31.25rpx;
    display: flex;
    flex-flow: row nowrap;
    align-items: center;
    justify-content: space-between;
}

.service-policy .item{
    background: url(http://nos.netease.com/mailpub/hxm/yanxuan-wap/p/20150730/style/img/icon-normal/servicePolicyRed-518d32d74b.png) 0 center no-repeat;
    background-size: 10rpx;
    padding-left: 15rpx;
    display: flex;
    align-items: center;
    font-size: 25rpx;
    color: #666;
}

.no-cart{
    width: 100%;
    height: auto;
    margin: 0 auto;
}

.no-cart .c{
    width: 100%;
    height: auto;
    margin-top: 200rpx;
}

.no-cart .c image{
    margin: 0 auto;
    display: block;
    text-align: center;
    width: 258rpx;
    height: 258rpx;
}

.no-cart .c text{
    margin: 0 auto;
    display: block;
    width: 258rpx;
    height: 29rpx;
    line-height: 29rpx;
    text-align: center;
    font-size: 29rpx;
    color: #999;
}


.cart-view{
    width: 100%;
    height: auto;
    overflow: hidden;
    
}

.cart-view .list{
    height: auto;
    width: 100%;
    overflow: hidden;
    margin-bottom: 120rpx;
}

.cart-view .group-item{
    height: auto;
    width: 100%;
    background: #fff;
    margin-bottom: 18rpx;
}

.cart-view .item{
    height: 164rpx;
    width: 100%;
    overflow: hidden;
}
.cart-view .item .checkbox{
    float: left;
    height: 34rpx;
    width: 34rpx;
    margin: 65rpx 18rpx 65rpx 26rpx;
    background: url(http://nos.netease.com/mailpub/hxm/yanxuan-wap/p/20150730/style/img/icon-normal/checkbox-0e09baa37e.png) no-repeat;
    background-size: 34rpx;
}

.cart-view .item .checkbox.checked{
    background: url(http://nos.netease.com/mailpub/hxm/yanxuan-wap/p/20150730/style/img/icon-normal/checkbox-checked-822e54472a.png) no-repeat;
    background-size: 34rpx;
}

.cart-view .item .cart-goods{
    float: left;
    height: 164rpx;
    width: 672rpx;
    border-bottom: 1px solid #f4f4f4;
}

.cart-view .item .img{
    float: left;
    height:125rpx;
    width: 125rpx;
    background: #f4f4f4;
    margin: 19.5rpx 18rpx 19.5rpx 0;
}

.cart-view .item .info{
    float: left;
    height:125rpx;
    width: 503rpx;
    margin: 19.5rpx 26rpx 19.5rpx 0;
}

.cart-view .item .t{
    margin: 8rpx 0;
    height: 28rpx;
    font-size: 25rpx;
    color: #333;
    overflow: hidden;
}


.cart-view .item .name{
    height: 28rpx;
    max-width: 310rpx;
    line-height: 28rpx;
    font-size: 25rpx;
    color: #333;
    overflow: hidden;
}

.cart-view .item .num{
    height: 28rpx;
    line-height: 28rpx;
    float: right;
}

.cart-view .item .attr{
    margin-bottom: 17rpx;
    height: 24rpx;
    line-height: 24rpx;
    font-size: 22rpx;
    color: #666;
    overflow: hidden;
}

.cart-view .item .b{
    height: 28rpx;
    line-height: 28rpx;
    font-size: 25rpx;
    color: #333;
    overflow: hidden;
}

.cart-view .item .price{
    float: left;
}

.cart-view .item .open{
    height: 28rpx;
    width: 150rpx;
    display: block;
    float: right;
    background: url(http://nos.netease.com/mailpub/hxm/yanxuan-wap/p/20150730/style/img/icon-normal/arrowDown-d48093db25.png) right center no-repeat;
    background-size: 25rpx;
    font-size: 25rpx;
    color: #333;
}

.cart-view .item.edit .t{
    display: none;
}

.cart-view .item.edit .attr{
    text-align: right;
    background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/icon-normal/arrow-right1-e9828c5b35.png) right center no-repeat;
    padding-right: 25rpx;
    background-size: 12rpx 20rpx;
    margin-bottom: 24rpx;
    height: 39rpx;
    line-height: 39rpx;
    font-size: 24rpx;
    color: #999;
    overflow: hidden;
}

.cart-view .item.edit .b{
    display: flex;
    height: 52rpx;
    overflow: hidden;
}

.cart-view .item.edit .price{
    line-height: 52rpx;
    height: 52rpx;
    flex: 1;
}

.cart-view .item .selnum{
    display: none;
}

.cart-view .item.edit .selnum{
    width: 235rpx;
    height: 52rpx;
    border: 1rpx solid #ccc;
    display: flex;
}

.selnum .cut{
    width: 70rpx;
    height: 100%;
    text-align: center;
    line-height: 50rpx;
}

.selnum .number{
    flex: 1;
    height: 100%;
    text-align: center;
    line-height: 68.75rpx;
    border-left: 1px solid #ccc;
    border-right: 1px solid #ccc;
    float: left;
}

.selnum .add{
    width: 80rpx;
    height: 100%;
    text-align: center;
    line-height: 50rpx;
}


.cart-view .group-item .header{
    width: 100%;
    height: 94rpx;
    line-height: 94rpx;
    padding: 0 26rpx;
    border-bottom: 1px solid #f4f4f4;
}

.cart-view .promotion .icon{
    display: inline-block;
    height: 24rpx;
    width: 15rpx;
}

.cart-view .promotion{
    margin-top: 25.5rpx;
    float: left;
    height: 43rpx;
    width: 480rpx;
    /*margin-right: 84rpx;*/
    line-height: 43rpx;
    font-size: 0;
}

.cart-view .promotion .tag{
    border: 1px solid #f48f18;
    height: 37rpx;
    line-height: 31rpx;
    padding: 0 9rpx;
    margin-right: 10rpx;
    color: #f48f18;
    font-size: 24.5rpx;
}

.cart-view .promotion .txt{
    height: 43rpx;
    line-height: 43rpx;
    padding-right: 10rpx;
    color: #333;
    font-size: 29rpx;
    overflow: hidden;
}

.cart-view .get{
    margin-top: 18rpx;
    float: right;
    height: 58rpx;
    padding-left: 14rpx;
    border-left: 1px solid #d9d9d9;
    line-height: 58rpx;
    font-size: 29rpx;
    color: #333;
}

.cart-bottom{
    position: fixed;
    bottom:0;
    left:0;
    height: 100rpx;
    width: 100%;
    background: #fff;
    display: flex;
}

.cart-bottom .checkbox{
    height: 34rpx;

    padding-left: 60rpx;
    line-height: 34rpx;
    margin: 33rpx 18rpx 33rpx 26rpx;
    background: url(http://nos.netease.com/mailpub/hxm/yanxuan-wap/p/20150730/style/img/icon-normal/checkbox-0e09baa37e.png) no-repeat;
    background-size: 34rpx;
    font-size: 29rpx;
}

.cart-bottom .checkbox.checked{
    background: url(http://nos.netease.com/mailpub/hxm/yanxuan-wap/p/20150730/style/img/icon-normal/checkbox-checked-822e54472a.png) no-repeat;
    background-size: 34rpx;
}

.cart-bottom .total{
    height: 34rpx;
    flex: 1;
    margin: 33rpx 10rpx;
    font-size: 29rpx;
}


.cart-bottom .delete{
    height: 34rpx;
    width: auto;
    margin: 33rpx 18rpx;
    font-size: 29rpx;
}

.cart-bottom .checkout{
    height: 100rpx;
    width: 210rpx;
    text-align: center;
    line-height: 100rpx;
    font-size: 29rpx;
    background: #b4282d;
    color: #fff;
}
</style>