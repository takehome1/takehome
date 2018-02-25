require_relative "plateau.rb"
require_relative "rover.rb"

class MarsRoverSimulator
  attr_reader :plateau, :rovers

  def initialize
    setup_test_rovers
    move_all_rovers
  end

  def setup_test_rovers
    @plateau = Plateau.new(5, 5)

    rover_1 = Rover.new(
      position: [1, 2],
      direction: "N",
      instructions: %w(L M L M L M L M M),
    )
    @rovers << rover_1

    rover_2 = Rover.new(
      position: [3, 3],
      direction: "E",
      instructions: %w(M M R M M R M R R M),
    )
    @rovers << rover_2
  end

  def move_all_rovers
    # call move_rover on each of the rovers
  end

  def move_rover(start_position, start_direction, instructions)
    # follow each instruction
    # return end position, end direction
  end
end
