require 'spec_helper'

describe Ethon::Easy::Http::Put do
  let(:easy) { Ethon::Easy.new }
  let(:url) { "http://localhost:3001/" }
  let(:params) { nil }
  let(:form) { nil }
  let(:put) { described_class.new(url, {:params => params, :body => form}) }

  describe "#setup" do
    context "when nothing" do
      it "sets url" do
        put.setup(easy)
        expect(easy.url).to eq(url)
      end

      it "sets upload" do
        easy.should_receive(:upload=).with(true)
        put.setup(easy)
      end

      it "sets infilesize" do
        easy.should_receive(:infilesize=).with(0)
        put.setup(easy)
      end

      context "when requesting" do
        it "makes a put request" do
          put.setup(easy)
          easy.perform
          expect(easy.response_body).to include('"REQUEST_METHOD":"PUT"')
        end
      end
    end

    context "when params" do
      let(:params) { {:a => "1&"} }

      it "attaches escaped to url" do
        put.setup(easy)
        expect(easy.url).to eq("#{url}?a=1%26")
      end

      it "sets upload" do
        easy.should_receive(:upload=).with(true)
        put.setup(easy)
      end

      it "sets infilesize" do
        easy.should_receive(:infilesize=).with(0)
        put.setup(easy)
      end

      context "when requesting" do
        before do
          put.setup(easy)
          easy.perform
        end

        it "makes a put request" do
          expect(easy.response_body).to include('"REQUEST_METHOD":"PUT"')
        end
      end
    end

    context "when body" do
      let(:form) { {:a => "1&b=2"} }

      it "sets infilesize" do
        easy.should_receive(:infilesize=).with(11)
        put.setup(easy)
      end

      it "sets readfunction" do
        easy.should_receive(:readfunction=)
        put.setup(easy)
      end

      it "sets upload" do
        easy.should_receive(:upload=).with(true)
        put.setup(easy)
      end

      context "when requesting" do
        before do
          easy.headers = { 'Expect' => '' }
          put.setup(easy)
          easy.perform
        end

        it "makes a put request" do
          expect(easy.response_body).to include('"REQUEST_METHOD":"PUT"')
        end

        it "submits a body" do
          expect(easy.response_body).to include('"body":"a=1%26b%3D2"')
        end
      end
    end

    context "when params and body"
  end
end
