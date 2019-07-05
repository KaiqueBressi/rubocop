# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Metrics::PerceivedMethodLength, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) { { 'Max' => 1 } }

  context 'when method is an instance method' do
    xit 'registers an offense' do
      expect_offense(<<~RUBY)
        def m
            ^ Method has too many statements. [2/1]
           if a
              [
                 1,
                 2,
                 3,
                 4
              ]
           end
        end
      RUBY
    end

    it 'register an offense' do
      expect_offense(<<~RUBY)
                     def m
                         ^ Method has too many statements. [7/1]
                     logger.info "[APPLICATION_SUBMISSION] Started to submit applications to automated submission flow."
                     csv = CSV.read(filepath, headers: true, col_sep: ',', encoding: 'UTF-8')
                     logger.info "[APPLICATION_SUBMISSION] Sending \#{csv.count} applications from file to automated submission flow."

                     failure_count = 0
                     csv.each_with_index do |row, index|
                     begin
                     application_id = row.field('id')
                     logger.info "[APPLICATION_SUBMISSION] Sending \#{index + 1} of \#{csv.count} applications, id: \#{application_id}"

                     application = application_repository.find(application_id)

                     if application && application.consultant_id.nil? && !application.discarded?
                     submission_use_case.create(application)
                     else
                     failure_count += 1
                     logger.error "[APPLICATION_SUBMISSION][ERROR] Application not available for automated submission, id: \#{application_id}"
                     end
                     rescue StandardError => e
                     failure_count += 1
                     logger.error "[APPLICATION_SUBMISSION][ERROR] An error has occured when trying to submit application with id \#{application_id}. " +
                     "Error: \#{e} \#{e.message}."
                     end
                     end
                     logger.info "[APPLICATION_SUBMISSION] Processed \#{filepath} file with \#{csv.count} applications. " +
                     "Successful applications submited \#{csv.count - failure_count}. " +
                     "Failed \#{failure_count}."
                     end
                     RUBY

    end
  end
end
