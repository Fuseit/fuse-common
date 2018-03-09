require 'fuse_common/airbrake_config'

RSpec.describe FuseCommon::AirbrakeConfig do
  let(:instance) { described_class.new env }

  describe '#apply' do
    subject { instance.apply }

    context 'when ENV is empty' do
      let :env do
        double 'Figaro',
          rails_env: nil,
          stack_name: nil,
          airbrake_project_id: nil,
          airbrake_project_key: nil
      end

      it { expect { subject }.not_to raise_error }

      it 'runs Airbrake configuration' do
        expect(Airbrake).to receive(:configure)
        subject
      end
    end

    context 'when stubbed configuration' do
      let :env do
        double 'Figaro',
          rails_env: nil,
          stack_name: nil,
          airbrake_project_id: nil,
          airbrake_project_key: nil
      end

      let :config do
        double 'AirbrakeConfig',
          'environment=': nil,
          'ignore_environments=': nil,
          'project_id=': nil,
          'project_key=': nil,
          'foo': nil
      end

      before do
        allow(Airbrake).to receive(:configure) { |&block| block.call config }
      end

      context 'when run with block' do
        subject { instance.apply(&:foo) }

        it 'yields provided block' do
          expect(config).to receive(:foo).once
          subject
        end
      end

      context 'when provided not ignored environment' do
        let :env do
          double 'Figaro',
            rails_env: 'production',
            stack_name: nil,
            airbrake_project_id: nil,
            airbrake_project_key: nil
        end

        it { expect { subject }.to raise_error FuseCommon::AirbrakeConfig::RequiredKeyMissed }
      end

      context 'when provided ignored environment by default' do
        let :env do
          double 'Figaro',
            rails_env: 'development',
            stack_name: nil,
            airbrake_project_id: nil,
            airbrake_project_key: nil
        end

        it { expect { subject }.not_to raise_error }
      end

      context 'when provided ignored environments through overrides' do
        let :overrides do
          { ignore_environments: %w(test foo) }
        end

        let(:instance) { described_class.new env, overrides }

        context 'when ENV are in ignored environments' do
          let :env do
            double 'Figaro',
              rails_env: 'foo',
              stack_name: nil,
              airbrake_project_id: nil,
              airbrake_project_key: nil
          end

          it { expect { subject }.not_to raise_error }
        end
      end
    end
  end
end
