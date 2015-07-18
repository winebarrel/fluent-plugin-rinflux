describe Fluent::RinfluxOutput do
  let(:time) { Time.parse('2015/05/24 18:30 UTC').to_i }
  let(:time_nsec) { time * (10 ** 9) }
  let(:fluentd_conf) { {db: :mydb} }
  let(:output) { [] }

  let(:driver) do |example|
    driver = create_driver(fluentd_conf)
    client = driver.instance.instance_variable_get(:@client)

    allow(client).to receive(:write) do |measurement, value, options|
      output << [measurement, value, options]
    end

    driver
  end

  subject { output }

  before do
    driver.run do
      driver.emit(described_class, time)
    end
  end

  context("disk_free"=>442221834240) do
    it do
      is_expected.to eq [
        ["disk_free", 442221834240, {:db=>"mydb", :tags=>{}, :timestamp=>time_nsec}]
      ]
    end
  end

  context("disk_free"=>442221834240, "tags"=>{"hostname"=>"server01","disk_type"=>"SSD"}) do
    it do
      is_expected.to eq [
        ["disk_free", 442221834240, {:db=>"mydb", :tags=>{"hostname"=>"server01","disk_type"=>"SSD"}, :timestamp=>time_nsec}]
      ]
    end
  end

  context("disk_free"=>{"free_space"=>442221834240,"disk_type"=>"SSD"}) do
    it do
      is_expected.to eq [
        ["disk_free", {"free_space"=>442221834240,"disk_type"=>"SSD"}, {:db=>"mydb", :tags=>{}, :timestamp=>time_nsec}]
      ]
    end
  end
end
