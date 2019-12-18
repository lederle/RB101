puts "Welcome to the Calculator!"
puts "What is your first number:"
num1 = gets.chomp
puts "What is your second number:"
num2 = gets.chomp
puts "What is the operation you wish to perform: (add)ition, (sub)traction, (mult)iplication or (div)ision"
op = gets.chomp

if op == 'add'
  result = num1.to_i + num2.to_i
elsif op == 'sub'
  result = num1.to_i - num2.to_i
elsif op == 'mult'
  result = num1.to_i * num2.to_i
else
  result = num1.to_f / num2.to_f
end

puts result
