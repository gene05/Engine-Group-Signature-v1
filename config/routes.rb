Rails.application.routes.draw do

  root :to => "signature/signatures#trips"

  get 'signature/' => "signature/signatures#trips"

  get 'signature/trips' => "signature/signatures#trips"

  namespace :signature do
    resources :documents
    resources :trips, only: [:new, :create, :edit, :update, :destroy]
    resources :passengers, only: [:index, :new, :create, :edit, :update, :destroy] do
      collection { post :import }
    end
  end

  get 'signature/set_document_summernote/:id' => 'signature/documents#set_document_summernote'

  get 'signature/download/:id' => 'signature/documents#download', as: 'download'

  get 'signature/signatures/trips', as: 'trips'

  get 'signature/signatures/trip/:trip_id/passengers' => 'signature/signatures#passengers', as: 'passengers'

  get 'signature/signatures/trip/:trip_id/passengers/:passenger_id' => 'signature/signatures#signature_check', as: 'signature_check'

  get 'd/:reference' => 'signature/clients#validate_passenger'

  get 'signature/finish_sign' => 'signature/clients#finish_sign'

  get 'signature/sign_document' => 'signature/clients#sign_document', as: 'sign_document'

  get 'signature/passenger_message_error' => 'signature/clients#passenger_message_error', as: 'passenger_message_error'

  get 'signature/download_document_signed/:id' => 'signature/signatures#download_document_signed', as: 'download_document_signed'

  get 'signature/document_signed/:id' => 'signature/signatures#document_signed', as: 'document_signed'


  match 'signature/send_documents/:trip_id', to: 'signature/signatures#send_documents', via: :post

  match 'd/:reference', to: 'signature/clients#sign_next_document', via: :post


end
