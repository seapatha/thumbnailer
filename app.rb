require_relative 'bundle/bundler/setup'
require 'sinatra'
require 'sinatra/json'
require 'rmagick'
require 'base64'

port = ENV['PORT'] || 80
puts "STARTING SINATRA on port #{port}"
set :port, port
set :bind, '0.0.0.0'

def parse_filename(filename)
  mime_types = {
    'PNG' => 'image/png',
    'JPG' => 'image/jpeg',
    'GIF' => 'image/gif'
  }

  args = filename.split('_')
  out = Hash.new
  out['dim'] = args[1].upcase
  out['x'] = out['dim'].split('x')[0].to_i
  out['y'] = out['dim'].split('x')[1].to_i
  out['format'] = filename.split('.')[1].upcase
  out['content_type'] = mime_types[out['format']]
  return out
end

def thumbnailer(args, url)
  image = Magick::Image.read(url).first 
  image.format = args['format']
  image.resize_to_fit!(args['x'], args['y'])
  content_type args['content_type']
  image.to_blob
end

get '/t/:url/:filename' do
  args = parse_filename(params[:filename])
  url = Base64.decode64(params[:url])
  thumbnailer(args, url)
end
