require 'rubygems'
require 'sinatra'
require 'haml'
require 'active_directory'

get '/' do
  @people = ActiveDirectory.list.sort_by {|p| p.last_name.to_s}
  haml :index
end

__END__

@@ layout
%html
  = yield

@@ index
%ul 
  = @people.each do |person|
    %li
      %h1= person.name
      %h3= person.title
      %p= person.building
      %p= person.phone
      %p
      %a{:href => "mailto:#{person.email}"}
        =person.email