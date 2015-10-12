require_dependency "signature/application_controller"

module Signature
  class DocumentsController < ApplicationController
    before_action :set_document, only: [:show, :edit, :update, :download, :destroy, :set_document_summernote]
    before_action :set_message, only: [:index]

    def index
      @documents = Document.list_by_page(page, order, direction)
    end

    def show
    end

    def new
      @document = Document.new
    end

    def edit
    end

    def set_document_summernote
      if @document
        render :json => { status: true, document: @document}
      else
        render :json => { status: false}
      end
    end

    def create
      @document = Document.new(document_params)
      if @document.save
        render :json => { status: true, notice: 'Document was successfully created.', document: @document}
      else
        render :json => { status: false}
      end
    end

    def update
      @document.update(document_params)
      if @document.save
        render :json => { status: true, notice: 'Document was successfully updated.', document: @document}
      else
        render :json => { status: false}
      end
    end

    def destroy
      @document.destroy
      redirect_to documents_url, notice: 'Document was successfully destroyed.'
    end

    def download
    end

    private
      def set_document
        @document = Document.find(params[:id])
      end

      def document_params
        params.require(:document).permit(:title, :content)
      end

      def set_message
        flash[:notice] = "Document successfully "+params[:success] if params[:success]
      end
  end
end
