#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'open-uri'
require 'openssl'

begin
  open('https://kyfw.12306.cn/otn/resources/js/framework/station_name.js',{ssl_verify_mode:OpenSSL::SSL::VERIFY_NONE}) do |f|
    datas = f.read.match(/'(.+)'/)[1].split('|')
    out = ''
    i = 0
    loop do
      s = 5*i+1
      i+=1
      if s>=datas.length
        break
      end
      out << "#{datas[s]} #{datas[s+1]}\n"
    end
    open('./stations.dat','w:UTF-8') do |w|
      w.write(out)
      puts "更新完成"
    end
  end
rescue =>e
  puts "更新错误:#{e.message}"
end
