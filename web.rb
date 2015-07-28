require 'sinatra'
require 'sablon'

get '/' do

      template = Sablon.template(File.join("public", "TestExecuteTemplate.docx"))
    
    context = {
      firstname: "FIRSTY"
      }
    
    template.render_to_file File.join("public", "output.docx"), context

    send_file 'TestExecuteTemplate.docx'


     return "Hello, world"
end



