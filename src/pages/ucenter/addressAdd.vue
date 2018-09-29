<template lang="pug">
  .address-add
    .add-address
      .add-form
        .form-item
          input.input(@change='e => address.name = e.target.value', placeholder='姓名', :value='address.name', :auto-focus='true')
        .form-item
          input.input(@change='e => address.mobile = e.target.value', :value='address.mobile', placeholder='手机号码')
        .form-item
          input.input(:value='address.full_region', :disabled='true', @click='chooseRegion', placeholder='省份、城市、区县')
        .form-item
          input.input(@change='e => address.address = e.target.value', :value='address.address', placeholder='详细地址, 如街道、楼盘号等')
        .form-default
          text.default-input(
            :class="{ selected: address.is_default }"
            @click='e => address.is_default = !address.is_default'
          ) 设为默认地址
      .btns
        button.cannel(@click='cancelAddress') 取消
        button.save(@click='saveAddress') 保存
      .region-select(v-if='openSelectRegion')
        .hd
          .region-selected
            .item(
              v-for='(item, index) in selectRegionList'
              :key='item.id'
              :class='{disabled: item.id == 0, selected: (regionType - 1) === index}'
              @click='selectRegionType(index)'
            ) {{item.name}}
          .done(:class='{disabled: !selectRegionDone}' @click='doneSelectRegion') 确定
        .bd
          .region-list
            .item(
              v-for='item in regionList'
              :key='item.id'
              :class='{selected: item.selected}' @click='selectRegion(index)'
            ) {{item.name}}
    .bg-mask(@click='cancelSelectRegion', v-if='openSelectRegion')
</template>

<script>
import util from '../../utils/util'
import api from '../../utils/api'

