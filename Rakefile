task :default => %w{public/calculator.js} 

desc "Compile the grammar public/calculator.jison"
file "public/calculator.js" => %w{public/calculator.jison} do
  sh "jison public/calculator.jison public/calculator.l -o public/calculator.js"
end

desc "Compile the sass public/styles.scss"
task :css do
  sh "sass public/styles.scss public/styles.css"
end

task :testf do
  sh " open -a firefox test/test.html"
end

task :tests do
  sh " open -a safari test/test.html"
end

task :clean do
  sh "rm -f public/calculator.js"
end

desc "Open browser in GitHub repo"
task :github do
  sh "open https://github.com/crguezl/ull-etsii-grado-pl-jisoncalc"
end
