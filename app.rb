require 'mongo'
require 'sinatra'
require_relative 'env'

db_client = Mongo::Client.new(MONGO_DB_URI)
build_numbers_collection = db_client[:build_numbers]

on_start do
  puts 'Create app_id index'
  build_numbers_collection.indexes.create_one({ app_id: 1 }, unique: true)
end

post '/:app_id' do 
  app_id = params[:app_id]
  offset = params[:offset].to_i
  doc = build_numbers_collection.find( :app_id => app_id ).first
  new_build_number = (doc || {:number => 0})[:number] + 1

  build_numbers_collection.update_one(
    { app_id: app_id }, 
    { '$set': { number: new_build_number }}
  ) unless doc == nil

  build_numbers_collection.insert_one(
    { app_id: app_id, number: new_build_number }
  ) unless doc != nil

  "#{new_build_number + offset}"
end


get '/:app_id' do 
  app_id = params[:app_id]
  offset = params[:offset].to_i
  doc = build_numbers_collection.find( :app_id => app_id ).first
  build_number = (doc || {:number => 0})[:number] + offset

  "#{build_number}"
end