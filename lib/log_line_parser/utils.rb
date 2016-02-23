#!/usr/bin/env ruby

module LogLineParser
  module Utils
    DEFAULT_BOTS = %w(
Googlebot
Googlebot-Mobile
Mediapartners-Google
Bingbot
Slurp
Baiduspider
BaiduImagespider
BaiduMobaider
YetiBot
)

    def self.compile_bots_re(bot_names=DEFAULT_BOTS)
      bots_str = bot_names.map {|name| Regexp.escape(name) }.join("|")
      Regexp.compile(bots_str, Regexp::IGNORECASE)
    end

    DEFAULT_BOTS_RE = compile_bots_re

    def self.access_by_bots?(record, bots_re=DEFAULT_BOTS_RE)
      bots_re =~ record.user_agent
    end

    def open_multiple_output_files(base_names, dir=nil, ext="log")
      logs = {}
      filepath = dir ? File.join(dir, "%s.#{ext}") : "%s.#{ext}"
      base_names.each do |base|
        logs[base] = open(format(filepath, base), "w")
      end
      yield logs
    ensure
      logs.each do |k, v|
        v.close
      end
    end
  end
end
