RSpec.describe Todoable do
  it "has a version number" do
    expect(Todoable::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(Todoable::TodoableAPI.some_string).to eq("Hello World")
  end
end
