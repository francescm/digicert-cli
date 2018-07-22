module Digicert
  module CLI
    class OrderDuplicator < Digicert::CLI::Base
      def create
        apply_output_options(duplicate_an_order)
      end

      private

      attr_reader :csr_file, :output_path

      def extract_local_attributes(options)
        @csr_file = options.fetch(:csr, nil)
        @output_path = options.fetch(:output, "/tmp")
      end

      def duplicate_an_order
        Digicert::OrderDuplicator.create(order_params)
      end

      def order_params
        Hash.new.tap do |order_params|
          order_params[:order_id] = order_id

          if csr_file && File.exists?(csr_file)
            order_params[:csr] = File.read(csr_file)
          end
        end
      end

      def apply_output_options(duplicate)
        if duplicate
          print_request_details(duplicate.requests.first)
          fetch_and_download_certificate(duplicate.id)
        end
      end

      def print_request_details(request)
        Digicert::CLI::Util.say(
          "Duplication request #{request.id} created for order - #{order_id}",
        )
      end

      def fetch_and_download_certificate(duplicate_order_id)
        if options[:output]
          order = fetch_duplicate_order(duplicate_order_id)
          download_certificate_order(order.certificate.id)
        end
      end

      def fetch_duplicate_order(duplicate_order_id)
        Digicert::CLI::OrderRetriever.fetch(
          duplicate_order_id,
          wait_time: options[:wait_time],
          number_of_times: options[:number_of_times]
        )
      end

      def download_certificate_order(certificate_id)
        Digicert::CLI::CertificateDownloader.download(
          filename: order_id, path: output_path, certificate_id: certificate_id
        )
      end
    end
  end
end
