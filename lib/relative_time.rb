# frozen_string_literal: true

module RelativeTime
  # derived from http://stackoverflow.com/a/195894
  def to_relative
    a = (Time.now - self).to_i

    case a
    when 0 then 'just now'
    when 1 then 'a second ago'
    when 2..59 then a.to_s + ' seconds ago'
    when 60..119 then 'a minute ago' # 120 = 2 minutes
    when 120..3540 then (a / 60).to_i.to_s + ' minutes ago'
    when 3541..7100 then 'an hour ago' # 3600 = 1 hour
    when 7101..82_800 then ((a + 99) / 3600).to_i.to_s + ' hours ago'
    when 82_801..172_000 then 'yesterday ' + (hour < 12 ? 'morning' : 'afternoon')
    when 172_001..518_400 then ((a + 800) / (60 * 60 * 24)).to_i.to_s + ' days ago'
    when 518_400..1_036_800 then 'a week ago'
    else ((a + 180_000) / (60 * 60 * 24 * 7)).to_i.to_s + ' weeks ago'
    end
  end
end
