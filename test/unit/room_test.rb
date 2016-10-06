require File.dirname("library") + '/test/test_helper'

class RoomTest < ActiveSupport::TestCase
  fixtures :rooms

  def test_room
    
    one_member = Room.new     :title => rooms(:one).title, 
                         :location => rooms(:one).location,
                         :description => rooms(:one).description,
                         :status => rooms(:one).status,
						 :user => rooms(:one).user
                         
    assert_not one_member.save

    one_member_copy = Room.find(one_member.title)

    assert_equal one_member.title, one_member_copy.description

    one_member.title = "49"
    one_member.description = 34
    assert one_member.save
    assert one_member.destroy
  end

end
