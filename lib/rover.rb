class Rover
  attr_reader :position,
              :direction,
              :instructions

  def initialize(position:, direction:, instructions:)
    @position = position
    @direction = direction
    @instructions = instructions
  end
end
