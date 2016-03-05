require 'bundler/setup'
require 'test/unit'
require 'pot_markdown'
require 'active_support'
require 'active_support/core_ext'
require 'diffy'

def read_file(filename)
  File.read(File.expand_path("../files/#{filename}", __FILE__))
end
