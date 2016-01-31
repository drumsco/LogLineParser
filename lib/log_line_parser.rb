#!/usr/bin/env ruby

require "log_line_parser/version"
require "strscan"

module LogLineParser
  class Tokenizer

    class << self
      attr_reader :special_token_re, :non_special_token_re

      def tokenize(str)
        @scanner.string = str
        tokens = []
        not_last_token = true
        while not_last_token
          if token = @scanner.scan(@special_token_re)
            tokens.push token
          elsif token = @scanner.scan_until(@non_special_token_re)
            tokens.push token
          else
            not_last_token = false
          end
        end

        tokens.push @scanner.rest unless @scanner.eos?
        tokens
      end

      def compose_special_tokens_str(special_tokens)
        sorted = special_tokens.sort {|x, y| x.length <=> y.length }
        escaped = sorted.map {|token| Regexp.escape(token) }
        escaped.push @space
        escaped.join('|')
      end

      def compose_re(special_tokens)
        tokens_str = compose_special_tokens_str(special_tokens)
        return Regexp.compile(tokens_str), Regexp.compile("(?=#{tokens_str})")
      end
    end

    @special_tokens = %w([ ] - \\ ") #"
    @space = '\s+'
    @scanner = StringScanner.new("")


    @special_token_re, @non_special_token_re = self.compose_re(@special_tokens)
  end
end
