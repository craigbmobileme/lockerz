require 'securerandom'
require 'thread'
class Locker < ActiveRecord::Base
	enum bag_size: [ :large_bag, :medium_bag, :small_bag ]
	enum size: [:large_locker, :medium_locker, :small_locker]
	validates :bag_size, presence: true
	validate :lockers_left

	TOTAL_SMALL_LOCKERS = 1000
	TOTAL_MEDIUM_LOCKERS = 1000
	TOTAL_LARGE_LOCKERS = 1000

	# hold the locker numbers
	@@number_queue = nil

	after_initialize :create_number_queue
	after_validation :create_code, :set_locker


	#create the number queue should be threadsafe, probably a better way to do this
	# but didnt want to create a ton of rows in the DB and a ton of queries
	def create_number_queue
		if (@@number_queue.nil?)
			@@number_queue = Queue.new
			total_numbers = TOTAL_SMALL_LOCKERS + TOTAL_MEDIUM_LOCKERS + TOTAL_LARGE_LOCKERS
			total_numbers.times do |i|
				@@number_queue << i
			end

		end
	end

	#validate that there are lockers left
	def lockers_left 
		if self.large_bag?
			total_lockers = Locker.where(size: Locker.sizes[:large_locker]).count
			if total_lockers >= TOTAL_LARGE_LOCKERS
				errors.add(:bag_size, "No large lockers left");
			end
		elsif self.medium_bag?
			total_lockers = Locker.where(size: [Locker.sizes[:large_locker], Locker.sizes[:medium_locker]]).count
			if total_lockers >= (TOTAL_LARGE_LOCKERS + TOTAL_MEDIUM_LOCKERS)
				errors.add(:bag_size, "No large or medium lockers left");
			end
		else
			total_lockers = Locker.where(size: [Locker.sizes[:large_locker], Locker.sizes[:medium_locker], Locker.sizes[:small_locker]]).count
			if total_lockers >= (TOTAL_LARGE_LOCKERS + TOTAL_MEDIUM_LOCKERS + TOTAL_SMALL_LOCKERS)
				errors.add(:bag_size, "No large or medium or small lockers left");
			end
		end


	end

	# simple way to store the various locker numbers for the sizes for retrieving
	def get_locker_number
		self.number = @@number_queue.pop()
		
	end

	# free the locker we are retreiving a bag from
	def free_locker_number
		@@number_queue << self.number
	end

	# sets the bag size and locker size which may be different from the locker size
	# also set the locker number
	def set_locker
		if self.large_bag?
			self.size = :large_locker
		elsif self.medium_bag?
			med_count = Locker.where(size: Locker.sizes[:medium_locker]).count
			if med_count < TOTAL_MEDIUM_LOCKERS

				self.size = :medium_locker
			else
				large_count = Locker.where(size: Locker.sizes[:large_locker]).count
				self.size = :large_locker
			end
			
		else
			small_count = Locker.where(size: Locker.sizes[:small_locker]).count
			if small_count < TOTAL_SMALL_LOCKERS
				self.size = :small_locker
			else
				med_count = Locker.where(size: Locker.sizes[:medium_locker]).count
				
				if med_count < TOTAL_MEDIUM_LOCKERS
					self.size = :medium_locker
				else
					large_count = Locker.where(size: Locker.sizes[:large_locker]).count
					self.size = :large_locker
				end
			end
		end

		# get the locker number
		get_locker_number
			
	end

	# creates the unique id to be given on the ticket to the locker holder, 
	# created each time a locker is filled so someone cant photocopy a ticket 
	# and retrieve someone elses bag later on..
	def create_code
		self.code = SecureRandom.hex(10)
	end

end
