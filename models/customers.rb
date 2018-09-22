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

  # should create ticket here to test!
  # then ticket.save
  # then join cust and tickets to get Price
  # subtract price from wallet
  # upadte wallet!
  def buy_ticket()
    sql = "SELECT tickets.* FROM tickets
    INNER JOIN screenings ON screenings.id = tickets.screening_id
    WHERE customer_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    # return price for the sc
    # after whole function runs, then update the customer so the wallet dunds decrease
    self.update()

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
