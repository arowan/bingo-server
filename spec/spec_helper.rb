# spec/spec_helper.rb
require 'rack/test'
require 'rspec'
require 'byebug'

ENV['RACK_ENV'] = 'test'

require File.expand_path('../../base.rb', __FILE__)

module RSpecMixin
  include Rack::Test::Methods
  def app() described_class end
end

# For RSpec 2.x and 3.x
RSpec.configure { |c| c.include RSpecMixin }
