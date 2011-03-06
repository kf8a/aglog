activities do |a|
  a.user = 'jim'
  a.setup = {tractor, implement, implement}
  a.area = T1::T5
  a.date = today
end

activity :user => {:name => 'jim', time => '4 hours'},
  :setup => {tractor, implement},
  :material => {:name => 'urea', :rate => 45}, :area => 'T1:T4',
  :date => today, :comment => "I didn't do it"

activity do
  user do
    name 'simmonsj'
    time 4 hours
  end
  setup do
    tractor 'JD234'
    implement 'planter'
  end
  material do
    name 'corn'
    rate 54
  end
  area 'T1:T3'
  date Date.today
  comment 'nothing  happened'
end