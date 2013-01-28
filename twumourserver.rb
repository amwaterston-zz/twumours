require 'rubygems'
require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/rumours.db")

class Template
  include DataMapper::Resource
  
  property :id, Serial
  property :text, String
end

class Subject
  include DataMapper::Resource
  
  property :id, Serial
  property :text, String
end

class Celebrity
  include DataMapper::Resource
  
  property :id, Serial
  property :text, String
end

DataMapper.auto_upgrade!

#utf-8 outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

get '/' do
  @title = "Rumour Mill"
  erb :welcome
end

get '/templates' do
  @title = "List templates"
  @templates = Template.all()
  erb :templates
end

get '/newtemplate' do
  @title = "Create a new rumour template"
  erb :newtemplate
end

post '/createtemplate' do
  @template = Template.new(params[:template])
  if @template.save
    redirect "/template/#{@template.id}"
  else
    redirect "/templates"
  end
end

get '/template/:id' do
  @template = Template.get(params[:id])
  if @template
    erb :template
  else
    redirect('/templates')
  end
end

get '/deletetemplate/:id' do
  template = Template.get(params[:id])
  unless template.nil?
    template.destroy
  end
  redirect('/templates')
end
