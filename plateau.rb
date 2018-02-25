class Plateau
  attr_reader :x_dimension, :y_dimension

  def initialize(x_dimension, y_dimension)
    @x_dimension = x_dimension
    @y_dimension = y_dimension
  end

  def valid_position?(position)
    # in bounds and not already occupied(?)
  end
end
