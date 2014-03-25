task :default => %w{calculator.js} 

file "calculator.js" => %w{calculator.jison} do
  sh "jison calculator.jison calculator.l -o calculator.js"
end

task :testf do
  sh " open -a firefox test/test.html"
end

task :tests do
  sh " open -a safari test/test.html"
end

task :clean do
  sh "rm -f calculator.js"
end
