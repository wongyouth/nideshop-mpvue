<template lang="pug">
.query
  scroll-view.container(style='height: 100%;')
    .search-header
      .input-box
        image.icon(src='http://nos.netease.com/mailpub/hxm/yanxuan-wap/p/20150730/style/img/icon-normal/search2-2fb94833aa.png')
        input.keyword(name='input' :focus='true' :value='keyword' confirm-type='search' @input='inputChange' @focus='inputFocus' @confirm='onKeywordConfirm' :placeholder='defaultKeyword.keyword')
        image.del(v-if='keyword' @click='clearKeyword' src='http://nos.netease.com/mailpub/hxm/yanxuan-wap/p/20150730/style/img/icon-normal/clearIpt-f71b83e3c2.png')
      .right(@click='closeSearch') 取消
    .no-search(v-if='!searchStatus')
      .serach-keywords.search-history(v-if='!keyword && historyKeyword.length')
        .h
          text.title 历史记录
          image.icon(@click='clearHistory' src='http://nos.netease.com/mailpub/hxm/yanxuan-wap/p/20150730/style/img/icon-normal/del1-93f0a4add4.png')
        .b
          .item(@click='onKeywordTap(item)' v-for='item in historyKeyword' :key='item' hover-class='navigator-hover') {{item}}
      .serach-keywords.search-hot(v-if='!keyword')
        .h
          text.title 热门搜索
        .b
          .item(class="item.is_hot === 1 ? 'active' : ''" hover-class='navigator-hover' @click='onKeywordTap(item.keyword)' v-for='item in hotKeyword' :key='item') {{item.keyword}}
      .shelper-list(v-if='keyword')
        .item(hover-class='navigator-hover' v-for='item in helpKeyword' :key='item' @click='onKeywordTap(item.keyword)') {{item}}
    .search-result(v-if='searchStatus && goodsList.length')
      .sort
        .sort-box
          #defaultSort.item(:class="currentSortType == 'default' ? 'active' : ''" @click='openSortFilter')
            text.txt 综合
          #priceSort.item.by-price(:class="[currentSortType == 'price' ? 'active' : '', currentSortOrder == 'asc' ? 'asc' : 'desc']" @click='openSortFilter')
            text.txt 价格
          #categoryFilter.item(:class="currentSortType == 'category' ? 'active' : ''" @click='openSortFilter')
            text.txt 分类
        .sort-box-category(v-if='categoryFilter')
          .item(:class="item.checked ? 'active' : ''" v-for='(item,index) in filterCategory' :key='item.id' @click='selectCategory(index)') {{item.name}}
      .cate-item
        .b
          a.item(:class="(index + 1) % 2 == 0 ? 'item-b' : ''" :href="'/pages/goods/goods?id=' + item.id" v-for='(item,index) in goodsList' :key='item.id')
            image.img(:src='item.list_pic_url' background-size='cover')
            text.name {{item.name}}
            text.price ￥{{item.retail_price}}
    .search-result-empty(v-if='!goodsList.length && searchStatus')
      image.icon(src='http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/icon-normal/noSearchResult-7572a94f32.png')
      text.text 您寻找的商品还未上架

</template>

<script>
import util from '../../utils/util'
import api from '../../utils/api'

