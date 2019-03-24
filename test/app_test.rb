ENV["RACK_ENV"] = "test"

require 'minitest/autorun'
require 'rack/test'
require 'pry'
require "tilt/erubis"
require "fileutils"

require_relative "../cms.rb"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    FileUtils.mkdir_p(data_path)
  end

  def teardown
    FileUtils.rm_rf(data_path)
  end

  def app
    Sinatra::Application
  end

  def test_index
    get "/"

    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
  end

  def test_about_page
    get "/about.md"

    assert_includes(last_response.body, "Early Concept")
  end

  def test_nonexistant_route
    get "/not_a_file.md"
    redirected_request = get "/"

    assert_includes(redirected_request.body, "not_a_file.md does not exist")
  end

  def test_markup_rendering
    res = get "/about.md"
  end
end