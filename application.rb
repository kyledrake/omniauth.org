$:.unshift File.dirname(__FILE__) + '/lib'
ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV']

require 'redis'
require 'openid-redis-store'

if ENV['REDISTOGO_URL']
  uri = URI.parse(ENV["REDISTOGO_URL"])
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  $redis = Redis.new
end

use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET']
  provider :open_id, :store => OpenID::Store::Redis.new($redis, 'openid:')
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end

OMNIAUTH_STRATEGIES = YAML.load_file(File.dirname(__FILE__) + '/providers.yml').inject([]) do |arr, (provider, hash)|
  arr << Hashie::Mash.new(hash.merge(slug: provider))
  arr
end

helpers do
  def htmlize_hash(hash, nested = false)
    output = "<table class='hash'>"
    hash.each_pair do |key, value|
      output << "<tr><th>#{key}</th><td>"
      case value
      when Hash
        if nested
          output << "<span class='object'>Hash</span>"
        else
          output << htmlize_hash(value, true)
        end
      when String
        output << value
      else
        output << "<span class='object'>#{value.class.to_s}</span>"
      end
      output << "</td></tr>"
    end
    output << "</table>"
    output
  end
end

get '/' do
  erb :home
end

get '/auth/failure' do
  @message = params['message']
  erb :failure
end

get '/auth/:provider/callback' do
  @auth = env['omniauth.auth']
  erb :callback
end

get '/stylesheet.css' do
  header 'Content-Type' => 'text/css; charset=utf-8'
  sass :stylesheet
end
