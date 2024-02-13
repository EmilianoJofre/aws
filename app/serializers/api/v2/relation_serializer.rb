class Api::V2::RelationSerializer < Api::V2::BaseSerializer
  attributes :id, :name
  attribute :first_name, if: :not_simplified?
  attribute :last_name, if: :not_simplified?
  attributes :rut, :email
  attribute :type, if: :not_simplified?
  attributes :phone
  attribute :internal_id, if: :not_simplified?
  attribute :show_wallet, if: :not_simplified?
  attribute :config
  attribute :active, if: :not_simplified?
  attribute :accounts, if: :deep?
  attribute :advisers, if: :advisers?
  attribute :accounts_quantity, if: :simplified?
  attribute :total_balance, if: :simplified?
  attribute :modules

  def rut
    object.rut.gsub(/\./mi, '').gsub(/\s+/, '') if !object.rut.nil?
  end

  def internal_id
    return "VL-#{rut_number(object.rut)}" if !object.rut.nil?
    return "VL-INVESTOR-#{object.id}"
  end

  def accounts
    object.relation_accounts.map do |account|
      Api::V2::AccountSerializer.new(account, deep: deep?, real_estate: real_estate?)
    end
  end

  def advisers
    object.advisers.map do |adviser|
      Api::V2::AdviserSerializer.new(adviser)
    end
  end

  def accounts_quantity
    object.relation_accounts.count
  end

  def total_balance
    object.updated_balance
  end

  def advisers?
    @instance_options[:advisers]
  end

  def simplified?
    @instance_options[:simplified]
  end

  def not_simplified?
    !@instance_options[:simplified]
  end

  def config
    config = Hash.new
    config['show_profit'] = show_profit
    config
  end

  def show_profit
    return false if object.config_vars.blank?
    object.config_vars["show_profit"].to_s.empty? ? false : object.config_vars["show_profit"]
  end
end
