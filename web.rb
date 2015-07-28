require 'sinatra'
require 'sablon'

get '/' do

      template = Sablon.template(File.join("public", "TestExecuteTemplate.docx"))
    
    context = {
      firstname: "FIRSTY"
      }
    
    template.render_to_file File.join("public", "output.docx"), context

    get '/:TestExecuteTemplate.docx' do |file|
      file = File.join('/public', file)
      send_file(file, :disposition => 'attachment', :filename => File.basename(file))
    end


     return "Hello, world"
end



