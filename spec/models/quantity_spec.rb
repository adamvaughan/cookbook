describe Quantity do
  describe ".parse" do
    it "parses whole numbers" do
      expect(Quantity.parse('1')).to eql(1)
    end

    it "parses fractions" do
      expect(Quantity.parse('1/2')).to eql(0.5)
    end

    it "parses whole numbers with fractions" do
      expect(Quantity.parse('1 1/2')).to eql(1.5)
    end

    it "parses decimal numbers" do
      expect(Quantity.parse('1.5')).to eql(1.5)
    end
  end
end
