class CheckMailer < ActionMailer::Base
  default \
    to:      'jamesdabbs@gmail.com', 
    from:    'site@topology.jdabbs.com',
    subject: 'Found discrepancy with Counterexamples data'

  def report diffs
    @diffs = diffs
    mail
  end
end
