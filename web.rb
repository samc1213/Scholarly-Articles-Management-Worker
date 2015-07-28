require 'sinatra'
require 'sablon'

get '/' do

      template = Sablon.template(File.absolute_path("TestExecuteTemplate.docx"))
    
    context = {
      firstname: "FIRSTY"
      }
    
    template.render_to_file File.absolute_path("output.docx"), context

    send_file "output.docx"


     return "Hello, world"
end



