sed -i '' \
	-e 's/that\.data/that/g' \
	-e 's/this\.data/this/g' \
	-e 's/that\.setData(/Object.assign(that.$data, /' \
	-e 's/this\.setData(/Object.assign(this.$data, /' \
	-e 's!//\([^ ]\)!// \1!' \
	-e 's/function(/function (/' \
	-e 's/^\( *\)\([^ (.]\{1,\}\)(/\1\2 (/' \
	-e 's/ == / === /' \
	-e 's/ != / !== /' \
	-e 's/ *;? *$//' \
	-e 's/;$//' \
	-e 's/^\( *\)view\./\1./' \
	-e 's/wx:if/v-if/' \
	-e 's/wx:for/v-for/' \
	-e 's/wx:key/:key/' \
	-e 's/bindtap/@click/g' \
	-e "s/'{{\(.*\)}}'/'\1'/g" \
$1