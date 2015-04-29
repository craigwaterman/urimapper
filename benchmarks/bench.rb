#!/usr/bin/env ruby
require 'benchmark'
require_relative '../lib/urimapper'

urls = IO.read("samples.txt").split("\n")

b = Benchmark.measure { 
  urls.each { |u|
    UriMapper.parse(u) rescue nil
  }
}

puts "#{Time.now}\t#{UriMapper::VERSION}\t#{b}"


