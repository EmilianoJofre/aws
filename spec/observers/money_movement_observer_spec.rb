require 'rails_helper'

describe MoneyMovementObserver do
  def trigger(_type, _event, arg_movement)
    described_class.trigger(_type, _event, arg_movement)
  end

  let(:movement) { create(:money_movement) }
  let(:deleted_by_movement) { create(:money_movement, deleted_by: movement) }

  context "when a money movement is created" do
    context 'when deleted_by is nil' do
      before do
        allow(ProcessMoneyMovementJob).to receive(:perform_later)
      end

      it 'calls process movement job' do
        trigger(:after, :create, movement)
        expect(ProcessMoneyMovementJob).to have_received(:perform_later).once.with(
          movement
        )
      end
    end

    context 'when deleted_by is not nil' do
      it 'changes other movement deleted_by attribute' do
        expect { trigger(:after, :create, deleted_by_movement) }
          .to change { movement.deleted_by }
          .from(nil).to(deleted_by_movement)
      end
    end
  end
end