export default {
  data () {
    return {
      address: {
        id: 0,
        province_id: 0,
        city_id: 0,
        district_id: 0,
        address: '',
        full_region: '',
        name: '',
        mobile: '',
        is_default: false
      },
      addressId: 0,
      openSelectRegion: false,
      selectRegionList: [
        { id: 0, name: '省份', parent_id: 1, type: 1 },
        { id: 0, name: '城市', parent_id: 1, type: 2 },
        { id: 0, name: '区县', parent_id: 1, type: 3 }
      ],
      regionType: 1,
      regionList: [],
      selectRegionDone: false
    }
  },

  props: {},

  computed: {},

  mounted () {
    this.addressId = +this.$root.$mp.query.id
    if (this.addressId) {
      this.getAddressDetail()
    }

    this.getRegionList(1)
  },

  methods: {
    getAddressDetail () {
      let that = this
      util
        .request(api.AddressDetail, { id: that.addressId })
        .then(function (res) {
          if (res.errno === 0) {
            Object.assign(that.$data, {
              address: res.data
            })
          }
        })
    },
    setRegionDoneStatus () {
      let that = this
      let doneStatus = that.selectRegionList.every(item => {
        return item.id !== 0
      })

      Object.assign(that.$data, {
        selectRegionDone: doneStatus
      })
    },
    chooseRegion () {
      Object.assign(this.$data, {
        openSelectRegion: !this.openSelectRegion
      })

      // 设置区域选择数据
      let address = this.address
      if (
        address.province_id > 0 &&
        address.city_id > 0 &&
        address.district_id > 0
      ) {
        let selectRegionList = this.selectRegionList
        selectRegionList[0].id = address.province_id
        selectRegionList[0].name = address.province_name
        selectRegionList[0].parent_id = 1

        selectRegionList[1].id = address.city_id
        selectRegionList[1].name = address.city_name
        selectRegionList[1].parent_id = address.province_id

        selectRegionList[2].id = address.district_id
        selectRegionList[2].name = address.district_name
        selectRegionList[2].parent_id = address.city_id

        Object.assign(this.$data, {
          selectRegionList: selectRegionList,
          regionType: 3
        })

        this.getRegionList(address.city_id)
      } else {
        Object.assign(this.$data, {
          selectRegionList: [
            { id: 0, name: '省份', parent_id: 1, type: 1 },
            { id: 0, name: '城市', parent_id: 1, type: 2 },
            { id: 0, name: '区县', parent_id: 1, type: 3 }
          ],
          regionType: 1
        })
        this.getRegionList(1)
      }

      this.setRegionDoneStatus()
    },

    selectRegionType (regionTypeIndex) {
      let that = this
      let selectRegionList = that.selectRegionList

      // 判断是否可点击
      if (
        regionTypeIndex + 1 === this.regionType ||
        (regionTypeIndex - 1 >= 0 &&
          selectRegionList[regionTypeIndex - 1].id <= 0)
      ) {
        return false
      }

      Object.assign(this.$data, {
        regionType: regionTypeIndex + 1
      })

      let selectRegionItem = selectRegionList[regionTypeIndex]

      this.getRegionList(selectRegionItem.parent_id)

      this.setRegionDoneStatus()
    },
    selectRegion (regionIndex) {
      let that = this
      let regionItem = this.regionList[regionIndex]
      let regionType = regionItem.type
      let selectRegionList = this.selectRegionList
      selectRegionList[regionType - 1] = regionItem

      if (regionType !== 3) {
        Object.assign(this.$data, {
          selectRegionList: selectRegionList,
          regionType: regionType + 1
        })
        this.getRegionList(regionItem.id)
      } else {
        Object.assign(this.$data, {
          selectRegionList: selectRegionList
        })
      }

      // 重置下级区域为空
      selectRegionList.map((item, index) => {
        if (index > regionType - 1) {
          item.id = 0
          item.name = index === 1 ? '城市' : '区县'
          item.parent_id = 0
        }
        return item
      })

      Object.assign(this.$data, {
        selectRegionList: selectRegionList
      })

      Object.assign(that.$data, {
        regionList: that.regionList.map(item => {
          // 标记已选择的
          if (
            that.regionType === item.type &&
            that.selectRegionList[that.regionType - 1].id === item.id
          ) {
            item.selected = true
          } else {
            item.selected = false
          }

          return item
        })
      })

      this.setRegionDoneStatus()
    },
    doneSelectRegion () {
      if (this.selectRegionDone === false) {
        return false
      }

      let address = this.address
      let selectRegionList = this.selectRegionList
      address.province_id = selectRegionList[0].id
      address.city_id = selectRegionList[1].id
      address.district_id = selectRegionList[2].id
      address.province_name = selectRegionList[0].name
      address.city_name = selectRegionList[1].name
      address.district_name = selectRegionList[2].name
      address.full_region = selectRegionList
        .map(item => {
          return item.name
        })
        .join('')

      Object.assign(this.$data, {
        address: address,
        openSelectRegion: false
      })
    },
    cancelSelectRegion () {
      Object.assign(this.$data, {
        openSelectRegion: false,
        regionType: this.regionDoneStatus ? 3 : 1
      })
    },
    getRegionList (regionId) {
      let that = this
      let regionType = that.regionType
      util.request(api.RegionList, { parentId: regionId }).then(function (res) {
        if (res.errno === 0) {
          Object.assign(that.$data, {
            regionList: res.data.map(item => {
              // 标记已选择的
              if (
                regionType === item.type &&
                that.selectRegionList[regionType - 1].id === item.id
              ) {
                item.selected = true
              } else {
                item.selected = false
              }

              return item
            })
          })
        }
      })
    },
    cancelAddress () {
      wx.navigateTo({
        url: '/pages/ucenter/address'
      })
    },
    saveAddress () {
      console.log(this.address)
      let address = this.address

      if (address.name === '') {
        util.showErrorToast('请输入姓名')

        return false
      }

      if (address.mobile === '') {
        util.showErrorToast('请输入手机号码')
        return false
      }

      if (address.district_id === 0) {
        util.showErrorToast('请输入省市区')
        return false
      }

      if (address.address === '') {
        util.showErrorToast('请输入详细地址')
        return false
      }

      util
        .request(
          api.AddressSave,
          {
            id: address.id,
            name: address.name,
            mobile: address.mobile,
            province_id: address.province_id,
            city_id: address.city_id,
            district_id: address.district_id,
            address: address.address,
            is_default: address.is_default
          },
          'POST'
        )
        .then(function (res) {
          if (res.errno === 0) {
            wx.navigateTo({
              url: '/pages/ucenter/address'
            })
          }
        })
    }
  },

  components: {}
}
</script>

