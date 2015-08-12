require 'sinatra'
require 'sablon'
require 'mongo'
require 'aws-sdk'
require 'json'

post '/jobs' do
    id = params[:id]
    data = params[:data]
    user = params[:user]
    choice = params[:template]
    rubydata = JSON.parse(data)
    
    grant = Struct.new(:name, :status, :source, :anamount, :awardperiod1, :awardperiod2, :anpiamount, :description, :firstname, :lastname, :middlename, :location, :apersonmonths, :cpersonmonths, :spersonmonths, :totamount, :totpiamount, :awardnumber)
    
    if choice == 'DOE'
      template = Sablon.template(File.absolute_path("DOETemplate.docx"))
    else
      keystr = user + '/' + choice
      s3 = Aws::S3::Resource.new(region:'us-west-2', credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']))
      File.open('filename', 'wb') do |file|
        reap = s3.get_object({ bucket:'cpgrantstemplates', key:keystr }, target: "CustomTemplate.docx")
      end
      template = Sablon.template(File.absolute_path("CustomTemplate.docx"))
    end
    
    grantarray = []
    puts rubydata.inspect
    puts rubydata.class
    
    rubydata.each do |rd|
      if rd["apersonmonths"] != ''
        rd['apersonmonths'] =  rd['apersonmonths'] + 'A '
      end
      if rd["cpersonmonths"] != ''
        rd['cpersonmonths'] =  rd['cpersonmonths'] + 'C'
      end
      if rd["spersonmonths"] != ''
        rd['spersonmonths'] =  rd['spersonmonths'] + 'S'
      end
      
      
      if rd["status"] == 'Current'
        rd["status"] = 'C'
      elsif rd["status"] == 'Pending'
        rd["status"] = 'P'
      elsif rd["status"] == 'Submission Planned'
        rd["status"] = 'S'
      elsif rd["status"] == 'Transfer of Support'
        rd["status"] = 'T'
      end
      
      newgrant = grant.new(rd["name"], rd["status"], rd["source"], rd["amount"], rd["awardperiod1"], rd["awardperiod2"], rd["piamount"], rd["description"], rd["firstname"], rd["lastname"], rd["middlename"], rd["location"], rd["apersonmonths"], rd["cpersonmonths"], rd["spersonmonths"], rd["totamount"], rd["totpiamount"], rd["awardnumber"])
      grantarray.push(newgrant)
    end
    
    context = {
      grants: grantarray
    }
    
    template.render_to_file File.absolute_path("output.docx"), context    
    
    s3 = Aws::S3::Resource.new(region:'us-west-2', credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']))
    obj = s3.bucket('cpgrantsdocs').object(id)
    obj.upload_file('output.docx')

     status 200
     body 'DONE'
end



