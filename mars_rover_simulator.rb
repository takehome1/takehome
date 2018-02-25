require_relative "plateau.rb"
require_relative "rover.rb"

class MarsRoverSimulator
  ROVER_COUNT = 2

  def initialize
    @plateau = Plateau.new(5, 5)
    @rovers = []

    setup_test_rovers
    place_all_rovers
    move_all_rovers
  end

  private

  attr_reader :plateau, :rovers

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

  def place_all_rovers
    rovers.each do |rover|
      plateau.set_occupied(rover.position)
    end
  end

  def move_all_rovers
    rovers.each_with_index do |rover, i|
      final_position = move_rover(rover.position, rover.direction, rover.instructions)
      puts "Rover #{i+1}'s ending position: #{final_position}"
    end
  end

  def move_rover(start_position, start_direction, instructions)
    old_x, old_y = start_position
    new_x, new_y = start_position
    current_direction = start_direction

    instructions.each do |instruction|
      changed_position = false

      if instruction == "M"
        changed_position = true

        case current_direction
        when "N"
          new_y += 1
        when "S"
          new_y -= 1
        when "E"
          new_x += 1
        when "W"
          new_x -= 1
        end
      elsif instruction == "L"
        case current_direction
        when "N"
          current_direction = "W"
        when "S"
          current_direction = "E"
        when "E"
          current_direction = "N"
        when "W"
          current_direction = "S"
        end
      elsif instruction == "R"
        case current_direction
        when "N"
          current_direction = "E"
        when "S"
          current_direction = "W"
        when "E"
          current_direction = "S"
        when "W"
          current_direction = "N"
        end
      end

      if changed_position
        plateau.unset_occupied([old_x, old_y])
        raise "invalid position #{[new_x, new_y]}" unless plateau.valid_position?([new_x, new_y])
        plateau.set_occupied([new_x, new_y])
        old_x, old_y = new_x, new_y
      end
    end

    "#{new_x} #{new_y} #{current_direction}"
  end
end
