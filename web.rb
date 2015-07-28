require 'sinatra'
require 'sablon'

get '/' do

      template = Sablon.template(File.expand_path("TestExecuteTemplate.docx"))
    
    context = {
      firstname: "FIRSTY"
      }
    
    template.render_to_file File.expand_path("output.docx"), context
    
     return "Hello, world"
end



