require_relative "plateau.rb"
require_relative "rover.rb"
require "ostruct"

class MarsRoverSimulator
  ROVER_COUNT = 2

  LEFT_TURNS = {
    "N" => "W",
    "S" => "E",
    "E" => "N",
    "W" => "S",
  }

  RIGHT_TURNS = {
    "N" => "E",
    "S" => "W",
    "E" => "S",
    "W" => "N",
  }

  VECTORS = {
    "N" => OpenStruct.new(direction: :y, delta: 1),
    "S" => OpenStruct.new(direction: :y, delta: -1),
    "E" => OpenStruct.new(direction: :x, delta: 1),
    "W" => OpenStruct.new(direction: :x, delta: -1),
  }

  def initialize
    @rovers = []
  end

  def run_simulation(scenario=nil)
    setup_rovers(scenario)
    place_all_rovers
    move_all_rovers
  end

  private

  attr_reader :plateau, :rovers

  def setup_rovers(scenario)
    if scenario
      setup_test_input(scenario)
    else
      get_user_input
    end
  end

  def get_user_input
    puts "Welcome to Sam's Mars Rover Simulator!"

    build_user_plateau

    ROVER_COUNT.times do |rover_number|
      build_user_rover(rover_number)
    end
  end

  def build_user_plateau
    puts "Please enter the dimensions of the plateau (e.g. Enter \"5 3\" for a 5x3 plateau):"
    current_user_input = STDIN.gets.chomp
    if current_user_input.match(/^\d+ \d+$/)
      @plateau = Plateau.new(*current_user_input.split.map(&:to_i))
    else
      puts "Invalid input format."
      build_user_plateau
    end
  end

  def build_user_rover(rover_number)
    rover_no = rover_number + 1

    puts "Please enter the position of Rover \##{rover_no} (e.g. Enter \"1 2 N\" to place the rover at position [1, 2], facing north):"
    current_user_input = STDIN.gets.chomp
    if current_user_input.match(/^\d+ \d+ [NSEW]$/)
      rover_position = current_user_input.split(" ").take(2).map(&:to_i)
      rover_direction = current_user_input.split(" ").last
    else
      puts "Invalid input format."
      build_user_rover(rover_number)
    end

    puts "Please enter movement instructions for Rover \##{rover_no} (e.g. Enter \"LMRM\" for the rover to turn left, move forward, turn right, and move forward):"
    current_user_input = STDIN.gets.chomp

    if current_user_input.match(/^[LMR]+$/)
      rover_instructions = current_user_input.split("")
    else
      puts "Invalid input format."
      build_user_rover(rover_number)
    end

    new_rover = Rover.new(
      position: rover_position,
      direction: rover_direction,
      instructions: rover_instructions,
    )

    @rovers << new_rover
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

      case instruction
      when "L"
        current_direction = LEFT_TURNS[current_direction]
      when "R"
        current_direction = RIGHT_TURNS[current_direction]
      when "M"
        changed_position = true
        vector = VECTORS[current_direction]

        if vector.direction == :x
          new_x += vector.delta
        else
          new_y += vector.delta
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

  def setup_test_input(scenario)
    @plateau = Plateau.new(5, 5)

    case scenario
    when :success
      instructions_2 = %w(M M R M M R M R R M)
    when :falls_off
      instructions_2 = %w(M M M)
    when :collision
      instructions_2 = %w(L L M M)
    end

    rover_1 = Rover.new(
      position: [1, 2],
      direction: "N",
      instructions: %w(L M L M L M L M M),
    )
    @rovers << rover_1

    rover_2 = Rover.new(
      position: [3, 3],
      direction: "E",
      instructions: instructions_2,
    )
    @rovers << rover_2
  end
end
