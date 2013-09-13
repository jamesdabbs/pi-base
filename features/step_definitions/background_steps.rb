Given(/^the following spaces$/) do |table|
  table.hashes.each do |h|
    h[:meta] = eval h[:meta]
    
    Space.create! h
  end
end

Given(/^the following properties$/) do |table|
  table.hashes.each do |h|
    h[:value_set] = ValueSet.new
    h[:meta]      = eval h[:meta]
    
    Property.create! h
  end
end
