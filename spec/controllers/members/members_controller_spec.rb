# frozen_string_literal: true

require "./spec/rails_helper"

describe Members::MembersController do
  let(:member) { create :member, :admin }
  let(:json) { JSON.parse(response.body) }

  before { sign_in member }

  describe "GET #index" do
    let(:get_index) { get :index }

    it "returns a 200" do
      get_index
      expect(response.status).to eq 200
    end
  end

  describe "GET #show" do
    let(:get_show) { get :show, params: { id: member.id } }

    it "returns a 200" do
      get_show
      expect(response.status).to eq 200
    end

    it "assigns @members" do
      expect { get_show }.to change { assigns :member }
    end

    it "renders the show template" do
      expect(get_show).to render_template :show
    end
  end

  describe 'PATCH #update' do
    context 'json' do
      let(:params) { { id: member.id, member: { username: Faker::Internet.user_name }, format: :json } }
      let(:patch_update) { patch :update, params: params }


      context 'valid' do
        it 'updates the member' do
          expect{ patch_update }.to change{ member.reload.username }
        end

        it 'renders JSON response' do
          patch_update
          expect(json['success']).to be_truthy
          expect(json['member']['id']).to eq member.id
        end
      end

      context 'invalid' do
        before { allow_any_instance_of(Member).to receive(:save).and_return false }

        it 'renders JSON response' do
          patch_update
          expect(json['success']).to be_falsey
          expect(json['member']['id']).to eq member.id
        end
      end
    end

    context 'html' do
      let(:params) { { id: member.id, member: { username: Faker::Internet.user_name } } }
      let(:patch_update) { patch :update, params: params }

      it 'updates the member' do
        expect{ patch_update }.to change{ member.reload.username }
      end

      it 'redirects to members#show' do
        patch_update
        member.reload
        expect(response).to redirect_to member_path(member)
      end
    end
  end
end
