$:.unshift File.dirname(__FILE__) + '/lib'
ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV']

require 'identity'

if ENV['MONGOHQ_URL']
  uri = URI.parse(ENV['MONGOHQ_URL'])
  $mongodb = Mongo::Connection.from_uri(ENV['MONGOHQ_URL']).db(uri.path.gsub(/^\//, ''))
else
  $mongodb = Mongo::Connection.new.db('try_omniauth')
end

Mongoid.configure do |config|
  config.master = $mongodb
end

use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  provider :identity
  provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET']
  provider :open_id, :store => OpenidMongodbStore::Store.new($mongodb)
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

[:get, :post].each do |method|
  send(method, '/auth/:provider/callback') do
    @auth = env['omniauth.auth']
    erb :callback
  end
end

get '/stylesheet.css' do
  header 'Content-Type' => 'text/css; charset=utf-8'
  sass :stylesheet
end
