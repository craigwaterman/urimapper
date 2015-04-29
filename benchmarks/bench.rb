#!/usr/bin/env ruby
require 'benchmark'
require_relative '../lib/urimapper'

urls = IO.read("samples.txt").split("\n")
puts "WHEN: #{Time.now}\tVERSION: #{UriMapper::VERSION}"
Benchmark.bmbm { |x| 
  x.report("parse") { 
    urls.each { |u|
      UriMapper.parse(u) rescue nil
    }
  }
}

puts "\n=======================================================\n\n"



