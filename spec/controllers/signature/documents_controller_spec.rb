require 'rails_helper'

module Signature
  describe DocumentsController do

    let(:params) { { "title" => "MyString", "content" => "MyStrings" } }
    let(:valid_session) { {} }

    describe 'Index' do
      before (:each) { get :index }
      it { expect(response).to be_success }
      it { expect(response).to render_template :index }
    end

    describe "POST Create" do
      it "assigns the requested document as @document" do
        post :create, {:document => params}, valid_session
        document = Document.last
        assigns(:document).should eq(document)
      end

      it "render json data" do
        post :create, {:document => params}, valid_session
        @expected = {
                :status  => true,
                :notice  => 'Document was successfully created.',
                :document  => Document.last                  
        }.to_json

        response.body.should == @expected
      end
    end

    describe "PUT update" do
      it "assigns the requested document as @document" do
        document = Document.create! params
        put :update, {:id => document.to_param, :document => params}, valid_session
        assigns(:document).should eq(document)
      end

      it "render json data" do
        document = Document.create! params
        put :update, {:id => document.to_param, :document => params}, valid_session
        @expected = {
                :status  => true,
                :notice  => 'Document was successfully updated.',
                :document  => document                  
        }.to_json
        response.body.should == @expected
      end
    end


  end
end
