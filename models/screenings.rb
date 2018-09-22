require_relative('../db/sql_runner')

class Screening
  attr_reader :id, :film_id
  attr_accessor :start_time, :seats

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @start_time = options['start_time']
    @seats = options['seats'].to_i
    @film_id = options['film_id'].to_i
  end

  def save()
    sql = "INSERT INTO screenings (start_time, seats, film_id)
    VALUES ($1, $2, $3) RETURNING id"
    values = [@start_time, @seats, @film_id]
    screening = SqlRunner.run(sql, values).first
    @id = screening['id'].to_i
  end

  def update()
    sql = "UPDATE screenings SET (start_time, seats, film_id) =
    ($1, $2, $3) WHERE id = $4"
    values = [@start_time, @seats, @film_id, @id]
    film = SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    film = SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    all_screenings = SqlRunner.run(sql)
    return all_screenings.map {|screening_object| Screening.new(screening_object)}
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end


end
