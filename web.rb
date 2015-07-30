require 'sinatra'
require 'sablon'
require 'mongo'
require 'aws-sdk'

post '/jobs' do
    
    id = params[:id]
    mongo_uri = "mongodb://heroku_v7w2qftd:a5h7slci8p0b2p9nt7qe96hmvv@ds027483.mongolab.com:27483/heroku_v7w2qftd"
    db = Mongo::Client.new(mongo_uri, :database => 'heroku_v7w2qftd')
    
    job = db[:messages].find({:_id => BSON::ObjectId(id)}).find_one_and_update('$set' => {done: 'true'})
    
    template = Sablon.template(File.absolute_path("TestExecuteTemplate.docx"))
    
    context = {
      firstname: "FIRSTY"
      }
    
    template.render_to_file File.absolute_path("output.docx"), context
    
    send_file 'output.docx'
end
