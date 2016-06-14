# -*- encoding: utf-8 -*-

require 'terminal-table-unicode'
require 'term/ansicolor'
require_relative './query'

module Train
    module TimeUtils
        def format_time(time)
            m,s = time.split ':'
            %Q[#{"#{m}小时" unless m == '00'}#{s}分钟]
        end
    end
    class TerminalTable
        include Term::ANSIColor
        include TimeUtils
        attr_reader :table

        @@head = %w[车次 车站 时间 历时 商务 一等 二等 软卧 硬卧 软座 硬座 无座]
        def initialize(options,from,to,date = nil)
            datas =  Query[from,to,date]
            datas.select! { |data| options.include? data[:station_train_code][0] } unless options.empty?

            datas.map! do |data|
                [data[:station_train_code],
                "#{red(data[:start_station_name])}\n#{data[:day_difference]=='0' ? green(data[:end_station_name]) : yellow(data[:end_station_name])}",
                "#{red(data[:start_time])}\n#{data[:day_difference]=='0' ? green(data[:arrive_time]): yellow(data[:arrive_time])}",
                format_time(data[:lishi]),
                data[:swz_num], data[:zy_num],data[:ze_num],data[:rw_num], data[:yw_num],data[:rz_num], data[:yz_num],data[:wz_num]]
            end
            @table = Terminal::Table.new do |t|
                unless datas.any?
                    t << ['未找到相关信息']
                else
                    t.add_row @@head
                    t.add_separator
                    datas.each { |row| t.add_row row }
                end
            end
        end

        def to_s
            @table.to_s
        end
    end
end
