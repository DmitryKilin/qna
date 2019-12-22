require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create ' do
    let(:question) { create(:question) }
    let(:creation_request) { post :create, params: { question_id: question.id }, format: :js }

    context 'Authenticated user' do
      before { login user }
      it 'return 200 for logged user' do
        expect(creation_request).to be_successful
      end
      it 'creates a subscription' do
        expect { creation_request }.to change(question.subscriptions, :count).by(1)
      end
    end
    context 'Unauthenticated user' do
      it 'returns 403.  ' do
        creation_request
        expect(response.status).to eq 403
      end
      it 'does NOT create a subscription' do
        expect { creation_request }.not_to change(question.subscriptions, :count)
      end
    end
  end
  describe 'DELETE #destroy' do
    let(:question) { create(:question, user: user) }
    let!(:subscription) { create(:subscription, user: user, question: question) }
    let(:deletion_request) { delete :destroy, params: { id: subscription.id }, format: :js  }

    context 'Authenticated user' do
      before { login user }
      it 'return 200 for logged user' do
        expect(deletion_request).to be_successful
      end
      it 'destroys a subscription' do
        expect { deletion_request }.to change(Subscription, :count).by(-1)
      end
      it 'deletes a proper subscription.' do
        deletion_request
        expect(Subscription.exists?(subscription.id)).to be_falsey
      end
    end
    context 'Unauthenticated user' do
      it 'return 403 for logged user' do
        deletion_request
        expect(response.status).to eq 403
      end
      it 'destroys a subscription' do
        expect { deletion_request }.not_to change(Subscription, :count)
      end
    end
  end
end
