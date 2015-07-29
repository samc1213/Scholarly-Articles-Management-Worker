require 'sinatra'
require 'sablon'
require 'mongo'
include Mongo

get '/' do
    mongo_uri = "mongodb://heroku_v7w2qftd:a5h7slci8p0b2p9nt7qe96hmvv@ds027483.mongolab.com:27483/heroku_v7w2qftd"
    @db = MongoClient.new(mongo_uri).db('heroku_v7w2qftd')
    @db[:queue].insert_one({message: 'whatsgoodmofos'})


    template = Sablon.template(File.absolute_path("TestExecuteTemplate.docx"))
    
    context = {
      firstname: "FIRSTY"
      }
    
    template.render_to_file File.absolute_path("output.docx"), context
       
    grid = Mongo::Grid.new(db)
    
    doc = File.open("output.docx")
    id2   = @grid.put(doc, :filename => "me.jpg")
    
    return id2
    
    # send_file "output.docx"

     # return "Hello, world"
end



