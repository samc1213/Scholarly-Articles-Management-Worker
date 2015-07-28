require 'sinatra'
require 'sablon'

get '/' do
  "Hello, world"
      template = Sablon.template(File.expand_path("TestExecuteTemplate.docx"))
    
    context = {
      firstname: "FIRSTY"
      }
    
    template.render_to_file File.expand_path("output.docx"), context
end



