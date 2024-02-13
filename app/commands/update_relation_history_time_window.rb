class UpdateRelationHistoryTimeWindow < PowerTypes::Command.new(:relation, :time_window, :version)
  def perform
    return if @relation.blank?
    relation_history = @relation.relation_histories.find_by(time_window: @time_window)
    relation_history&.update!(
      # wallet_values: wallet_values,
      balances_values: balances_values
    )
    if relation_history.nil?
      RelationHistory.create!(
        relation: @relation, time_window: @time_window,
        # wallet_values: wallet_values,
        balances_values: balances_values
      )
    end
  end

  private

  def time_windows
    @time_windows ||= {
      'origin': @relation.created_at.to_date,
      'mtd': current_date.beginning_of_month,
      'ytd': current_date.beginning_of_year,
      '1m': current_date - 1.month,
      '3m': current_date - 3.months,
      '6m': current_date - 6.months,
      '1y': current_date - 1.year,
      '5y': current_date - 5.years,
      'complete': @relation.created_at.to_date,
    }
  end

  def current_date
    @current_date ||= Date.current
  end

  def to_date
    @to_date ||= current_date - 1.day
  end

  def from_date
    @from_date ||= time_windows[@time_window.to_sym]
  end

  def step
    return 1 if @time_window == 'complete'
    [(current_date - from_date) / 31, 1].max
  end

  def wallet_values
    WalletBalancesForDates.for(
      from: from_date,
      to: to_date,
      step: step,
      relation: @relation
    ).to_json
  end

  def balances_values
    RelationBalancesForDates.for(
      from: from_date,
      to: to_date,
      step: step,
      relation: @relation,
      version: @version
    ).to_json
  end
end
