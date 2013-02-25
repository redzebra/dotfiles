require 'rubygems' rescue nil
require 'awesome_print' rescue nil

require 'irb/completion'
require 'irb/ext/history'
require 'irb/ext/save-history'

IRB.conf[:SAVE_HISTORY] = 1000

require 'ap'
require 'pp'
