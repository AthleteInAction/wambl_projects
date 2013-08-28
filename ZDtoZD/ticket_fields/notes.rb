require '/PROJECTS/ACLASSES/gentools'
require '/PROJECTS/ACLASSES/new_API'

Source = ZendeskAPI::Connect.new(
  domain: '',
  username: '',
  password: ''
)

# Copy Fields
fields = {
  a: 'SOURCE field has same name as TARGET field'
}