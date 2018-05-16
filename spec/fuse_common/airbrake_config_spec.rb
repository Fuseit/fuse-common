require 'fuse_common/airbrake_config'

RSpec.describe FuseCommon::AirbrakeConfig do
  let(:instance) { described_class.new env }
  let(:figaro) { instance_double 'Figaro', env: env }

  describe '#apply' do
    subject(:apply) { instance.apply }

    context 'when ENV is empty' do
      let :env do
        class_double 'Figaro::ENV',
          rails_env: nil,
          stack_name: nil,
          airbrake_project_id: nil,
          airbrake_project_key: nil
      end

      it { expect { apply }.not_to raise_error }

      it 'runs Airbrake configuration' do
        allow(Airbrake).to receive(:configure)
        apply
        expect(Airbrake).to have_received(:configure)
      end
    end

    context 'when stubbed configuration' do
      let :env do
        class_double 'Figaro::ENV',
          rails_env: nil,
          stack_name: nil,
          airbrake_project_id: nil,
          airbrake_project_key: nil
      end

      let :config do
        instance_double 'AirbrakeConfig',
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
        subject(:apply_with_block) { instance.apply(&:foo) }

        it 'yields provided block' do
          allow(config).to receive(:foo)
          apply_with_block
          expect(config).to have_received(:foo).once
        end
      end

      context 'when provided not ignored environment' do
        let :env do
          class_double 'Figaro::ENV',
            rails_env: 'production',
            stack_name: nil,
            airbrake_project_id: nil,
            airbrake_project_key: nil
        end

        it { expect { apply }.to raise_error FuseCommon::AirbrakeConfig::RequiredKeyMissed }
      end

      context 'when provided ignored environment by default' do
        let :env do
          class_double 'Figaro::ENV',
            rails_env: 'development',
            stack_name: nil,
            airbrake_project_id: nil,
            airbrake_project_key: nil
        end

        it { expect { apply }.not_to raise_error }
      end

      context 'when provided ignored environments through overrides' do
        let :overrides do
          { ignore_environments: %w(test foo) }
        end

        let(:instance) { described_class.new env, overrides }

        context 'when ENV are in ignored environments' do
          let :env do
            class_double 'Figaro::ENV',
              rails_env: 'foo',
              stack_name: nil,
              airbrake_project_id: nil,
              airbrake_project_key: nil
          end

          it { expect { apply }.not_to raise_error }
        end
      end
    end
  end
end
