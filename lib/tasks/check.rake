desc 'Check for Counterexamples consistency and new proofs'
task :check => :environment do
  # Check for discrepancies from Counterexamples
  diffs = Trait::Table::Checker.new.check
  CheckMailer.report(diffs).deliver unless diffs.empty?

  # Check for provable facts
  Theorem.all.each { |t| t.explore }
end