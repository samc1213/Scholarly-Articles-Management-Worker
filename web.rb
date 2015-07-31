require 'sinatra'
require 'sablon'
require 'mongo'
require 'aws-sdk'

post '/jobs' do
    id = params[:id]
    data = params[:data]
    rubydata = JSON.parse(data)
    
    name = rubydata[0]["name"]
    
    template = Sablon.template(File.absolute_path("TestExecuteTemplate.docx"))
    
    context = {
      firstname: name
      }
    
    template.render_to_file File.absolute_path("output.docx"), context    
    
    s3 = Aws::S3::Resource.new(region:'us-west-2', credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']))
    obj = s3.bucket('cpgrantsdocs').object(id)
    obj.upload_file('output.docx')

     status 200
     body 'DONE'
end



