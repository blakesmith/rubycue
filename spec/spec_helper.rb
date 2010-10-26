require 'rubygems'
require 'rspec'

require File.join(File.dirname(__FILE__), "../lib/rubycue")

def load_cuesheet(cuename)
  File.read(File.join(File.dirname(__FILE__), "fixtures/#{cuename}.cue"))
end
