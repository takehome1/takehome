require "Set"

class Plateau
  def initialize(x_dimension, y_dimension)
    @x_dimension = x_dimension
    @y_dimension = y_dimension
    @occupied = Set.new
  end

  def valid_position?(position)
    !out_of_bounds?(position) && !occupied?(position)
  end

  def set_occupied(position)
    @occupied.add(position)
  end

  def unset_occupied(position)
    @occupied.delete(position)
  end

  private

  attr_reader :x_dimension,
              :y_dimension,
              :occupied

  def occupied?(position)
    @occupied.include?(position)
  end

  def out_of_bounds?(position)
    x, y = position
    !(x.between?(0, x_dimension) && y.between?(0, y_dimension))
  end
end
