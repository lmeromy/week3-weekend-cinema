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
