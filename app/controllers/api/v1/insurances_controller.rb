# rubocop:disable Layout/LineLength
class Api::V1::InsurancesController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!
  skip_before_action :verify_authenticity_token, if: :json_request?

  def index
    if insurances
      respond_with insurances, root: "insurances"
    else
      render json: { code: 404, message: "SubAccount doesn't exist" }
    end 
  end

  def investment_insurances
    if insurances
      respond_with insurances.where.not(insured_capital: nil), root: "insurances"
    else
      render json: { code: 404, message: "SubAccount doesn't exist" }
    end 
  end

  def create
    ActiveRecord::Base.transaction do
      asset = InvestmentAsset.create!(params_asset_insurances.merge(params_asset_insurances_permit).merge(currency: sub_account.currency))
      asset.update(asset_type: 12) if invesment_param[:investment].present?
      membership = sub_account.memberships.create!(
        create_membership_params.merge(investment_asset_id: asset.id)
      )
      insurance = Insurance.create!(create_params.merge(membership_id: membership.id)) 


      if invesment_param[:investment].present?
        money_movement = membership.money_movements.create!(
          sub_account_id: membership.sub_account_id,
          movement_type: 0,
          average_price: params[:investment],
          quotas: 1,
          date: Time.now
        )
        price_change = asset.price_changes.create!(
          value: params[:investment],
          price_changed_at: Time.current,
          money_movement_id: money_movement.id
        )
        insurance.update(initial_investment: invesment_param[:investment])
      end
      respond_with insurance.membership
    end
  end

  def update
    Insurance.find_by(membership_id: params[:id]).update(create_params)
    respond_with Insurance.find_by(membership_id: params[:id]).membership
  end

  def destroy
    Membership.find(params[:id]).update(hidden: true)
    render json: { code: :ok, message: 'Liability deleted' }, status: :ok 
  end

  def totals
    membership_ids = Relation.find(params[:relation_id]).memberships.where.not(hidden: true).joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type = ?", InvestmentAsset.asset_types[:insurance]).pluck(:id)
    insurance_objects = Insurance.where(membership_id: membership_ids)
    total_prime = insurance_objects.pluck(:prime).reduce(:+)
    total_insured_capital = insurance_objects.pluck(:insured_capital).reduce(:+)
    responce = {
      total_prime: total_prime,
      total_insured_capital: total_insured_capital
    }
    respond_with responce
  end

  def upload_file
    parameters = insurance_file_params
    insurance = Insurance.find_by(membership_id: insurance_file_params[:membership_id])
    parameters[:insurance_id] = insurance.id
    parameters.delete(:membership_id)
    InsuranceFile.where(insurance_id: insurance.id)&.destroy_all
    insurance_file = InsuranceFile.create!(parameters)
    insurance.update(insurance_file_id: insurance_file.id)
    respond_with insurance_file
  end

  def delete_file
    insurance = Insurance.find_by(membership_id: params[:id])
    if insurance.insurance_file.nil?
      message = 'Seguro no tiene archivo asociado' 
    else
      insurance.insurance_file.destroy
      insurance.update(insurance_file_id: nil)
    end
    message ||= 'Archivo destruido'
    render json: {
      message: message
    }
  end

  private

  def insurances
    Membership.where(sub_account_id: sub_account_ids).where.not(hidden: true).joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type = ? OR investment_assets.asset_type = ?", InvestmentAsset.asset_types[:insurance], InvestmentAsset.asset_types[:investment_insurance])
  end

  def insurance
    Insurance.find(params[:id])
  end

  def sub_account_ids
    SubAccount.find_by(id: params['sub_account_id'])
  end

  def sub_account
    SubAccount.find_by(id: sub_account_id)
  end

  def sub_account_id
    params.require(
      :sub_account_id
    )
  end

  def relation_id
    params.require(
      :relation_id
    )
  end

  def params_asset_insurances_permit
    params.permit(
      :name,
    )
  end

  def params_asset_insurances
    {
      is_custom: false,
      valid_asset: true,
      asset_type: 11,
      asset_id: params_insurances_asset_id
    }
  end

  def create_params
    params.permit(
      :name,
      :details,
      :insuree,
      :beneficiary,
      :prime,
      :insured_capital,
      :insurance_file_id,
      :policy_end,
      :policy_renovation
    )
  end

  def edit_params
    params.permit(
      :average_price,
      :movement_type,
      :membership_id,
      :sub_account_id,
      :quotas,
      :date
    )
  end

  def create_membership_params
    params.permit(
      :sub_account_id,
    )
  end

  def params_insurances_asset_id
    "insurances_#{params[:name].parameterize(separator: '_')}_#{params['sub_account_id']}"
  end

  def invesment_param
    params.permit(
      :investment
    )
  end

  def insurance_file_params
    params.permit(
      :file, :membership_id
    )
  end

end
# rubocop:enable Layout/LineLength
