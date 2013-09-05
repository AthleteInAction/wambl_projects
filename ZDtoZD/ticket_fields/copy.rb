require '../../LIBS/gentools'
require '../../LIBS/new_API'
require 'rinothread'


Source = ZendeskAPI::Connect.new(
  domain: 'klsupport',
  username: 'mccabe.tonna@servicerocket.com',
  password: 'shadow'
)
Target = ZendeskAPI::Connect.new(
  domain: 'myphotodynamic1377689073',
  username: 'will@myphotodynamic.com',
  password: 'Lightning22'
)
SystemFields = [
  'subject',      #1
  'description',  #2
  'status',       #3
  'tickettype',   #4
  'priority',     #5
  'group',        #6
  'assignee'      #7
]


# Get TARGET Fields
1.times do
  #break
  target_key = {}
  rino = Rino::Tusk.new 10
  pages = (Target.GetFields(per_page: 1)[:body]['count'].to_f/100).ceil
  pages.times do |page|
    
    page += 1
    
    rino.queue do
      
      call = Target.GetFields(page: page)
      call[:body]['ticket_fields'].each do |field|
        
        target_key = target_key.merge(NW(field['title']) => field)
        JP %{[#{field['type']}] :: #{field['title']}\n}
        
      end
      
    end
    
  end
  rino.execute
  Write 'target.json',target_key.to_json

end


# Get SOURCE Fields
1.times do
  #break
  source_key = {}
  rino = Rino::Tusk.new 10
  pages = (Source.GetFields(per_page: 1)[:body]['count'].to_f/100).ceil
  pages.times do |page|
    
    page += 1
    
    rino.queue do
      
      call = Source.GetFields(page: page)
      call[:body]['ticket_fields'].each do |field|
        
        source_key = source_key.merge(NW(field['title']) => field)
        JP %{[#{field['type']}] :: #{field['title']}\n}
        
      end
      
    end
    
  end
  rino.execute
  Write 'source.json',source_key.to_json

end


duplicates = []
source_key = JSON.parse GetFile('source.json')
target_key = JSON.parse GetFile('target.json')
target_key.each do |key,val|

  if !SystemFields.include? val['type']

    if source_key[key]
      duplicates << val
    end

  end

end
duplicates.each do |field|

  source_type = source_key[NW(field['title'])]['type']
  JP source_type if source_type != field['type']

end