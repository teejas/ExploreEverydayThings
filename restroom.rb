DURATION = 540
class Restroom
	attr_reader :queue
	attr_reader :facilities

	def initialize(facilities_per_restroom=3) # set number of urinals
		@queue = []
		@facilities = []
		facilities_per_restroom.times { @facilities << Facility.new }
	end

	def enter(person)
		unoccupied_facility = @facilities.find { |facility| not facility.occupied? }
		if unoccupied_facility
			unoccupied_facility.occupy person
		else
			@queue << person
		end
	end
	
	def tick
		@facilities.each { |f| f.tick }
	end
end

class Facility
	def initialize
		@occupier = nil
		@duration = 0
	end

	def occupy(person)
		unless occupied?
			@occupier = person
			@duration = 1
			Person.population.delete person
			true
		else
			false
		end
	end

	def occupied?
		not @occupier.nil?
	end

	def vacate
		Person.population << @occupier
		@occupier = nil
	end

	def tick
		if occupied? and @duration > @occupier.use_duration
			vacate
			@duration = 0
		elsif occupied?
			@duration += 1
		end
	end
end

class Person
	@@population = []
	attr_reader :use_duration
	attr_accessor :frequency

	def initialize(frequency=4, use_duration=1)
		@frequency = frequency
		@use_duration = use_duration
	end

	def self.population
		@@population
	end

	def need_to_go?
		rand(DURATION) + 1 <= @frequency
	end
end
