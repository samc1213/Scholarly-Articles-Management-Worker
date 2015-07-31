require 'sinatra'
require 'sablon'
require 'mongo'
require 'aws-sdk'
require 'json'

post '/jobs' do
    id = params[:id]
    data = params[:data]
    rubydata = JSON.parse(data)
    
    grant = Struct.new(:name)
    
    template = Sablon.template(File.absolute_path("TestExecuteTemplate.docx"))
    
    context = {
      grants: [grant.new(rubydata[0]["name"]),
              grant.new(rubydata[1]["name"]),
              grant.new(rubydata[2]["name"])]
      }
    
    template.render_to_file File.absolute_path("output.docx"), context    
    
    s3 = Aws::S3::Resource.new(region:'us-west-2', credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']))
    obj = s3.bucket('cpgrantsdocs').object(id)
    obj.upload_file('output.docx')

     status 200
     body 'DONE'
end



