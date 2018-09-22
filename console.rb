require('pry')
require_relative('./models/films')
require_relative('./models/customers')
require_relative('./models/tickets')
require_relative('./models/screenings')

Film.delete_all()
Customer.delete_all()
Screening.delete_all()
Ticket.delete_all()

film1 = Film.new({'title' => 'Lord of the Rings'})
film1.save()
film2 = Film.new({'title' => 'Pride and Prejudice'})
film2.save()
film3 = Film.new({'title' => 'Casablanca'})
film3.save()
film4 = Film.new({'title' => 'Avatar'})
film4.save()

film4.title = 'Mulholland Drive'
film4.update()

cust1 = Customer.new({'name' => 'Leah', 'wallet' => 30})
cust1.save()
cust2 = Customer.new({'name' => 'Greg', 'wallet' => 50})
cust2.save()
cust3 = Customer.new({'name' => 'Judith', 'wallet' => 56})
cust3.save()
cust4 = Customer.new({'name' => 'Andrew', 'wallet' => 85})
cust4.save()
cust5 = Customer.new({'name' => 'Susan', 'wallet' => 40})
cust5.save()

cust1.wallet = 120
cust1.update()

# cust1.delete()
# film2.delete()

screening1 = Screening.new({'start_time' => '16:45', 'seats' => 50, 'film_id' => film3.id})
screening1.save()
screening2 = Screening.new({'start_time' => '17:50', 'seats' => 80, 'film_id' => film2.id})
screening2.save()
screening3 = Screening.new({'start_time' => '19:00', 'seats' => 150, 'film_id' => film1.id})
screening3.save()
screening4 = Screening.new({'start_time' => '20:15', 'seats' => 80, 'film_id' => film4.id})
screening4.save()

screening1.start_time = '16:30'
screening1.update()

# screening2.delete()

ticket1 = Ticket.new({'customer_id' => cust1.id, 'screening_id' => screening3.id, 'price' => 10})
ticket1.save()
ticket2 = Ticket.new({'customer_id' => cust2.id, 'screening_id' => screening3.id, 'price' => 10})
ticket2.save()
ticket3 = Ticket.new({'customer_id' => cust3.id, 'screening_id' => screening4.id, 'price' => 10})
ticket3.save()
ticket4 = Ticket.new({'customer_id' => cust4.id, 'screening_id' => screening4.id, 'price' => 10})
ticket4.save()
ticket5 = Ticket.new({'customer_id' => cust1.id, 'screening_id' => screening2.id, 'price' => 7})
ticket5.save()
ticket6 = Ticket.new({'customer_id' => cust3.id, 'screening_id' => screening2.id, 'price' => 7})
ticket6.save()
ticket7 = Ticket.new({'customer_id' => cust5.id, 'screening_id' => screening2.id, 'price' => 7})
ticket7.save()
ticket8 = Ticket.new({'customer_id' => cust4.id, 'screening_id' => screening1.id, 'price' => 7})
ticket8.save()

ticket8.price = 6
ticket8.update

# ticket7.delete()


binding.pry
nil
