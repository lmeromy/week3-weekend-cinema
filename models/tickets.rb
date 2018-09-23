require_relative('../db/sql_runner')
require_relative('../models/customers')

class Ticket
  attr_reader :id, :customer_id, :screening_id
  attr_accessor :price

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @screening_id = options['screening_id'].to_i
    @price = options['price'].to_i
  end

# if customer has enough $$, then allow ticket creation/save
  def check_funds()
    # join tickets to customers
    sql = "SELECT customers.* FROM customers
    INNER JOIN tickets ON tickets.customer_id = customers.id
    WHERE customers.id = $1"
    values = [@customer_id]
    result = SqlRunner.run(sql, values)
    # return sql customer object into array,
    cust = result.map {|customer| Customer.new(customer)}[0]
    # pull value from array, check if wallet > value, return true
    # return cust.wallet
    if cust != nil
      if cust.wallet > self.price  # is.true? cust.wallet > self.price
        return true
      end
    end
  end

  def save()
      # if self.check_funds() != nil #&& self.check_funds() != nil
      # this is the save method if above method returns true i.e. if
      # customer has enough money in wallet to buy ticket
      sql = "INSERT INTO tickets (customer_id, screening_id, price)
      VALUES ($1, $2, $3) RETURNING id"
      values = [@customer_id, @screening_id, @price]
      customer = SqlRunner.run(sql, values).first
      @id = customer['id'].to_i
    # else
    #   return "Insufficient funds"
     # end
  end

  def update()
    sql = "UPDATE tickets SET (customer_id, screening_id, price) =
    ($1, $2, $3) WHERE id = $4"
    values = [@customer_id, @screening_id, @price, @id]
    film = SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    film = SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    all_tickets = SqlRunner.run(sql)
    return all_tickets.map {|ticket_object| Ticket.new(ticket_object)}
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end


end
