#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'optparse'
require_relative './table'

module Train
  def self.doc
    <<-DOC.gsub(/^\s+\|?/, '')
    Train tickets query via cli.
    Usage:
    #{__FILE__} [options] [update] <from> <to> [<date>]
    Arguments:
    update           更新数据
    from             出发站
    to               到达站
    date             查询日期<YYYY-MM-DD>,默认当日
    Options: #{yield}
    DOC
  end


  options = ''

  parser = OptionParser.new do |opts|
    opts.banner = ''
    opts.on('-h','--help','显示帮助菜单'){ puts doc(&opts.public_method(:help)) }
    opts.on('-d','动车'){ options << 'D' }
    opts.on('-g','高铁'){ options << 'G' }
    opts.on('-k','快速'){ options << 'K' }
    opts.on('-t','特快'){ options << 'T' }
    opts.on('-z','直达'){ options << 'Z' }
  end
  unless ARGV.any?
    parser.parse(['-h'])
  else
    parser.parse!
    if ARGV.length < 2
      if ARGV[0] == 'update'
        load './update.rb'
      else
        puts "至少需要2个参数，仅输入了#{ARGV.length}个"
      end
    else
      if /^linux/i =~ RbConfig::CONFIG['host_os']
        ARGV.map! do |i|
          i.encoding == Encoding::ASCII_8BIT ? i.dup.force_encoding('utf-8') : i
        end
      else
        ARGV.map! do |i|
          i.dup.encode! 'utf-8'
        end
      end
      puts TerminalTable.new(options,*ARGV)
    end
  end
end
