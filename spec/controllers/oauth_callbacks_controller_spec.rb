require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    allow(request.env).to receive(:[]).and_call_original
    allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
  end

  describe 'Email has not provided.' do
    let!(:oauth_data) { {'provider' => 'vkontakte', 'uid' => 123, 'info' => nil } }

    it 'Redirects to demand_email_path' do

      expect(response).to redirect_to demand_email_path
      # Не могу понять почему вместо редиректа в респонсе выдаётся рендеринг пустого шаблона?:
      # Expected response to be a <3XX: redirect>, but was a <200: OK>
      #
      # В девелоп-окружении всё перенаправляется!
    end
  end

  describe 'GitHub' do
    let(:oauth_data) { {'provider' => 'github', 'uid' => '123', 'info' => { 'email' => 'test@test.com'} } }

    it 'finds user using oauth data' do
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) {create(:user)}
      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user if he exists' do
        expect(subject.current_user).to eq(user)
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does NOT exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does NOT login user' do
        expect(subject.current_user).to_not be
      end

    end
  end
  describe 'VK' do
    let(:oauth_data) { {'provider' => 'vkontakte', 'uid' => '123', 'info' => { 'email' => 'test@test.com'} } }

    it 'finds user using oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :vkontakte
    end

    context 'user exists' do
      let!(:user) {create(:user)}
      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :vkontakte
      end

      it 'login user if he exists' do
        expect(subject.current_user).to eq(user)
      end
      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does NOT exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :vkontakte
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does NOT login user' do
        expect(subject.current_user).to_not be
      end

    end
  end

end
