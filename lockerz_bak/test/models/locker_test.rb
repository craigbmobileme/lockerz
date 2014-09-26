require 'test_helper'

class LockerTest < ActiveSupport::TestCase
	test "should be able to create a locker" do
	  locker = Locker.new
	  locker.bag_size = :small_bag
	  locker.save
	  
	  assert locker.size == "small_locker"
	  assert locker.bag_size == "small_bag"

	  # TODO free locker number doesnt work in conjunction with before_destroy, need a better way to do the number handling
	  locker.free_locker_number
	  locker.destroy
	end

	test "locker must require a bag size to save" do
	  locker = Locker.new
	  assert_not locker.save
	end

	test "locker should get assigned a number" do
	  locker = Locker.new({bag_size: :small_bag})
	  
	  assert locker.save
	  assert locker.number.is_a?(Fixnum)
	

	  locker.free_locker_number
	  locker.destroy
	end

	test "should run out of lockers" do
	  locker = Locker.new({bag_size: :small_bag})
	  
	  assert locker.save
	  assert locker.number.is_a?(Fixnum)
	

	  locker.free_locker_number
	  locker.destroy
	end
end