export default {
  data () {
    return {
      keyword: '',
      searchStatus: false,
      goodsList: [],
      helpKeyword: [],
      historyKeyword: [],
      categoryFilter: false,
      filterCategory: [],
      defaultKeyword: {},
      hotKeyword: [],
      page: 1,
      size: 20,
      currentSortType: 'id',
      currentSortOrder: 'desc',
      categoryId: 0
    }
  },

  props: {},

  computed: {},

  mounted () {
    this.getSearchKeyword()
  },

  methods: {
    closeSearch: function () {
      wx.navigateBack()
    },
    clearKeyword: function () {
      Object.assign(this.$data, {
        keyword: '',
        searchStatus: false
      })
    },
    getSearchKeyword () {
      let that = this
      util.request(api.SearchIndex).then(function (res) {
        if (res.errno === 0) {
          Object.assign(that.$data, {
            historyKeyword: res.data.historyKeywordList,
            defaultKeyword: res.data.defaultKeyword,
            hotKeyword: res.data.hotKeywordList
          })
        }
      })
    },

    inputChange: function (e) {
      Object.assign(this.$data, {
        keyword: e.target.value,
        searchStatus: false
      })
      this.getHelpKeyword()
    },

    getHelpKeyword: function () {
      let that = this
      util.request(api.SearchHelper, { keyword: that.keyword }).then(function (res) {
        if (res.errno === 0) {
          Object.assign(that.$data, {
            helpKeyword: res.data
          })
        }
      })
    },
    inputFocus: function () {
      Object.assign(this.$data, {
        searchStatus: false,
        goodsList: []
      })

      if (this.keyword) {
        this.getHelpKeyword()
      }
    },
    clearHistory: function () {
      Object.assign(this.$data, {
        historyKeyword: []
      })

      util.request(api.SearchClearHistory, {}, 'POST')
        .then(function (res) {
          console.log('清除成功')
        })
    },
    getGoodsList: function () {
      let that = this
      util.request(api.GoodsList, { keyword: that.keyword, page: that.page, size: that.size, sort: that.currentSortType, order: that.currentSortOrder, categoryId: that.categoryId }).then(function (res) {
        if (res.errno === 0) {
          Object.assign(that.$data, {
            searchStatus: true,
            categoryFilter: false,
            goodsList: res.data.data,
            filterCategory: res.data.filterCategory,
            page: res.data.currentPage,
            size: res.data.numsPerPage
          })
        }

        // 重新获取关键词
        that.getSearchKeyword()
      })
    },
    onKeywordTap: function (keyword) {
      this.getSearchResult(keyword)
    },
    getSearchResult (keyword) {
      Object.assign(this.$data, {
        keyword,
        page: 1,
        categoryId: 0,
        goodsList: []
      })

      this.getGoodsList()
    },
    openSortFilter: function (event) {
      let currentId = event.currentTarget.id
      switch (currentId) {
        case 'categoryFilter':
          Object.assign(this.$data, {
            categoryFilter: !this.categoryFilter,
            currentSortOrder: 'asc'
          })
          break
        case 'priceSort':
          let tmpSortOrder = 'asc'
          if (this.currentSortOrder === 'asc') {
            tmpSortOrder = 'desc'
          }
          Object.assign(this.$data, {
            currentSortType: 'price',
            currentSortOrder: tmpSortOrder,
            categoryFilter: false
          })

          this.getGoodsList()
          break
        default:
          // 综合排序
          Object.assign(this.$data, {
            currentSortType: 'default',
            currentSortOrder: 'desc',
            categoryFilter: false
          })
          this.getGoodsList()
      }

      console.log('categoryFilter', this.categoryFilter)
    },
    selectCategory: function (currentIndex) {
      let filterCategory = this.filterCategory
      let currentCategory = null
      filterCategory.forEach((item, index) => {
        if (index === currentIndex) {
          item.selected = true
          currentCategory = item
        } else {
          item.selected = false
        }
      })
      Object.assign(this.$data, {
        filterCategory: filterCategory,
        categoryFilter: false,
        categoryId: currentCategory.id,
        page: 1,
        goodsList: []
      })
      this.getGoodsList()
    },
    onKeywordConfirm (event) {
      this.getSearchResult(event.target.value)
    }
  },

  components: {}
}
</script>

<style>
page{
  min-height: 100%;
  background-color: #f4f4f4;
}

.container{
  min-height: 100%;
  background-color: #f4f4f4;
}

.search-header{
    position: fixed;
    top: 0;
    width: 750rpx;
    height: 91rpx;
    display: flex;
    background: #fff;
    border-bottom: 1px solid rgba(0,0,0,.15);
    padding: 0 31.25rpx;
    font-size: 29rpx;
    color: #333;
}

.search-header .input-box{
    position: relative;
    margin-top: 16rpx;
    float: left;
    width: 0;
    flex: 1;
    height: 59rpx;
    line-height: 59rpx;
    padding: 0 20rpx;
    background: #f4f4f4;
}

.search-header .icon{
    position: absolute;
    top: 14rpx;
    left: 20rpx;
    width: 31rpx;
    height: 31rpx;
}

.search-header .del{
    position: absolute;
    top: 3rpx;
    right: 10rpx;
    width: 53rpx;
    height: 53rpx;
    z-index: 10;
}

.search-header .keyword{
    position: absolute;
    top: 0;
    left: 40rpx;
    width: 506rpx;
    height: 59rpx;
    padding-left: 30rpx;
}

