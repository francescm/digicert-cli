require "digicert/cli/order"
require "digicert/cli/order_reissuer"
require "digicert/cli/order_duplicator"

module Digicert
  module CLI
    module Commands
      class Order < Thor
        desc "list", "List digicert orders"
        method_option :filter, type: :hash, desc: "Specify filter options"

        def list
          say(order_instance.list)
        end

        desc "find", "Find a digicert order"
        method_option :filter, type: :hash, desc: "Specify filter options"
        option :quiet, type: :boolean, aliases: "-q", desc: "Retrieve only id"

        def find
          say(order_instance.find)
        end

        desc "reissue ORDER_ID", "Reissue digicert order"
        option :csr, desc: "The CSR content from a file"
        option :output, aliases: "-o", desc: "Path to download certificates"

        def reissue(order_id)
          say(reissue_an_order(order_id))
        end

        desc "duplicate ORDER_ID", "Duplicate digicert order"
        option :csr, desc: "The CSR content from a file"
        option :output, aliases: "-o", desc: "Path to download certificate"
        def duplicate(order_id)
          say(duplicate_an_order(order_id))
        end

        private

        def order_instance
          Digicert::CLI::Order.new(options)
        end

        def reissue_an_order(order_id)
          Digicert::CLI::OrderReissuer.new(
            options.merge(order_id: order_id),
          ).create
        end

        def duplicate_an_order(order_id)
          Digicert::CLI::OrderDuplicator.new(
            options.merge(order_id: order_id),
          ).create
        end
      end
    end
  end
end