<style lang="stylus" scoped>
page{
    height: 100%;
    background: #f4f4f4;
}
.add-address .add-form{
    background: #fff;
    width: 100%;
    height: auto;
    overflow: hidden;
}

.add-address .form-item{
    height: 116rpx;
    padding-left: 31.25rpx;
    border-bottom: 1px solid #d9d9d9;
    display: flex;
    align-items: center;
    padding-right: 31.25rpx;
}

.add-address .input{
    flex: 1;
    height: 44rpx;
    line-height: 44rpx;
    overflow: hidden;
}

.add-address .form-default{
    border-bottom: 1px solid #d9d9d9;
    height: 96rpx;
    background: #fafafa;
    padding-top: 28rpx;
    font-size: 28rpx;
}

.default-input{
    margin: 0 auto;
    display: block;
    width: 240rpx;
    height: 40rpx;
    padding-left: 50rpx;
    line-height: 40rpx;
    background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/sprites/checkbox-sed825af9d3-a6b8540d42.png) 1rpx -448rpx no-repeat;
    background-size: 38rpx 486rpx;
    font-size: 28rpx;
}

.default-input.selected{
    background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/sprites/checkbox-sed825af9d3-a6b8540d42.png) 0 -192rpx no-repeat;
    background-size: 38rpx 486rpx;
}

.add-address .btns{
    position: fixed;
    bottom: 0;
    left: 0;
    overflow: hidden;
    display: flex;
    height: 100rpx;
    width: 100%;
}

.add-address .cannel,.add-address .save{
    flex: 1;
    height: 100rpx;
    text-align: center;
    line-height: 100rpx;
    font-size: 28rpx;
    color: #fff;
    border:none;
    border-radius: 0;
}

.add-address .cannel{
    background: #333;
}

.add-address .save{
    background: #b4282d;
}


.region-select{
  width: 100%;
  height: 600rpx;
  background: #fff;
  position: fixed;
  z-index: 10;
  left:0;
  bottom: 0;
}

.region-select .hd{
  height: 108rpx;
  width: 100%;
  border-bottom: 1px solid #f4f4f4;
  padding: 46rpx 30rpx 0 30rpx;
}

.region-select .region-selected{
  float: left;
  height: 60rpx;
  display: flex;
}

.region-select .region-selected .item{
  max-width: 140rpx;
  margin-right: 30rpx;
  text-align: left;
  line-height: 60rpx;
  height: 100%;
  color: #333;
  font-size: 28rpx;
  overflow: hidden;
      text-overflow: ellipsis;
    white-space: nowrap;
}

.region-select .region-selected .item.disabled{
  color: #999;
}

.region-select .region-selected .item.selected{
  color: #b4282d;
}

.region-select .done{
  float: right;
  height: 60rpx;
  width: 60rpx;
  border: none;
  background: #fff;
  line-height: 60rpx;
  text-align: center;
  color: #333;
  font-size: 28rpx;
}

.region-select .done.disabled{
  color: #999;
}



.region-select .bd{
  height: 492rpx;
  width: 100%;
  padding: 0 30rpx;
}

.region-select .region-list{
  height: auto;
  overflow: scroll;

}

.region-select .region-list .item{
  width: 100%;
  height: 104rpx;
  line-height: 104rpx;
  text-align: left;
  color: #333;
  font-size: 28rpx;
}

.region-select .region-list .item.selected{
  color: #b4282d;
}


.bg-mask{
  height: 100%;
  width: 100%;
  background: rgba(0, 0, 0, 0.4);
  position: fixed;
  top:0;
  left:0;
  z-index: 8;
}

</style>
