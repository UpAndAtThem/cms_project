ENV["RACK_ENV"] = "test"

require 'minitest/autorun'
require 'rack/test'
require 'pry'
require "tilt/erubis"

require_relative "../cms.rb"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get "/"

    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
  end

  def test_about_page
    get "/about.txt"
  end
end