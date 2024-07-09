# frozen_string_literal: true

require "spec_helper"

describe Decidim::FileAuthorizationHandler::Admin::Permissions do
  subject { described_class.new(user, permission_action, context).permissions.allowed? }

  let(:dummy_component) { create(:dummy_component) }
  let(:organization) { dummy_component.organization }
  let(:user) { create(:user, organization:) }
  let(:context) do
    {
      current_component: dummy_component,
    }
  end
  let(:scope) { :admin }
  let(:auth_subject) { Decidim::FileAuthorizationHandler::CensusDatum }
  let(:action) do
    { scope:, action: action_name, subject: auth_subject }
  end
  let(:permission_action) { Decidim::PermissionAction.new(**action) }

  before do
    organization.update!(available_authorizations: ["file_authorization_handler"])
  end

  context "when action is allowed" do
    [:show, :create, :destroy].each do |action_name|
      let(:action_name) { action_name }

      describe "##{action_name}" do
        it { is_expected.to be true }
      end
    end
  end

  context "when action is NOT allowed" do
    [:manage, :list, :update].each do |action_name|
      let(:action_name) { action_name }

      it_behaves_like "permission is not set"
    end
  end

  context "when scope is not admin" do
    let(:scope) { :public }
    let(:action_name) { :show }

    it_behaves_like "permission is not set"
  end

  context "when subject is not :authorize" do
    let(:action_name) { :admin }
    let(:auth_subject) { :foo }

    it_behaves_like "permission is not set"
  end
end
