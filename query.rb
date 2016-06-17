# -*- coding: utf-8 -*-

require 'http'
require 'openssl'
require 'json/ext'
require 'time'

module Train
    # or OpenStruct?
    class Train < Struct.new(:train_no,:station_train_code,:start_station_telecode,:start_station_name,:end_station_telecode,:end_station_name,:from_station_telecode,:from_station_name,:to_station_telecode,:to_station_name,:start_time,:arrive_time,:day_difference,:train_class_name,:lishi,:canWebBuy,:lishiValue,:yp_info,:control_train_day,:start_train_date,:seat_feature,:yp_ex,:train_seat_feature,:seat_types,:location_code,:from_station_no,:to_station_no,:control_day,:sale_time,:is_support_card,:note,:controlled_train_flag,:controlled_train_message,:gg_num,:gr_num,:qt_num,:rw_num,:rz_num,:tz_num,:wz_num,:yb_num,:yw_num,:yz_num,:ze_num,:zy_num,:swz_num)
        def initialize(data)
            data.each { |k,v| self[k]=v }
        end
        def []=(name,value)
            self.public_send("#{name}=",value) if self.respond_to? name
        end

        def [](name)
            self.public_send(name)
        end
    end

    class Query
        @@ctx = OpenSSL::SSL::SSLContext.new
        @@ctx.set_params(:verify_mode=>OpenSSL::SSL::VERIFY_NONE)
        @@dict = {}

        def initialize(from, to, date = nil)
            @purpose = 'ADULT'.freeze
            @date = begin
                        Time.parse(date)
                    rescue
                        Time.now
                    end.strftime('%Y-%m-%d')
            @from,@to = [from,to].map {|x| /^[A-Z]+$/ =~ x ? x : Query.trans(x) }
        end

        def self.trans(key)
            # name-> code mapper
            unless @@dict.any?
                File.open('./stations.dat','r:UTF-8') do |f|
                    f.each_line do |line|
                        k,v = line.split unless line.empty?
                        @@dict[k] = v
                    end
                end
            end
            key.is_a?(Symbol) ? @@dict[key.id2name] : @@dict[key] or key
        end

        def self.[](from, to, date = nil)
            # constructor
            Query.new(from, to, date).call
        end

        def call
            return [] if @from.nil? || @to.nil?
            res = HTTP.get('https://kyfw.12306.cn/otn/lcxxcx/query'.freeze, :params => {:purpose_codes=>@purpose, :queryDate=>@date, :from_station=>@from, :to_station=>@to }, :ssl_context=>@@ctx)
            return [] unless res.code == 200
            begin
                (JSON.parse(res.body,:symbolize_names=>true)[:data][:datas] or []).map { |data| Train.new data }
            rescue
                []
            end
        end
    end
end
