require 'yaml'
require 'ldap'

class ActiveDirectory
  def self.config
    @config || YAML::load_file("config.yml")
  end
  
  Person = Struct.new(:name, :last_name, :title, :building, :phone, :email)
	
	def self.list
    email = config['default_login'] + "@" + config['domain']
		connection = LDAP::Conn.new(config['host'], config['port'])
		connection.set_option(LDAP::LDAP_OPT_PROTOCOL_VERSION, 3)
    connection.bind(email, config['default_password'])
    results = []
		connection.search(config['dn'], LDAP::LDAP_SCOPE_SUBTREE, "company=#{config['company']}") do |ad_user|
		  results << Person.new(ad_user['cn'], ad_user['sn'], ad_user['title'], ad_user['physicalDeliveryOfficeName'], 
		                        ad_user['telephoneNumber'], ad_user['mail'])
	  end
	  return results
	end
end