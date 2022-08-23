require 'sinatra'
require 'base64'
require 'pstore'

get '/:url' do
#   "Your entered URL is #{params[:url]}"
  redirect "https://" + ShortURL.read(params[:url])
end

get '/' do
  'Enter your url using a Curl POST request'
end

post '/' do
  url = generate_short_url(params[:url])
  "Your shortened url is: #{url} \n"
end

def generate_short_url(original)
  ShortURL.save('localhost:4567/' + Base64.encode64(original)[0..6], original)
  
  'localhost:4567/' + Base64.encode64(original)[0..6]
end

class ShortURL
  def self.save(encoded, original)
    store.transaction { store[encoded] = original }
  end

  def self.read(encoded)
    store.transaction { store[encoded] }
  end

  def self.store
    # use less shortened_urls to check the database
    @store ||= PStore.new('shortened_urls.db')
  end
end
