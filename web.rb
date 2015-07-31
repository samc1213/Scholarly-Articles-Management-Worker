require 'sinatra'
require 'sablon'
require 'mongo'
require 'aws-sdk'
require 'json'

post '/jobs' do
    id = params[:id]
    data = params[:data]
    rubydata = JSON.parse(data)
    
    grant = Struct.new(:name, :status, :source, :amount, :awardperiod1, :awardperiod2, :piamount, :specify, :description)
    
    template = Sablon.template(File.absolute_path("Template.docx"))
    
    grantarray = []
    puts rubydata.inspect
    puts rubydata.class
    
    # each rubydata do |rd|
      # newgrant = grant.new(rd["name"], rd["status"], rd["source"], rd["amount"], rd["awardperiod1"], rd["awardperiod2"], rd["piamount"], rd["specify"], rd["description"])
      # grantarray.push(newgrant)
    # end
#     
#     
#     
    # context = {
      # grants: grantarray
    # }
#     
    # template.render_to_file File.absolute_path("output.docx"), context    
#     
    # s3 = Aws::S3::Resource.new(region:'us-west-2', credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']))
    # obj = s3.bucket('cpgrantsdocs').object(id)
    # obj.upload_file('output.docx')

     status 200
     body 'DONE'
end



