<script>
export default {
}
</script>

<style>
/**app.wxss**/
.container {
  box-sizing: border-box;
  background-color: #f4f4f4;
  font-family: PingFangSC-Light,helvetica,'Heiti SC';
} 

view,image,text,navigator{
  box-sizing: border-box;
  padding:0;
  margin:0;

}

view,text{
  font-family: PingFangSC-Light,helvetica,'Heiti SC';
  font-size: 29rpx;
  color: #333;
}

@import url("~mpvue-wxparse/src/wxParse.css");
/* 去掉 .p 的 margin */
.wxParse .p {
  margin: 0;
}
/* FIXME .p text 有一些空白空隙 */
.wxParse text {
  display: none;
}
/* 去掉 .p image 之间高度差 */
.wxParse .img {
  display: block;
}
</style>
