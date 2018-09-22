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

  def check_if_enough_funds()
    # if customer has enough $$, then allow ticket creation/save

    # join tcikets to customers
    # return sql customer object into array,
    # pull value from array, check if wallet > value, return true
    # else return false (which will not allow save method to run)
  end

  def save()
    if self.check_if_enough_funds() == true
      # this is the save method if above method returns true i.e. if
      # customer has enough money in wallet to buy ticket
      sql = "INSERT INTO tickets (customer_id, screening_id, price)
      VALUES ($1, $2, $3) RETURNING id"
      values = [@customer_id, @screening_id, @price]
      customer = SqlRunner.run(sql, values).first
      @id = customer['id'].to_i
    end
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
