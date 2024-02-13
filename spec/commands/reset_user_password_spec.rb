describe ResetUserPassword do
  def perform(*_args)
    described_class.for(*_args)
  end

  context "when valid email" do
    let!(:user) { create(:user) }
    let!(:token) { user.reset_password_token }
    let!(:sent_at) { user.reset_password_sent_at }
    let(:mailer) { double }

    before do
      allow(ResetPassword2Mailer).to receive(:notify).and_return(mailer)
      allow(mailer).to receive(:delivery_later)
      perform(user_type: User, email: user.email)
      user.reload
    end

    it { expect(user.reset_password_token).not_to eq(token) }
    it { expect(user.reset_password_sent_at).not_to eq(sent_at) }
    it { expect(user.reset_password_token.size).to eq(64) }

    it "sends email" do
      expect(ResetPassword2Mailer).to have_received(:notify)
      expect(mailer).to have_received(:delivery_later)
    end

    it { expect(perform(user_type: User, email: user.email)).to eq(true) }
  end

  context "when invalid email" do
    let!(:user) { double }
    let(:mailer) { double }

    before do
      allow(ResetPassword2Mailer).to receive(:notify).and_return(mailer)
      allow(mailer).to receive(:delivery_later)
      perform(user_type: User, email: 'fake@platan.us')
    end

    it "sends email" do
      expect(ResetPassword2Mailer).not_to have_received(:notify)
      expect(mailer).not_to have_received(:delivery_later)
    end

    it { expect(perform(user_type: User, email: 'fake@platan.us')).to eq(false) }
  end
end
