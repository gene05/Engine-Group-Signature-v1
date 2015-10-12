# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Seed trips
trips = [ {'name' => 'Odessa HS - Bill Harden - Band 1'},
  {'name' => 'Odessa HS - Bill Harden - Band 2'},
  {'name' => 'Odessa HS - Bill Harden - Band 3'},
  {'name' => 'Odessa HS - Bill Harden - Band 4'},
  {'name' => 'Odessa HS - Bill Harden - Band 5'},
  {'name' => 'Odessa HS - Bill Harden - Band 6'} ]
trips.each do |trip|
  Signature::Trip.create( name: trip['name'], status: false )
end

# Seed passengers
passengers = [
              {'name' => 'Genesis Gonzalez', 'email' => 'genesisgonza05@gmail.com'},
              #{'name' => 'Natali Torres', 'email' => 'genesis@softwarecriollo.com'}
              {'name' => 'Hugo Rincon', 'email' => 'hugo@softwarecriollo.com'},
              {'name' => 'Manuel Weinhold', 'email' => 'manuel@softwarecriollo.com'},
              {'name' => 'Bellatrix Martinez', 'email' => 'bellatrix@softwarecriollo.com'},
              {'name' => 'Ivan Acosta-Rubio', 'email' => 'ivan@softwarecriollo.com'},
              {'name' => 'Daniel Zambrano', 'email' => 'daniel@softwarecriollo.com'}
            ]
passengers.each do |passenger|
  new_passenger = Signature::Passenger.create( name: passenger['name'], email: passenger['email'] )
end

# Seed passengers by trip
all_passenger = Signature::Passenger.all
all_trips = Signature::Trip.all
all_trips.each do |trip|
  all_passenger.each do |passenger|
    Signature::TripsPassenger.create( trip_id: trip.id, passenger_id: passenger.id )
  end
end

# Seed Documents
documents = [ {'title' => 'General Release form', 'content' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc tristique volutpat diam at tempus.'},
  {'title' => 'Extreme activities release form', 'content' => 'Cras blandit magna at metus egestas scelerisque. Cras pellentesque est at turpis pulvinar blandit. Fusce egestas vel mauris eget pellentesque. Nulla at sapien sit amet enim maximus consequat sit amet id erat. Nunc augue magna, consequat ac leo ac, malesuada luctus felis. Etiam sollicitudin vel justo id condimentum. Curabitur vitae dignissim neque, a vestibulum quam. Integer dictum erat ex, blandit dignissim metus pulvinar at. In id erat placerat lorem fringilla pulvinar at eu sem. Maecenas odio neque, scelerisque non mollis vel, sollicitudin et nibh. Nulla mollis suscipit ex, vel rutrum ipsum faucibus ac. Cras tellus arcu, bibendum quis neque sit amet, mollis cursus sem. Morbi quam tellus, mollis ac ultrices ac, sagittis id sapien. Nullam tincidunt tempor sem, in suscipit elit rutrum sed. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec euismod, mi at laoreet gravida, tellus odio varius quam, sit amet condimentum nisi eros ut dolor. Maecenas tempus egestas neque, ut efficitur dui venenatis in. Fusce a nisl orci. Proin quis convallis augue. Phasellus bibendum tellus ac turpis fermentum, eget condimentum tellus bibendum. Nunc pulvinar risus et ante scelerisque feugiat. Suspendisse fringilla enim vel ligula aliquam, iaculis efficitur augue ornare. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Quisque at lacinia felis. Nulla facilisi. Praesent nec ex condimentum, bibendum purus non, elementum ipsum'},
  {'title' => 'Over 50 release form', 'content' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc tristique volutpat diam at tempus.'}]
documents.each do |document|
  Signature::Document.create( title: document['title'], content: document['content'] )
end



