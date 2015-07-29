require 'sinatra'
require 'sablon'
require 'mongo'
require 'aws-sdk'

get '/' do
    mongo_uri = "mongodb://heroku_v7w2qftd:a5h7slci8p0b2p9nt7qe96hmvv@ds027483.mongolab.com:27483/heroku_v7w2qftd"
    db = Mongo::Client.new(mongo_uri).db('heroku_v7w2qftd')
    db[:queue].insert_one({message: 'whatsgoodmofoszzzzz'})


    template = Sablon.template(File.absolute_path("TestExecuteTemplate.docx"))
    
    context = {
      firstname: "FIRSTY"
      }
    
    template.render_to_file File.absolute_path("output.docx"), context
       
    
    doc = File.open("output.docx")
    AWS.config(access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
           secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
    s3 = Aws::S3::Resource.new(region:'us-west-2')
    obj = s3.bucket('cpgrantsdocs').object('docdoc')
    obj.upload_file('output.docx')

    
    send_file "output.docx"

     # return "Hello, world"
end