.search-header .right{
    margin-top: 24rpx;
    margin-left: 31rpx;
    margin-right: 6rpx;
    width: 58rpx;
    height: 43rpx;
    line-height: 43rpx;
    float: right;
}

.no-search{
    height: auto;
    overflow: hidden;
    margin-top: 91rpx;
}

.serach-keywords{
    background: #fff;
    width: 750rpx;
    height: auto;
    overflow: hidden;
    margin-bottom: 20rpx;
}

.serach-keywords .h{
    padding: 0 31.25rpx;
    height: 93rpx;
    line-height: 93rpx;
    width: 100%;
    color: #999;
    font-size: 29rpx;
}

.serach-keywords .title{
    display: block;
    width: 120rpx;
    float: left;
}

.serach-keywords .icon{
    margin-top: 19rpx;
    float: right;
    display: block;
    margin-left: 511rpx;
    height: 55rpx;
    width: 55rpx;
}

.serach-keywords .b{
    width: 750rpx;
    height: auto;
    overflow: hidden;
    padding-left: 31.25rpx;
}

.serach-keywords .item{
    display: inline-block;
    width: auto;
    height: 48rpx;
    line-height: 48rpx;
    padding:0 15rpx;
    border: 1px solid #999;
    margin: 0 31.25rpx 31.25rpx 0;
    font-size: 24rpx;
    color: #333;
}

.serach-keywords .item.active{
    color: #b4282d;
    border: 1px solid #b4282d;
}

.shelper-list{
    width: 750rpx;
    height: auto;
    overflow: hidden;
    background: #fff;
    padding: 0 31.25rpx;
}

.shelper-list .item{
    height: 93rpx;
    width: 687.5rpx;
    line-height: 93rpx;
    font-size: 24rpx;
    color: #333;
    border-bottom: 1px solid #f4f4f4;
}


.sort{
    position: fixed;
    top: 91rpx;
    background: #fff;
    width: 100%;
    height: 78rpx;
}

.sort-box{
    background: #fff;
    width: 100%;
    height: 78rpx;
    overflow: hidden;
    padding: 0 30rpx;
    display: flex;
    border-bottom: 1px solid #d9d9d9;
}

.sort-box .item{
    height: 78rpx;
    line-height: 78rpx;
    text-align: center;
    flex:1;
    color: #333;
    font-size: 30rpx;
}

.sort-box .item .txt{
    display: block;
    width: 100%;
    height: 100%;
    color: #333;
}

.sort-box .item.active .txt{
    color: #b4282d;
}

.sort-box .item.by-price{
    background: url(//yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/icon-normal/no-3127092a69.png) 155rpx center no-repeat;
    background-size: 15rpx 21rpx;
}

.sort-box .item.by-price.active.asc{
    background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/icon-normal/up-636b92c0a5.png) 155rpx center no-repeat;
    background-size: 15rpx 21rpx;
}

.sort-box .item.by-price.active.desc{
    background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/icon-normal/down-95e035f3e5.png) 155rpx center no-repeat;
    background-size: 15rpx 21rpx;
}

.sort-box-category{
    background: #fff;
    width: 100%;
    height: auto;
    overflow: hidden;
    padding: 40rpx 40rpx 0 0;
    border-bottom: 1px solid #d9d9d9;
}

.sort-box-category .item{
    height: 54rpx;
    line-height: 54rpx;
    text-align: center;
    float: left;
    padding: 0 16rpx;
    margin: 0 0 40rpx 40rpx;
    border: 1px solid #666;
    color: #333;
    font-size: 24rpx;
}

.sort-box-category .item.active{
    color: #b4282d;
    border: 1px solid #b4282d;
}

.cate-item{
    margin-top: 175rpx;
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

.cate-item .list-filter{
    height: 80rpx;
    width: 100%;
    background: #fff;
    margin-bottom: 6.25rpx;
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

.search-result-empty{
    width: 100%;
    height: 100%;
    padding-top: 300rpx;
}

.search-result-empty .icon{
    margin: 0 auto;
    display: block;
    width: 240rpx;
    height: 240rpx;
}

.search-result-empty .text{
    display: block;
    width: 100%;
    height: 40rpx;
    font-size: 28rpx;
    text-align: center;
    color: #999;
}
</style>