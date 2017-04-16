require "spec_helper"

RSpec.describe Digicert::CLI::Command do
  describe ".run" do
    it "runs the command through proper handler" do
      mock_cli_order_command_messages(:new, :list)
      Digicert::CLI::Command.run("order:list")

      expect(Digicert::CLI::Command::Order.new).to have_received(:list)
    end
  end

  def mock_cli_order_command_messages(*messages)
    allow(Digicert::CLI::Command::Order).to receive_message_chain(messages)
  end
end
