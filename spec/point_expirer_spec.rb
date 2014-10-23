require 'rails_helper'

describe PointExpirer do
  context 'expire points' do
    user = FactoryGirl.create :user
    user.point_line_items.create(points: 25, created_at: '01/01/2013')
    user.point_line_items.create(points: 410, created_at: '10/02/2013')
    user.point_line_items.create(points: -250, created_at: '15/02/2013')
    user.point_line_items.create(points: 10, created_at: '18/02/2013')
    user.point_line_items.create(points: 570, created_at: '12/03/2013')
    user.point_line_items.create(points: -500, created_at: '15/04/2013')
    user.point_line_items.create(points: 130, created_at: '27/06/2013')

    it 'expire1' do
      PointExpirer.new.expire Date.parse('2014-03-13')
      expect(user.point_line_items.sum(:points)).to eql(130)
    end

    it 'expire2' do
      PointExpirer.new.expire Date.parse('2014-06-01')
      expect(user.point_line_items.sum(:points)).to eql(130)
    end

    it 'expire3' do
      PointExpirer.new.expire Date.parse('2014-06-28')
      expect(user.point_line_items.sum(:points)).to eql(0)
    end

  end


end