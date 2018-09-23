require_relative('../db/sql_runner')
require_relative('../models/tickets')

class Customer
  attr_reader :id
  attr_accessor :name, :wallet

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @wallet = options['wallet'].to_i
  end

  def save()
    sql = "INSERT INTO customers (name, wallet)
    VALUES ($1, $2) RETURNING id"
    values = [@name, @wallet]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET (name, wallet) =
    ($1, $2) WHERE id = $3"
    values = [@name, @wallet, @id]
    film = SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    film = SqlRunner.run(sql, values)
  end

#   Show which films a customer has booked to see,
  def films_booked()
    sql = "SELECT films.* FROM films
    INNER JOIN screenings ON screenings.film_id = films.id
    INNER JOIN tickets ON tickets.screening_id = screenings.id
    WHERE customer_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return film_array = result.map {|film_object| Film.new(film_object)}
  end

  def buy_ticket(ticket)
    if self.wallet > ticket.price
      self.wallet = self.wallet - ticket.price
    end
    return self.update()
  end

  # Check how many tickets were bought by a customer
  def how_many_tickets_bought()
    sql = "SELECT tickets.* FROM tickets
    INNER JOIN customers ON tickets.customer_id = customers.id
    WHERE customer_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    ticket_array = result.map {|ticket| Ticket.new(ticket)}
    return ticket_array.length()
  end

  def self.all()
    sql = "SELECT * FROM customers"
    all_customers = SqlRunner.run(sql)
    return all_customers.map {|customer_object| Customer.new(customer_object)}
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end


end
