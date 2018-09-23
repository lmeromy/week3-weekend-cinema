require_relative('../db/sql_runner')

class Film
  attr_reader :id
  attr_accessor :title

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
  end

  def save()
    sql = "INSERT INTO films (title)
    VALUES ($1) RETURNING id"
    values = [@title]
    film = SqlRunner.run(sql, values).first
    @id = film['id'].to_i
  end

  def update()
    sql = "UPDATE films SET title = $1 WHERE id = $2"
    values = [@title, @id]
    film = SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    film = SqlRunner.run(sql, values)
  end

#show which customers are coming to see one film.
  def customers_attending()
    sql = "SELECT customers.* FROM customers
    INNER JOIN tickets ON tickets.customer_id = customers.id
    INNER JOIN screenings ON tickets.screening_id = screenings.id
    WHERE film_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    customers_array = result.map {|cust_object| Customer.new(cust_object)}
  end

  # Check how many customers are going to watch a certain film
  def number_of_customers()
    result = self.customers_attending
    return result.length()
  end

  # Write a method that finds out what is the most popular time
  # (most tickets sold) for a given film
  # NOT WORKING YET!
  def most_popular_time()
    # join films, screenings, and tickets to get all tickets for each
    # screening of given film
    # get array of ticket objects
    sql = "SELECT tickets.* FROM tickets
    INNER JOIN screenings ON tickets.screening_id = screenings.id
    WHERE film_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    tickets_array = result.map {|ticket_object| Ticket.new(ticket_object)}
    # # pull ticket objects out by screening_id,
    # # put those tickets into new arrays, one for each screening_id
    # # if statement in the loop is flawed, but I am out of time!
    # screening1 = []
    # screening2 = []
    # for i in tickets_array[i]
    #   if tickets_array[i].screening_id == tickets_array[i+1].screening_id
    #     screening1 << tickets_array[i]
    #   else
    #     screening2 << tickets_array[i+1]
    #   end
    # end
    # # compare array lengths, return longest array
    # if screening1.length() > screening2.length()
    #   return screening1
    # else
    #   return screening2
    # end
  end

  def self.all()
    sql = "SELECT * FROM films"
    all_films = SqlRunner.run(sql)
    return all_films.map {|film_object| Film.new(film_object)}
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end


end
