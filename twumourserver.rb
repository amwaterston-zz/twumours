require 'rubygems'
require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "postgres://localhost/rumours")

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

DataMapper.finalize
DataMapper.auto_upgrade!

#utf-8 outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

get '/' do
  @title = "Rumour Mill"
  erb :welcome
end

get '/list/:type' do
  @type = params[:type]
  @title = "List #{@type}"
  case @type
  when "template"
    @list = Template.all()
  when "subject"
    @list = Subject.all()
  when "celebrity"
    @list = Celebrity.all()
  end
  erb :list
end

get '/new/:type' do
  @type = params[:type]
  @title = "Create a new #{@type}"
  erb :new
end

post '/create/:type' do
  @type = params[:type]
  case @type
  when "template"
    @item = Template.new(params[:template])
  when "subject"
    @item = Subject.new(params[:subject])
  when "celebrity"
    @item = Celebrity.new(params[:celebrity])
  end

  if @item.save
    redirect "/item/#{@type}/#{@item.id}"
  else
    redirect "/list/#{@type}"
  end
end

get '/item/:type/:id' do
  @type = params[:type]
  case @type
  when "template"
    @item = Template.get(params[:id])
  when "subject"
    @item = Subject.get(params[:id])
  when "celebrity"
    @item = Celebrity.get(params[:id])
  end

  if @item
    erb :item
  else
    redirect("/list/#{@type}")
  end
end

get '/delete/:type/:id' do
  @type = params[:type]
  case @type
  when "template"
    item = Template.get(params[:id])
  when "subject"
    item = Subject.get(params[:id])
  when "celebrity"
    item = Celebrity.get(params[:id])
  end
  unless item.nil?
    item.destroy
  end
  redirect("/list/#{@type}")
end
