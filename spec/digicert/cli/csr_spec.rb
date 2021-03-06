require "spec_helper"

RSpec.describe Digicert::CLI::CSR do
  describe "#fetch" do
    it "fetches the csr for an existing order" do
      order_id = 123456
      stub_digicert_order_fetch_api(order_id)

      csr = Digicert::CLI::CSR.new(order_id: order_id).fetch

      expect(csr).not_to be_nil
      expect(csr).to eq("------ [CSR HERE] ------")
    end
  end

  describe "#generate" do
    context "with existing order details" do
      it "generates a new csr for an existing order" do
        order_id = 123456
        key_file = "./spec/fixtures/rsa4096.key"
        stub_digicert_order_fetch_api(order_id)

        csr = Digicert::CLI::CSR.new(order_id: order_id, key: key_file).generate

        expect(csr.start_with?("-----BEGIN CERTIFICATE REQUEST")).to be_truthy
        expect(csr.end_with?("--END CERTIFICATE REQUEST-----\n")).to be_truthy
      end
    end

    context "with custom details" do
      it "generates a new csr using the provided details" do
        order_id = 123456
        common_name = "ribosetest.com"
        key_file = "./spec/fixtures/rsa4096.key"
        san = ["site1.ribosetest.com", "site2.ribosetest.com"]
        stub_digicert_order_fetch_api(order_id)

        csr = Digicert::CLI::CSR.new(
          order_id: order_id, common_name: common_name, san: san, key: key_file,
        ).generate

        expect(csr.start_with?("-----BEGIN CERTIFICATE REQUEST")).to be_truthy
        expect(csr.end_with?("--END CERTIFICATE REQUEST-----\n")).to be_truthy
      end
    end
  end
end
