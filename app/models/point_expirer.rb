class PointExpirer
  def expire(date)
    expire_date = date - 1.year
    PointLineItem.select('sum(points) as balance,user_id').where('created_at < ?',expire_date).group(:user_id).each do |record|
      spent = PointLineItem.where('points < 0 AND user_id = ? AND created_at >= ?',record.user_id, expire_date).sum(:points)
      storn = record.balance + spent
      if storn > 0
        PointLineItem.create(user_id: record.user_id, points: -storn, source: 'Points #5 expired', created_at: expire_date)
      end
    end
  end
end