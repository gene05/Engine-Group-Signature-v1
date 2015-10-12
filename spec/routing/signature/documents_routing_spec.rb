require "spec_helper"

module Signature
  describe DocumentsController do
=begin

    describe "routing" do

      it "routes to #index" do
        get('/').should route_to('signature/signatures#trips')
      end

      it "routes to #new" do
        get("documents/new").should route_to("signature/documents#new")
      end

      it "routes to #show" do
        get("documents/1").should route_to("signature/documents#show", :id => "1")
      end

      it "routes to #edit" do
        get("documents/1/edit").should route_to("signature/documents#edit", :id => "1")
      end

      it "routes to #create" do
        post("documents").should route_to("signature/documents#create")
      end

      it "routes to #update" do
        put("documents/1").should route_to("signature/documents#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("documents/1").should route_to("signature/documents#destroy", :id => "1")
      end

    end

=end

  end
end
