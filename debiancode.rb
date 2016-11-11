#!/usr/bin/env ruby

require 'open-uri'
require 'pp'
require 'nokogiri'

url = 'https://wiki.debian.org/DebianReleases'
html = open(url).read

doc = Nokogiri::HTML.parse(html)
#spanタグ、tableタグの内容を抽出
tables = doc.xpath( '//span').xpath('//table')
#抽出結果をテキスト化し\n区切りの配列に変換 
tblar = tables.text.split("\n");
flag = 0
cnt = 0
tblar.each do |tb|
  #Release statistics を表示させないためにVersionでフラグ管理
  if tb =~ /Version/
    flag += 1
    next
  end
  if flag == 2
    break
  end

  #バージョン番号を表示させないようにする
  if tb =~ /[0-9]\.[0-9]/ then
    next
  end

  #空文字列ならそのまま表示、それ以外なら文字列内のスペースを排除しtabをつけて表示
  if tb.empty? then
    print tb
  else
    print "#{tb.gsub(/\s/,"")}\t"
    cnt += 1
  end

  #改行のためのカウンタ条件
  if cnt == 3 
    puts ""
    cnt = 0
  end
end
