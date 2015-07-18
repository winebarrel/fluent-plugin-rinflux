describe 'Fluent::RinfluxOutput#configure' do
  subject do |example|
    param = example.full_description.split(/\s+/)[1]
    create_driver(fluentd_conf).instance.send(param)
  end

  let(:fluentd_conf) do |example|
    conf = {db: :mydb}
    param = example.full_description.split(/\s+/)[1]
    value = example.example_group.description

    unless value.empty?
      conf.update(param.to_sym => value)
    end

    conf
  end

  describe 'db' do
    context 'anydb' do
      it { is_expected.to eq 'anydb' }
    end
  end

  describe 'host' do
    context '' do
      it { is_expected.to eq 'localhost' }
    end

    context '127.0.0.1' do
      it { is_expected.to eq '127.0.0.1' }
    end
  end

  describe 'port' do
    context '' do
      it { is_expected.to eq 8086 }
    end

    context 8087 do
      it { is_expected.to eq 8087 }
    end
  end
end
