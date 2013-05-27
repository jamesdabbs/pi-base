desc 'Check for Counterexamples consistency and new proofs'
task :check => :environment do
  # Check for discrepancies from Counterexamples
  print "Checking for discrepancies ... "
  diffs = Trait::Table::Checker.new.check
  CheckMailer.report(diffs).deliver unless diffs.empty?
  puts "done. Found #{diffs}."

  # Check for provable facts
  Theorem.all.each { |t| t.explore }
end